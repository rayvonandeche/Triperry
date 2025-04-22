import 'dart:async';
import 'dart:convert';
import 'query_handler.dart';
import 'prompt_response_service.dart';
import 'package:http/http.dart' as http;

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class GeminiServiceHttpStream {
  // Stream controller for chat messages
  final StreamController<String> _responseStreamController = StreamController<String>.broadcast();
  Stream<String> get responseStream => _responseStreamController.stream;
  
  // Stream controller for completion events
  final StreamController<bool> _responseCompleteController = StreamController<bool>.broadcast();
  Stream<bool> get responseCompleteStream => _responseCompleteController.stream;
  
  // Flag to control streaming
  bool _isCancelled = false;

  // A method to get the response stream (used by ai_page.dart and ai_travel_chat.dart)
  Stream<String> getResponseStream(String prompt, {List<Map<String, Object>>? history, Map<String, dynamic>? generationConfig}) {
    // Reset cancellation flag
    _isCancelled = false;
    
    // In real implementation, this would call the Gemini API with history and generation config
    // Here we just call the existing demo implementation
    sendMessage(prompt, generationConfig: generationConfig);
    
    // Return the stream
    return responseStream;
  }
  
  // Method to stop an ongoing response
  void stopResponse() {
    _isCancelled = true;
  }

  // A simplified response generator for demo purposes
  Future<void> sendMessage(String message, {Map<String, dynamic>? generationConfig}) async {
    // In real implementation, this would call the Gemini API
    // For now, generate sample responses based on keywords in the message
    
    // Add a slight delay to simulate network latency
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Handle family activities in Paris with special combined response
    if ((message.toLowerCase().contains('family') || message.toLowerCase().contains('kid')) && 
        (message.toLowerCase().contains('paris') || message.toLowerCase().contains('france')) && 
        (message.toLowerCase().contains('activit') || message.toLowerCase().contains('things to do'))) {
      _startStreamingResponse(PromptResponseService.getParisWithFamilyResponse());
    }
    // Use structured JSON when requested
    else if (generationConfig != null && generationConfig['response_mime_type'] == 'application/json') {
      _startStreamingResponse(_generateStructuredResponse(message, generationConfig));
    } 
    // Use Markdown for all other responses
    else {
      _startStreamingResponse(_generateDemoResponse(message));
    }
  }
  
  // Stream the response to simulate a real-time API response
  void _startStreamingResponse(String response) async {
    // For JSON responses, send the entire string at once to prevent malformed JSON
    if (response.trim().startsWith('{') && response.trim().endsWith('}')) {
      _responseStreamController.add(response);
      _responseCompleteController.add(true);
      return;
    }

    // For non-JSON responses, stream word by word
    final words = response.split(' ');
    for (var word in words) {
      if (_isCancelled) {
        _responseCompleteController.add(true);
        return;
      }
      
      _responseStreamController.add('$word ');
      await Future.delayed(Duration(milliseconds: 12 + (30 * DateTime.now().millisecond % 3).round()));
    }
    
    _responseCompleteController.add(true);
  }
  
  // Generate structured JSON responses based on the schema
  String _generateStructuredResponse(String message, Map<String, dynamic> config) {
    // Detect intent from the query
    final intent = QueryHandler.detectIntent(message);
    
    // Get structured response from our service
    final responseData = PromptResponseService.getStructuredResponse(message, intent);
    
    // Convert Map to JSON string
    return jsonEncode(responseData);
  }
  
  // Generate demo responses based on keywords in the user's message with Markdown formatting
  String _generateDemoResponse(String message) {
    // Get Markdown response from our service
    return PromptResponseService.getMarkdownResponse(message);
  }
  
  // Close the stream controllers when done
  void dispose() {
    _responseStreamController.close();
    _responseCompleteController.close();
  }
}

class GeminiService {
  final String _apiKey; // Store API key securely in a real app
  final String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
  final String _model = 'gemini-1.5-pro';
  
  GeminiService(this._apiKey);
  
