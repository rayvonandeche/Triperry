import 'dart:async';
import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'gemini_service.dart';
import 'travel_data_service.dart';

/// Specialized Gemini service for the travel assistant
/// Uses RAG (Retrieval Augmented Generation) with dummy travel data
class TravelGeminiService {
  final GeminiService _geminiService;
  final TravelDataService _travelDataService = TravelDataService();
  final StreamController<String> _responseStreamController = StreamController<String>.broadcast();
  final StreamController<bool> _responseCompleteController = StreamController<bool>.broadcast();
  bool _isCancelled = false;
  
  /// Stream of response chunks for real-time UI updates
  Stream<String> get responseStream => _responseStreamController.stream;
  
  /// Stream that emits true when a response is complete
  Stream<bool> get responseCompleteStream => _responseCompleteController.stream;

  TravelGeminiService(String apiKey) : _geminiService = GeminiService(apiKey);

  /// Processes a user query through the travel assistant flow
  /// Uses RAG to enhance responses with travel-specific information
  Stream<String> getResponseStream(
    String userQuery, 
    {required String currentStage, 
     String? selectedInterest,
     String? selectedDestination,
     String? travelTime,
    }
  ) {
    // Reset cancellation flag
    _isCancelled = false;
    
    // Process the query based on the current conversation stage
    _processQueryWithRAG(
      userQuery, 
      currentStage, 
      selectedInterest, 
      selectedDestination, 
      travelTime
    );
    
    return responseStream;
  }
  
  /// Stops an ongoing streaming response
  void stopResponse() {
    _isCancelled = true;
  }
  
  /// Processes a query using RAG and streams the response
  Future<void> _processQueryWithRAG(
    String userQuery, 
    String currentStage,
    String? selectedInterest,
    String? selectedDestination,
    String? travelTime,
  ) async {
    try {
      // 1. Retrieve contextually relevant information based on the conversation stage
      final contextData = await _retrieveRelevantContext(
        userQuery, 
        currentStage, 
        selectedInterest, 
        selectedDestination, 
        travelTime
      );
      
      // 2. Construct a RAG-enhanced prompt with the retrieved context
      final ragPrompt = _constructRagPrompt(userQuery, currentStage, contextData);
      
      // 3. In MVP, decide whether to use real API or mock responses
      if (const bool.fromEnvironment('USE_MOCK_RESPONSES', defaultValue: true)) {
        // Use mock responses during development
        _streamMockResponse(userQuery, currentStage, selectedInterest, selectedDestination);
      } else {
        // Call the real Gemini API with the RAG-enhanced prompt
        await _callGeminiAndStreamResponse(ragPrompt, currentStage);
      }
    } catch (e) {
      print('Error in RAG processing: $e');
      _responseStreamController.add("I'm sorry, I encountered an error while processing your request.");
      _responseCompleteController.add(true);
    }
  }
  
  /// Retrieves contextually relevant information for the current conversation stage
  Future<Map<String, dynamic>> _retrieveRelevantContext(
    String userQuery,
    String currentStage,
    String? selectedInterest,
    String? selectedDestination,
    String? travelTime,
  ) async {
    // This would be a database or vector search in a real app
    // For MVP, we'll use the dummy data service
    
    Map<String, dynamic> context = {};
    
    switch (currentStage) {
      case 'welcome':
        // Get information about travel interests
        context['interests'] = _travelDataService.getTravelInterests();
        break;
        
      case 'interestSelected':
        // Get destinations matching the interest
        if (selectedInterest != null) {
          context['destinations'] = _travelDataService.getDestinationsForInterest(selectedInterest);
          context['interestInfo'] = _travelDataService.getInterestInformation(selectedInterest);
        }
        break;
        
      case 'destinationSelected':
        // Get specific information about the selected destination
        if (selectedDestination != null) {
          context['destinationInfo'] = _travelDataService.getDestinationDetails(selectedDestination);
          context['travelTimes'] = _travelDataService.getBestTimesToTravel(selectedDestination);
        }
        break;
        
      case 'timeSelected':
        // Get activities relevant to destination and time
        if (selectedDestination != null && travelTime != null) {
          context['activities'] = _travelDataService.getActivitiesForDestinationAndTime(
            selectedDestination, travelTime);
          context['seasonalInfo'] = _travelDataService.getSeasonalInformation(
            selectedDestination, travelTime);
        }
        break;
        
      case 'complete':
        // Get comprehensive information for itinerary
        if (selectedDestination != null && travelTime != null) {
          context['itineraryIdeas'] = _travelDataService.getSampleItinerary(
            selectedDestination, travelTime, selectedInterest ?? 'general');
          context['accommodations'] = _travelDataService.getAccommodationOptions(selectedDestination);
          context['travelTips'] = _travelDataService.getTravelTips(selectedDestination, travelTime);
        }
        break;
    }
    
    // Optional: Enhance with search grounding if query is complex
    if (userQuery.length > 15 && selectedDestination != null) {
      try {
        final searchContext = await _geminiService.performSearchGrounding(
          '$selectedDestination travel $userQuery');
        context['searchResults'] = searchContext;
      } catch (e) {
        print('Search grounding failed: $e');
        // Continue without search results
      }
    }
    
    return context;
  }
  
