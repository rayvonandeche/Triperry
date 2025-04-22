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
    return TravelStage.complete;
  }

  /// Generate a response for follow-up questions after planning is complete
  static String handleFollowUpQuestion(String input, String selectedDestination, String travelTime) {
    if (input.contains('restaurant') || input.contains('food') || input.contains('eat')) {
      return "I'd recommend these restaurants in $selectedDestination:\n"
          "• ${getRandomRestaurant()}\n"
          "• ${getRandomRestaurant()}\n"
          "• ${getRandomRestaurant()}";
    } else if (input.contains('hotel') || input.contains('stay') || input.contains('accommodation')) {
      return "Here are some accommodation options in $selectedDestination:\n"
          "• ${getRandomHotel()} - \$\$\n"
          "• ${getRandomHotel()} - \$\$\$\n"
          "• ${getRandomHotel()} - \$\$\$\$";
    } else if (input.contains('modify') || input.contains('change') || input.contains('different')) {
      return "Sure, we can modify your travel plan. What would you like to change? The destination, travel time, or activities?";
    } else {
      return "I'm happy to help with your $travelTime trip to $selectedDestination! Is there anything specific you'd like to know about the itinerary or destination?";
    }
  }

  /// Get a random restaurant name
  static String getRandomRestaurant() {
    final restaurants = [
      "Local Flavor Bistro",
      "Ocean View Restaurant",
      "Mountain Peak Cafe",
      "Urban Table & Bar",
      "Traditional Tastes",
      "Sunset Grill",
      "The Hungry Traveler"
    ];
    restaurants.shuffle();
    return restaurants.first;
  }

  /// Get a random hotel name
  static String getRandomHotel() {
    final hotels = [
      "Traveler's Rest Inn",
      "Grand Plaza Hotel",
      "Seaside Resort & Spa",
      "Mountain View Lodge",
      "City Center Suites",
      "Heritage Boutique Hotel",
      "Panorama Luxury Resort"
    ];
    hotels.shuffle();
    return hotels.first;
  }

  /// Generate a sample itinerary based on selected interest
  static List<ItineraryDay> generateSampleItinerary(String selectedInterest) {
    if (selectedInterest == 'beach') {
      return [
        const ItineraryDay(
          title: "Day 1: Arrival & Beach Relaxation",
          activities: [
            "Morning: Arrive and check in to your accommodation",
            "Afternoon: Visit the main beach and relax",
            "Evening: Sunset dinner at a beachside restaurant"
          ],
        ),
        const ItineraryDay(
          title: "Day 2: Ocean Adventures",
          activities: [
            "Morning: Snorkeling tour to nearby coral reefs",
            "Afternoon: Beach activities or water sports",
            "Evening: Seafood dinner and local entertainment"
          ],
        ),
        const ItineraryDay(
          title: "Day 3: Coastal Exploration",
          activities: [
            "Morning: Hike along coastal trails",
            "Afternoon: Visit to local markets and shops",
            "Evening: Beach bonfire or night swimming"
          ],
        ),
      ];
    } else if (selectedInterest == 'mountain') {
      return [
        const ItineraryDay(
          title: "Day 1: Arrival & Orientation",
          activities: [
            "Morning: Arrive and check in to your accommodation",
            "Afternoon: Short introductory hike to a viewpoint",
            "Evening: Dinner at a local mountain lodge"
          ],
        ),
        const ItineraryDay(
          title: "Day 2: Full Day Trek",
          activities: [
            "Morning: Begin trek to popular mountain trail",
            "Afternoon: Picnic lunch at a scenic spot",
            "Evening: Relax with hot cocoa and mountain views"
          ],
        ),
        const ItineraryDay(
          title: "Day 3: Nature & Wildlife",
          activities: [
            "Morning: Guided nature walk with local expert",
            "Afternoon: Visit to wildlife sanctuary or natural landmark",
            "Evening: Traditional dinner with local specialties"
          ],
        ),
      ];
    } else {
      return [
        const ItineraryDay(
          title: "Day 1: Arrival & City Introduction",
          activities: [
            "Morning: Arrive and check in to your accommodation",
            "Afternoon: Walking tour of main city attractions",
            "Evening: Dinner at a popular local restaurant"
          ],
        ),
        const ItineraryDay(
          title: "Day 2: Cultural Exploration",
          activities: [
            "Morning: Visit to major museums or galleries",
            "Afternoon: Shopping and local markets",
            "Evening: Cultural performance or night tour"
          ],
        ),
        const ItineraryDay(
          title: "Day 3: Local Experiences",
          activities: [
            "Morning: Food tour or cooking class",
            "Afternoon: Visit to historical sites",
            "Evening: Dinner at a well-known restaurant"
          ],
        ),
      ];
    }
  }

  /// Get an image URL for the trip based on the selected interest
  static String getTripImageUrl(String selectedInterest) {
    // Return a relevant image URL based on destination and interest
    if (selectedInterest == 'beach') {
      return 'https://picsum.photos/id/128/600/400';
    } else if (selectedInterest == 'mountain') {
      return 'https://picsum.photos/id/29/600/400';
    } else if (selectedInterest == 'city') {
      return 'https://picsum.photos/id/42/600/400';
    } else {
      return 'https://picsum.photos/id/20/600/400';
    }
  }

  /// Get appropriate message for the assistant based on the current stage
  static String getAssistantMessageForStage(
      TravelStage stage, String selectedInterest, String selectedDestination, String travelTime) {
    switch (stage) {
      case TravelStage.welcome:
        return "Hi! I'm your travel assistant. What kind of trip are you looking for?";
      case TravelStage.interestSelected:
        return "Great choice! Here are some ${selectedInterest.isNotEmpty ? selectedInterest : 'popular'} destinations. Which one interests you?";
      case TravelStage.destinationSelected:
        return "Wonderful! $selectedDestination is an amazing choice. When are you thinking of traveling?";
      case TravelStage.timeSelected:
        return "Perfect! What kind of activities are you interested in for your $travelTime trip to $selectedDestination?";
      case TravelStage.complete:
        return "I've prepared some recommendations for your $travelTime trip to $selectedDestination. Enjoy exploring!";
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
      case TravelStage.complete:
        return "Ask me anything about your trip...";
    }
  }

  /// Get list of activities based on selected interest
  static List<String> getActivitiesForInterest(String selectedInterest) {
    if (selectedInterest == 'beach') {
      return [
        "Swimming & Snorkeling",
        "Beach Relaxation",
        "Water Sports",
        "Coastal Hiking",
        "Local Cuisine"
      ];
    } else if (selectedInterest == 'mountain') {
      return [
        "Hiking & Trekking",
        "Scenic Views",
        "Wildlife Watching",
        "Photography",
        "Local Culture"
      ];
    } else if (selectedInterest == 'city') {
      return [
        "Museums & Galleries",
        "Historical Sites",
        "Shopping",
        "Nightlife",
        "Local Cuisine"
      ];
    } else if (selectedInterest == 'food') {
      return [
        "Food Tours",
        "Cooking Classes",
        "Local Markets",
        "Fine Dining",
        "Street Food"
      ];
    } else {
      return [
        "Sightseeing",
        "Cultural Experiences",
        "Adventure Activities",
        "Relaxation",
        "Local Cuisine"
      ];
    }
  }
}