  // Method to generate content with Gemini API via REST
  Future<Map<String, dynamic>> generateContent({
    required String prompt,
    Map<String, Object>? structuredOutputConfig,
    double temperature = 1.0,
    int maxOutputTokens = 800,
  }) async {
    final Uri uri = Uri.parse('$_baseUrl/$_model:generateContent?key=$_apiKey');
    
    // Build the request body
    final Map<String, dynamic> requestBody = {
      'contents': [
        {
          'role': 'user',
          'parts': [
            {
              'text': prompt
            }
          ]
        }
      ],
      'generationConfig': {
        'temperature': temperature,
        'maxOutputTokens': maxOutputTokens,
      }
    };
    
    // Add structured output configuration if provided
    if (structuredOutputConfig != null) {
      requestBody['generationConfig']['structuredOutputSchema'] = 
          structuredOutputConfig['response_schema'];
      
      // Add other generation config parameters if they exist
      if (structuredOutputConfig.containsKey('temperature')) {
        requestBody['generationConfig']['temperature'] = structuredOutputConfig['temperature'];
      }
      
      if (structuredOutputConfig.containsKey('maxOutputTokens')) {
        requestBody['generationConfig']['maxOutputTokens'] = structuredOutputConfig['maxOutputTokens'];
      }
      
      if (structuredOutputConfig.containsKey('topK')) {
        requestBody['generationConfig']['topK'] = structuredOutputConfig['topK'];
      }
      
      if (structuredOutputConfig.containsKey('topP')) {
        requestBody['generationConfig']['topP'] = structuredOutputConfig['topP'];
      }
    }
    
    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        print('Error from Gemini API: ${response.body}');
        throw Exception('Failed to generate content: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception when calling Gemini API: $e');
      throw Exception('Failed to connect to Gemini API: $e');
    }
  }
  
  // Method to parse the Gemini response into a simpler format
  Map<String, dynamic>? parseGeminiResponse(Map<String, dynamic> response) {
    try {
      // First check if there's any content
      if (!response.containsKey('candidates') || 
          response['candidates'].isEmpty ||
          !response['candidates'][0].containsKey('content')) {
        return null;
      }
      
      final content = response['candidates'][0]['content'];
      
      // Check if this is a structured output response (JSON format)
      if (content.containsKey('parts') && 
          content['parts'].isNotEmpty && 
          content['parts'][0].containsKey('text')) {
        final String textContent = content['parts'][0]['text'];
        
        // Try to extract JSON from the response
        try {
          // Look for JSON pattern in the text (in case there's text before or after the JSON)
          final RegExp jsonRegex = RegExp(r'(\{.*\})', dotAll: true);
          final match = jsonRegex.firstMatch(textContent);
          
          if (match != null) {
            final jsonString = match.group(1);
            return jsonDecode(jsonString!);
          }
          
          // If no match with regex, try parsing the full text as JSON
          return jsonDecode(textContent);
        } catch (e) {
          // If not valid JSON, return the text as is
          return {'text': textContent};
        }
      }
      
      return null;
    } catch (e) {
      print('Error parsing Gemini response: $e');
      return null;
    }
  }
  
  // Helper method to handle search grounding via REST API
  Future<Map<String, dynamic>> performSearchGrounding(String query) async {
    try {
      // Use Google Custom Search API for search grounding
      final String customSearchApiKey = _apiKey; // You may want to use a different API key for Custom Search
      final String searchEngineId = const String.fromEnvironment('SEARCH_ENGINE_ID', defaultValue: ''); 
      
      // Check if search engine ID is provided
      if (searchEngineId.isEmpty) {
        print('Warning: Search engine ID not configured. Using mock data.');
        // Return mock search results during development
        await Future.delayed(const Duration(milliseconds: 800));
        return _getMockSearchResults(query);
      }
      
      final Uri searchUri = Uri.parse(
          'https://customsearch.googleapis.com/customsearch/v1?key=$customSearchApiKey&cx=$searchEngineId&q=${Uri.encodeComponent(query)}');
      
      // Toggle between mock and real API calls based on configuration
      if (const bool.fromEnvironment('USE_MOCK_SEARCH', defaultValue: true)) {
        // Return mock search results during development
        await Future.delayed(const Duration(milliseconds: 800));
        return _getMockSearchResults(query);
      } else {
        // In production, make the actual API call
        final response = await http.get(searchUri);
        if (response.statusCode == 200) {
          final rawData = jsonDecode(response.body);
          
          // Extract and structure the most relevant information from the search results
          final List<dynamic> items = rawData['items'] ?? [];
          final results = items.map((item) => {
            'title': item['title'],
            'snippet': item['snippet'],
            'link': item['link'],
            'source': item['displayLink'] ?? '',
            'image': item['pagemap']?['cse_image']?[0]?['src'],
          }).toList();
          
          return {
            'searchQuery': query,
            'results': results
          };
        } else {
          print('Search API error: ${response.statusCode} - ${response.body}');
          throw Exception('Failed to search: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Search grounding error: $e');
      return {
        'searchQuery': query,
        'error': e.toString(),
        'results': []
      };
    }
  }
  
  // Helper method to generate mock search results
  Map<String, dynamic> _getMockSearchResults(String query) {
    // Normalize the query to extract key concepts
    final cleanQuery = query.toLowerCase();
    
    // Check for travel-related keywords
    final bool hasTravelKeyword = 
        cleanQuery.contains('travel') || 
        cleanQuery.contains('vacation') || 
        cleanQuery.contains('trip') ||
        cleanQuery.contains('visit');
        
    // Check for destination names
    final bool hasDestination = 
        cleanQuery.contains('paris') || 
        cleanQuery.contains('tokyo') || 
        cleanQuery.contains('new york') ||
        cleanQuery.contains('bali') ||
        cleanQuery.contains('rome');
    
    // Generate contextually relevant mock results
    if (hasTravelKeyword && hasDestination) {
      return _getDestinationTravelResults(query);
    } else if (hasTravelKeyword) {
      return _getGeneralTravelResults(query);
    } else {
      return _getDefaultSearchResults(query);
    }
  }
  
  Map<String, dynamic> _getDestinationTravelResults(String query) {
    // Extract destination from query (simple approach)
    String destination = '';
    for (final place in ['paris', 'tokyo', 'new york', 'bali', 'rome']) {
      if (query.toLowerCase().contains(place)) {
        destination = place.substring(0, 1).toUpperCase() + place.substring(1);
        break;
      }
    }
    
    return {
      'searchQuery': query,
      'results': [
        {
          'title': 'Travel Guide: $destination - Best Attractions & Activities',
          'snippet': 'Discover the best places to visit in $destination. Our comprehensive guide covers top attractions, accommodations, local cuisine, and insider tips.',
          'link': 'https://example.com/travel-guide/$destination',
          'source': 'example.com',
          'image': 'https://example.com/images/$destination-skyline.jpg'
        },
        {
          'title': 'Top 10 Must-Visit Places in $destination for Travelers',
          'snippet': 'Looking for the best things to do in $destination? Check out our list of top-rated activities and attractions recommended by experienced travelers.',
          'link': 'https://example.com/top-attractions/$destination',
          'source': 'travelexample.com',
          'image': 'https://example.com/images/$destination-attraction.jpg'
        },
        {
          'title': 'Best Time to Visit $destination: Weather & Seasonal Guide',
          'snippet': 'Plan your trip to $destination with our seasonal guide. Learn about weather patterns, local festivals, off-peak bargains, and how to avoid crowds.',
          'link': 'https://example.com/best-time/$destination',
          'source': 'travelweather.com',
          'image': 'https://example.com/images/$destination-seasons.jpg'
        }
      ]
    };
  }
  
  Map<String, dynamic> _getGeneralTravelResults(String query) {
    return {
      'searchQuery': query,
      'results': [
        {
          'title': 'Travel Planning Guide: How to Plan the Perfect Trip',
          'snippet': 'Expert advice on planning your next vacation. From budgeting and booking flights to packing tips and finding hidden gems at your destination.',
          'link': 'https://example.com/travel-planning-guide',
          'source': 'travelplanner.com',
          'image': 'https://example.com/images/travel-planning.jpg'
        },
        {
          'title': 'Top Travel Destinations for 2025',
          'snippet': 'Discover the hottest travel destinations for 2025. From emerging cities to classic favorites with new attractions, find your next adventure here.',
          'link': 'https://example.com/top-destinations-2025',
          'source': 'traveldestinations.com',
          'image': 'https://example.com/images/destinations-2025.jpg'
        },
        {
          'title': 'Budget Travel Tips: See More for Less',
          'snippet': 'Learn how to stretch your travel budget with our expert tips. Find deals on flights, accommodations, and activities without sacrificing quality.',
          'link': 'https://example.com/budget-travel-tips',
          'source': 'budgettraveler.com',
          'image': 'https://example.com/images/budget-travel.jpg'
        }
      ]
    };
  }
  
  Map<String, dynamic> _getDefaultSearchResults(String query) {
    return {
      'searchQuery': query,
      'results': [
        {
          'title': 'Search Results for: $query',
          'snippet': 'Explore information related to your search for $query. Browse top articles, guides, and resources.',
          'link': 'https://example.com/search-results?q=$query',
          'source': 'example.com',
          'image': 'https://example.com/images/search.jpg'
        },
        {
          'title': 'Everything You Need to Know About $query',
          'snippet': 'A comprehensive guide covering all aspects of $query. Expert insights, data, and practical information.',
          'link': 'https://example.com/guide/$query',
          'source': 'knowledgebase.com',
          'image': 'https://example.com/images/guide.jpg'
        },
        {
          'title': '$query - Latest News and Updates',
          'snippet': 'Stay up to date with the latest developments related to $query. Breaking news, analysis, and expert commentary.',
          'link': 'https://example.com/news/$query',
          'source': 'newsexample.com',
          'image': 'https://example.com/images/news.jpg'
        }
      ]
    };
  }
}
