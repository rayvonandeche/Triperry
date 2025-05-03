import 'package:flutter/material.dart';
import '../models/ai_models.dart';

class AiConversationService {
  /// Process user input for interest selection
  static TravelStage processInterestSelection(
      String input, void Function(String) setSelectedInterest, void Function(List<TravelOption>) setTravelOptions) {
    if (input.contains('beach') || input.contains('ocean') || input.contains('sea')) {
      setSelectedInterest('beach');
      setTravelOptions(beachDestinations);
    } else if (input.contains('mountain') || input.contains('hiking') || input.contains('nature')) {
      setSelectedInterest('mountain');
      setTravelOptions(mountainDestinations);
    } else if (input.contains('city') || input.contains('urban') || input.contains('culture')) {
      setSelectedInterest('city');
      setTravelOptions(cityDestinations);
    } else if (input.contains('food') || input.contains('culinary') || input.contains('cuisine')) {
      setSelectedInterest('food');
      setTravelOptions(culinaryDestinations);
    } else {
      setSelectedInterest('general');
      setTravelOptions(popularDestinations);
    }
    
    return TravelStage.interestSelected;
  }

  /// Process user input for destination selection
  static TravelStage processDestinationSelection(
      String input, 
      List<TravelOption> travelOptions, 
      void Function(String) setSelectedDestination,
      void Function(List<String>) setRecommendations) {
    
    // Find if the user mentioned any of the previously shown destinations
    TravelOption? selectedOption = travelOptions.firstWhere(
      (option) => input.contains(option.name.toLowerCase()),
      orElse: () => travelOptions.first, // Default to first option if no match
    );
    
    setSelectedDestination(selectedOption.name);
    setRecommendations(selectedOption.activities);
    return TravelStage.destinationSelected;
  }

  /// Process user input for travel time selection
  static TravelStage processTravelTime(String input, void Function(String) setTravelTime) {
    if (input.contains('summer') || input.contains('july') || input.contains('august')) {
      setTravelTime("summer");
    } else if (input.contains('winter') || input.contains('december') || input.contains('january')) {
      setTravelTime("winter");
    } else if (input.contains('spring') || input.contains('april') || input.contains('may')) {
      setTravelTime("spring");
    } else if (input.contains('fall') || input.contains('autumn') || input.contains('october')) {
      setTravelTime("fall");
    } else {
      setTravelTime("flexible");
    }
    
    return TravelStage.timeSelected;
  }

  /// Process user input for activity preferences
  static TravelStage processActivityPreferences(String input) {
    // In a real app, this would generate personalized recommendations
    return TravelStage.activitySelected;
  }

  /// Process user input for budget selection
  static TravelStage processBudgetSelection(String input, void Function(BudgetRange) setBudgetRange) {
    if (input.contains('budget') || input.contains('cheap') || input.contains('affordable')) {
      setBudgetRange(budgetRanges[0]);
    } else if (input.contains('mid') || input.contains('moderate') || input.contains('average')) {
      setBudgetRange(budgetRanges[1]);
    } else if (input.contains('luxury') || input.contains('premium') || input.contains('high')) {
      setBudgetRange(budgetRanges[2]);
    } else {
      setBudgetRange(budgetRanges[1]); // Default to mid-range
    }
    
    return TravelStage.complete;
  }

  /// Generate a sample itinerary based on selected interest
  static List<ItineraryDay> generateSampleItinerary(String selectedInterest) {
    switch (selectedInterest) {
      case 'beach':
        return [
          ItineraryDay(
            title: "Day 1: Arrival & Beach Relaxation",
            activities: [
              ItineraryActivity(
                title: "Airport Transfer",
                description: "Private transfer to your beachfront resort",
                time: "2:00 PM",
                duration: 45,
              ),
              ItineraryActivity(
                title: "Beach Welcome",
                description: "Relax on the pristine beach with welcome drinks",
                time: "3:00 PM",
                duration: 120,
              ),
              ItineraryActivity(
                title: "Sunset Dinner",
                description: "Fresh seafood dinner by the ocean",
                time: "7:00 PM",
                price: 75.0,
              ),
            ],
            imageUrl: "https://picsum.photos/id/42/600/400",
            weather: "Sunny",
            temperature: 28.0,
          ),
          ItineraryDay(
            title: "Day 2: Water Adventures",
            activities: [
              ItineraryActivity(
                title: "Snorkeling Tour",
                description: "Explore vibrant coral reefs and marine life",
                time: "9:00 AM",
                duration: 180,
                price: 45.0,
              ),
              ItineraryActivity(
                title: "Beach Lunch",
                description: "Local cuisine at beachside restaurant",
                time: "1:00 PM",
                price: 35.0,
              ),
              ItineraryActivity(
                title: "Sunset Cruise",
                description: "Relaxing boat tour with drinks and snacks",
                time: "5:00 PM",
                duration: 120,
                price: 60.0,
              ),
            ],
            imageUrl: "https://picsum.photos/id/43/600/400",
            weather: "Partly Cloudy",
            temperature: 27.0,
          ),
        ];
      // Add more cases for other interests...
      default:
        return [];
    }
  }