  /// Constructs a RAG prompt that includes retrieved context
  String _constructRagPrompt(String userQuery, String currentStage, Map<String, dynamic> contextData) {
    // Base prompt structure
    final StringBuffer prompt = StringBuffer();
    
    // System instruction
    prompt.writeln("""
You are a knowledgeable travel assistant helping a user plan their perfect trip.
Current conversation stage: $currentStage
User query: "$userQuery"

Here is relevant information to help you respond accurately:
""");

    // Add relevant context from our data
    contextData.forEach((key, value) {
      prompt.writeln('--- $key ---');
      if (value is Map || value is List) {
        prompt.writeln(json.encode(value));
      } else {
        prompt.writeln(value.toString());
      }
      prompt.writeln();
    });
    
    // Response formatting instructions based on stage
    prompt.writeln("""
Based on this information, provide a helpful, conversational response to the user's query.
Keep your response focused on travel advice and planning.
""");

    // Add structured output instructions if needed
    if (currentStage == 'complete') {
      prompt.writeln("""
Format your response as a travel itinerary with daily activities, organized by day.
Include practical tips relevant to the destination and season.
""");
    }
    
    return prompt.toString();
  }
  
  /// Calls the Gemini API with RAG-enhanced prompt and streams the response
  Future<void> _callGeminiAndStreamResponse(String ragPrompt, String currentStage) async {
    try {
      // Configure the API request based on the stage
      double temperature = 0.7; // Default
      int maxTokens = 800;
      
      if (currentStage == 'complete') {
        // More creativity for itinerary generation
        temperature = 0.8;
        maxTokens = 1200;
      } else if (currentStage == 'welcome' || currentStage == 'interestSelected') {
        // More focused for recommendations
        temperature = 0.4;
        maxTokens = 500;
      }
      
      // Call the Gemini API
      final response = await _geminiService.generateContent(
        prompt: ragPrompt,
        temperature: temperature,
        maxOutputTokens: maxTokens,
      );
      
      // Parse and stream the response
      final parsedResponse = _geminiService.parseGeminiResponse(response);
      if (parsedResponse != null && parsedResponse.containsKey('text')) {
        _streamResponseByWord(parsedResponse['text']);
      } else {
        throw Exception('Unable to parse response');
      }
    } catch (e) {
      print('Error calling Gemini API: $e');
      _responseStreamController.add("I'm sorry, I couldn't connect to my travel knowledge. Let's try again.");
      _responseCompleteController.add(true);
    }
  }
  
  /// Streams a text response word by word to simulate typing
  void _streamResponseByWord(String response) async {
    final words = response.split(' ');
    
    for (var word in words) {
      if (_isCancelled) {
        _responseCompleteController.add(true);
        return;
      }
      
      _responseStreamController.add('$word ');
      
      // Random delay to make it feel more natural
      await Future.delayed(Duration(milliseconds: 20 + (DateTime.now().millisecond % 40)));
    }
    
    _responseCompleteController.add(true);
  }
  