  /// Get input hint text based on the current stage
  static String getInputHintForStage(TravelStage stage) {
    switch (stage) {
      case TravelStage.welcome:
        return "What kind of trip are you looking for?";
      case TravelStage.interestSelected:
        return "Which destination interests you?";
      case TravelStage.destinationSelected:
        return "When would you like to travel?";
      case TravelStage.timeSelected:
        return "What activities are you interested in?";
      case TravelStage.activitySelected:
        return "What's your budget range?";
      case TravelStage.budgetSelected:
        return "Would you like to see recommendations?";
      case TravelStage.complete:
        return "Ask me anything about your trip...";
    }
  }

  /// Get assistant message for the current stage
  static String getAssistantMessageForStage(
    TravelStage stage,
    String selectedInterest,
    String selectedDestination,
    String travelTime,
  ) {
    switch (stage) {
      case TravelStage.welcome:
        return "Hi! I'm your AI travel assistant. Let's plan your perfect trip!";
      case TravelStage.interestSelected:
        return "Great choice! Here are some amazing destinations for $selectedInterest lovers:";
      case TravelStage.destinationSelected:
        return "Perfect! $selectedDestination is an excellent choice. When would you like to visit?";
      case TravelStage.timeSelected:
        return "I see you're planning a $travelTime trip to $selectedDestination. What activities interest you?";
      case TravelStage.activitySelected:
        return "I've noted your activity preferences. What's your budget range?";
      case TravelStage.budgetSelected:
        return "Thanks! I'll create a personalized itinerary within your budget.";
      case TravelStage.complete:
        return "Here's your personalized trip plan for $selectedDestination!";
    }
  }

  /// Handle follow-up questions in the complete stage
  static String handleFollowUpQuestion(String input, String selectedDestination, String travelTime) {
    if (input.contains('weather') || input.contains('temperature')) {
      return "The weather in $selectedDestination during $travelTime is typically perfect for travel!";
    } else if (input.contains('hotel') || input.contains('accommodation')) {
      return "I can recommend some great hotels in $selectedDestination. Would you like to see options?";
    } else if (input.contains('food') || input.contains('restaurant')) {
      return "There are many amazing restaurants in $selectedDestination. I can suggest some based on your preferences.";
    } else {
      return "I'd be happy to help with that! What specific information would you like about $selectedDestination?";
    }
  }

  /// Get activities based on interest category
  static List<String> getActivitiesForInterest(String interest) {
    switch (interest.toLowerCase()) {
      case 'beach':
        return [
          'Snorkeling',
          'Sunbathing',
          'Beach Volleyball',
          'Surfing',
          'Beach Yoga',
          'Jet Skiing',
          'Parasailing',
          'Beach Picnic',
          'Sunset Cruise',
          'Beach Photography'
        ];
      case 'mountain':
        return [
          'Hiking',
          'Mountain Biking',
          'Rock Climbing',
          'Camping',
          'Photography',
          'Wildlife Watching',
          'Mountain Yoga',
          'Stargazing',
          'Skiing',
          'Snowboarding'
        ];
      case 'city':
        return [
          'Museum Tours',
          'Shopping',
          'Food Tours',
          'Architecture',
          'Nightlife',
          'Local Markets',
          'City Walks',
          'Cultural Shows',
          'Public Transport',
          'Street Photography'
        ];
      case 'adventure':
        return [
          'Zip Lining',
          'White Water Rafting',
          'Bungee Jumping',
          'Scuba Diving',
          'Paragliding',
          'Cave Exploring',
          'ATV Riding',
          'Cliff Jumping',
          'Wildlife Safari',
          'Off-Roading'
        ];
      default:
        return [
          'Local Cuisine',
          'Cultural Experiences',
          'Photography',
          'Shopping',
          'Nature Walks',
          'Historical Sites',
          'Local Markets',
          'Art Galleries',
          'Music & Dance',
          'Relaxation'
        ];
    }
  }
}