  /// Provides mock responses for development
  void _streamMockResponse(
    String userQuery, 
    String currentStage, 
    String? selectedInterest,
    String? selectedDestination,
  ) async {
    String response = '';
    
    // Generate appropriate mock responses based on stage and query
    switch (currentStage) {
      case 'welcome':
        if (userQuery.toLowerCase().contains('beach')) {
          response = "I see you're interested in beach destinations! Beaches offer relaxation, water activities, and beautiful scenery. Some popular beach destinations include Bali in Indonesia, the Maldives, and the Amalfi Coast in Italy. Would you like to explore options in any of these regions?";
        } else if (userQuery.toLowerCase().contains('mountain')) {
          response = "Mountain destinations are perfect for adventure and breathtaking views! The Swiss Alps, Patagonia, and the Canadian Rockies offer amazing hiking, scenic vistas, and outdoor activities. Which of these mountain regions interests you most?";
        } else {
          response = "Based on your interests, I'd recommend exploring either beautiful beach destinations like Bali or the Maldives, mountain escapes like the Swiss Alps or Patagonia, vibrant cities like Tokyo or Barcelona, or culinary journeys to places like Lyon or Bangkok. What type of experience are you looking for?";
        }
        break;
        
      case 'interestSelected':
        if (selectedInterest == 'beach') {
          response = "Bali is an excellent choice for beach lovers! It offers stunning beaches like Kuta, Seminyak, and the more secluded Nusa Dua. Beyond beaches, you can explore temples, rice terraces, and enjoy amazing local cuisine. When would you like to visit Bali?";
        } else if (selectedInterest == 'mountain') {
          response = "The Swiss Alps are breathtaking year-round! In summer, you can enjoy hiking, mountain biking, and paragliding. Winter brings world-class skiing and snowboarding. The scenery is absolutely stunning with picturesque villages nestled among towering peaks. When are you thinking of visiting?";
        } else {
          response = "Tokyo is a fascinating blend of ultramodern and traditional! You can explore ancient temples, shop in futuristic districts like Shibuya, enjoy world-class cuisine, and experience unique cultural activities. The city is efficiently connected by an amazing train system making exploration easy. When would you like to visit Tokyo?";
        }
        break;
        
      case 'destinationSelected':
        response = "Great choice! For your trip to $selectedDestination, the best time to visit depends on what you want to experience. Summer (June-August) offers warm weather perfect for outdoor activities and festivals. Spring (March-May) brings beautiful blooms and mild temperatures. Fall (September-November) has gorgeous foliage and fewer tourists. Winter (December-February) is ideal for winter sports and holiday festivities. When were you thinking of going?";
        break;
        
      case 'timeSelected':
        response = "For activities in $selectedDestination, I would recommend exploring the local cuisine through food tours or cooking classes, visiting cultural sites and museums, enjoying outdoor activities like hiking or beach time depending on the location, and experiencing local entertainment. What types of activities interest you most?";
        break;
        
      case 'complete':
        response = """Here's a sample 3-day itinerary for $selectedDestination:

**Day 1: Arrival & Orientation**
- Morning: Arrive and check in to your accommodation
- Afternoon: Take a walking tour of the main attractions
- Evening: Enjoy dinner at a popular local restaurant

**Day 2: Cultural Exploration**
- Morning: Visit the top-rated museum or historical site
- Afternoon: Shopping at local markets and boutiques
- Evening: Attend a cultural performance or night tour

**Day 3: Local Experiences**
- Morning: Participate in a food tour or cooking class
- Afternoon: Relax at a park or beach (location dependent)
- Evening: Farewell dinner at a highly-rated restaurant

I can help you refine this itinerary based on your specific interests or help you find accommodation options. What would you like to do next?""";
        break;
    }
    
    // Stream the response word by word
    _streamResponseByWord(response);
  }
  
  /// Closes stream controllers
  void dispose() {
    _responseStreamController.close();
    _responseCompleteController.close();
  }
}