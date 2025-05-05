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
  static TravelStage processActivityPreferences(String input, void Function(String) onActivitiesSelected) {
    String activities = "general activities";
    
    if (input.contains('adventure') || input.contains('hiking') || input.contains('outdoor')) {
      activities = "adventure and outdoor activities";
    } else if (input.contains('relax') || input.contains('spa') || input.contains('beach')) {
      activities = "relaxation and leisure activities";
    } else if (input.contains('culture') || input.contains('museum') || input.contains('history')) {
      activities = "cultural and historical activities";
    } else if (input.contains('food') || input.contains('dining') || input.contains('cuisine')) {
      activities = "food and dining experiences";
    } else if (input.contains('shop') || input.contains('market') || input.contains('mall')) {
      activities = "shopping and market experiences";
    }
    
    onActivitiesSelected(activities);
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
    
    return TravelStage.budgetSelected;
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
        return "Hi there! 👋 I'm your AI travel assistant. I can help you plan your dream vacation. What kind of destination are you interested in?";
      case TravelStage.interestSelected:
        return "Great choice! $selectedInterest destinations are amazing. Where would you like to go?";
      case TravelStage.destinationSelected:
        return "Excellent! $selectedDestination is a wonderful choice. When are you planning to travel?";
      case TravelStage.timeSelected:
        return "$travelTime is a perfect time to visit $selectedDestination! What kind of activities are you interested in?";
      case TravelStage.activitySelected:
        return "Those activities sound fun! What's your budget range for this trip?";
      case TravelStage.budgetSelected:
        return "Perfect! I've prepared some recommendations for your trip to $selectedDestination.";
      case TravelStage.complete:
        return "Here's your personalized trip plan for $selectedDestination! Is there anything else you'd like to know?";
    }
  }

  /// Handle follow-up questions in the complete stage
  static String handleFollowUpQuestion(String input, String selectedDestination, String travelTime) {
    final question = input.toLowerCase();
    
    if (question.contains('weather') || question.contains('temperature') || question.contains('climate')) {
      return _generateWeatherResponse(selectedDestination, travelTime);
    } 
    else if (question.contains('currency') || question.contains('money') || question.contains('exchange')) {
      return _generateCurrencyResponse(selectedDestination);
    }
    else if (question.contains('language') || question.contains('speak')) {
      return _generateLanguageResponse(selectedDestination);
    }
    else if (question.contains('food') || question.contains('eat') || question.contains('cuisine') || question.contains('restaurant')) {
      return _generateFoodResponse(selectedDestination);
    }
    else if (question.contains('safety') || question.contains('safe')) {
      return _generateSafetyResponse(selectedDestination);
    }
    else if (question.contains('transport') || question.contains('get around')) {
      return _generateTransportResponse(selectedDestination);
    }
    else if (question.contains('visa') || question.contains('passport')) {
      return _generateVisaResponse(selectedDestination);
    }
    else {
      // Generic response for other questions
      return "That's a great question about $selectedDestination! While I don't have the specific information right now, our team can provide you with all the details once your booking is confirmed. Would you like to know anything else?";
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
  
  // Helper methods to generate responses to common follow-up questions
  
  static String _generateWeatherResponse(String destination, String travelTime) {
    // Logic to determine season based on destination and travel time
    String season;
    if (travelTime.contains('summer')) {
      season = "summer";
    } else if (travelTime.contains('winter')) {
      season = "winter";
    } else if (travelTime.contains('spring')) {
      season = "spring";
    } else if (travelTime.contains('fall') || travelTime.contains('autumn')) {
      season = "fall";
    } else {
      // Default based on current month
      final currentMonth = DateTime.now().month;
      if (currentMonth >= 3 && currentMonth <= 5) {
        season = "spring";
      } else if (currentMonth >= 6 && currentMonth <= 8) {
        season = "summer";
      } else if (currentMonth >= 9 && currentMonth <= 11) {
        season = "fall";
      } else {
        season = "winter";
      }
    }
    
    // Generic weather responses based on destination and season
    switch (season) {
      case "summer":
        if (destination.contains("beach") || destination.toLowerCase().contains("bali") || 
            destination.toLowerCase().contains("hawaii") || destination.toLowerCase().contains("caribbean")) {
          return "In $destination during summer, you can expect warm temperatures ranging from 77°F to 86°F (25-30°C) with generally sunny days. It's perfect beach weather! Don't forget sunscreen, lightweight clothing, and maybe a light jacket for evening sea breezes.";
        } else if (destination.toLowerCase().contains("alps") || destination.toLowerCase().contains("mountain")) {
          return "Summer in $destination brings mild temperatures between 60°F and 75°F (15-24°C) during the day, cooling down at night. Weather can change quickly in mountain areas, so pack layers and a rain jacket along with hiking gear.";
        } else {
          return "$destination in summer typically has warm weather with temperatures between 70°F and 85°F (21-29°C). Pack light clothing, sunscreen, and maybe a light jacket for cooler evenings or air-conditioned establishments.";
        }
        
      case "winter":
        if (destination.toLowerCase().contains("alps") || destination.toLowerCase().contains("mountain")) {
          return "Winter in $destination brings snow and cold temperatures, usually between 20°F and 35°F (-7 to 2°C). Perfect for winter sports! Pack warm layers, gloves, a hat, and proper winter boots.";
        } else if (destination.toLowerCase().contains("bali") || destination.toLowerCase().contains("caribbean")) {
          return "$destination has a tropical climate, so winter remains warm at 75°F to 85°F (24-29°C), though it may be the rainy season. Pack light clothing, rain gear, and insect repellent.";
        } else {
          return "Winter in $destination typically brings temperatures between 35°F and 50°F (2-10°C), with occasional rain or snow. Pack warm clothing, a waterproof jacket, and comfortable walking shoes.";
        }
        
      case "spring":
        return "Spring in $destination is delightful with temperatures gradually warming to 60°F to 70°F (15-21°C). Weather can be changeable, so pack layers, a light jacket, and an umbrella for occasional showers.";
        
      default: // Fall
        return "Fall in $destination brings mild temperatures around 55°F to 65°F (13-18°C) with beautiful autumn colors in many areas. Pack layers for changing temperatures, comfortable walking shoes, and a medium-weight jacket.";
    }
  }
  
  static String _generateCurrencyResponse(String destination) {
    if (destination.toLowerCase().contains("japan") || destination.toLowerCase().contains("tokyo")) {
      return "In Japan, the currency is the Japanese Yen (JPY). Credit cards are widely accepted in cities, but it's good to carry cash for smaller establishments. ATMs are readily available, especially at 7-Eleven convenience stores.";
    } else if (destination.toLowerCase().contains("europe") || destination.toLowerCase().contains("paris") || 
               destination.toLowerCase().contains("rome") || destination.toLowerCase().contains("barcelona")) {
      return "Most European countries use the Euro (EUR), including France, Italy, and Spain. Credit cards are widely accepted, though some small shops may require cash. ATMs are readily available throughout major cities and towns.";
    } else if (destination.toLowerCase().contains("uk") || destination.toLowerCase().contains("london")) {
      return "The United Kingdom uses the British Pound (GBP). Credit cards are widely accepted, and ATMs are readily available throughout the country. It's always good to have some cash on hand for small purchases.";
    } else if (destination.toLowerCase().contains("bali") || destination.toLowerCase().contains("indonesia")) {
      return "In Bali, Indonesia, the currency is the Indonesian Rupiah (IDR). While major hotels and restaurants accept credit cards, always carry cash for smaller establishments and local markets. ATMs are available in tourist areas.";
    } else if (destination.toLowerCase().contains("thailand") || destination.toLowerCase().contains("bangkok")) {
      return "Thailand uses the Thai Baht (THB). While credit cards are accepted in major establishments, cash is preferred for local markets and smaller shops. ATMs are widely available in tourist areas.";
    } else {
      return "When traveling to $destination, I'd recommend checking the local currency and exchange rates before your trip. It's usually good to have some local currency on hand for small purchases, though credit cards are increasingly accepted worldwide. ATMs are typically available in tourist areas for withdrawals.";
    }
  }
  
  static String _generateLanguageResponse(String destination) {
    if (destination.toLowerCase().contains("japan")) {
      return "The official language in Japan is Japanese. While English signage is common in major cities and tourist areas, basic Japanese phrases can be very helpful. Many younger Japanese people have some English knowledge, especially in Tokyo and other major cities.";
    } else if (destination.toLowerCase().contains("france") || destination.toLowerCase().contains("paris")) {
      return "French is the official language in France. While many people in the tourism industry speak English, learning basic French phrases is appreciated by locals. In Paris and other major tourist destinations, you'll generally find English speakers in hotels and restaurants.";
    } else if (destination.toLowerCase().contains("italy") || destination.toLowerCase().contains("rome")) {
      return "Italian is the official language in Italy. While English is spoken in tourist areas and hotels, it's less common in smaller towns. Learning a few basic Italian phrases will enhance your experience and is appreciated by locals.";
    } else if (destination.toLowerCase().contains("bali")) {
      return "In Bali, the official language is Indonesian (Bahasa Indonesia), though many Balinese also speak their local Balinese language. In tourist areas, English is widely spoken and understood. Learning a few basic Indonesian phrases is always appreciated.";
    } else if (destination.toLowerCase().contains("spain") || destination.toLowerCase().contains("barcelona")) {
      return "Spanish is the official language in Spain, though regions like Catalonia (where Barcelona is located) also have their own languages (Catalan). English proficiency varies but is more common in tourist areas. Learning basic Spanish phrases will greatly enhance your experience.";
    } else {
      return "When visiting $destination, it's helpful to learn a few basic phrases in the local language, even if many people in tourist areas may speak English. This shows respect for the local culture and can enhance your travel experience. I can help you with some essential phrases closer to your trip if you'd like!";
    }
  }
  
  static String _generateFoodResponse(String destination) {
    if (destination.toLowerCase().contains("japan") || destination.toLowerCase().contains("tokyo")) {
      return "Japanese cuisine is diverse and delicious! Beyond sushi, try ramen, tempura, yakitori (grilled chicken skewers), and okonomiyaki (savory pancakes). Don't miss traditional teahouses for matcha and wagashi (Japanese sweets). In Tokyo, visit the Tsukiji Outer Market for fresh seafood and the department store food halls (depachika) for incredible variety.";
    } else if (destination.toLowerCase().contains("italy") || destination.toLowerCase().contains("rome")) {
      return "Italian cuisine varies by region, with each area having its specialties. In Rome, try cacio e pepe (cheese and pepper pasta), carbonara, and supplì (fried rice balls). Look for trattorias away from tourist areas for authentic meals at better prices. Remember that Italians typically eat dinner later, around 8-9 PM, and many restaurants close in the afternoon.";
    } else if (destination.toLowerCase().contains("france") || destination.toLowerCase().contains("paris")) {
      return "French cuisine is world-renowned for good reason! In Paris, beyond the classic croissants and baguettes, try duck confit, coq au vin, and of course, cheese and wine. For an authentic experience, visit local bistros rather than tourist-focused restaurants. The Prix Fixe (fixed price) menus offer good value at many restaurants.";
    } else if (destination.toLowerCase().contains("thailand") || destination.toLowerCase().contains("bangkok")) {
      return "Thai food offers an explosion of flavors! Beyond Pad Thai, try Tom Yum soup, green curry, mango sticky rice, and som tam (papaya salad). Street food is often the most delicious and authentic option in Thailand - just look for stalls with many local customers. In Bangkok, the Chinatown area (Yaowarat) and Or Tor Kor market have amazing food options.";
    } else if (destination.toLowerCase().contains("spain") || destination.toLowerCase().contains("barcelona")) {
      return "Spanish cuisine is diverse and social! Try tapas (small plates) like patatas bravas and jamón ibérico. In Barcelona, don't miss paella (though it's originally from Valencia) and local Catalan dishes like fideuà (seafood noodle dish). Remember that Spaniards eat dinner very late, often after 9 PM. Look for restaurants filled with locals rather than those with menus in multiple languages.";
    } else {
      return "$destination offers wonderful culinary experiences! I'd recommend trying the local specialties and street food where safe. Restaurants filled with locals (rather than tourists) often offer the most authentic experience. Ask your hotel staff for recommendations on where they would eat - that's always a great way to find hidden gems!";
    }
  }
  
  static String _generateSafetyResponse(String destination) {
    return "$destination is generally considered a safe destination for tourists, though normal travel precautions apply. As with any travel destination, be aware of your surroundings, keep valuables secure, and avoid isolated areas at night. It's always a good idea to have travel insurance, keep copies of important documents, and register with your country's travel advisory service before your trip. Our booking confirmation will include specific safety tips for your destination.";
  }
  
  static String _generateTransportResponse(String destination) {
    if (destination.toLowerCase().contains("japan") || destination.toLowerCase().contains("tokyo")) {
      return "Japan has an excellent public transportation system. In Tokyo, the subway and JR lines can take you virtually anywhere. Consider getting a Suica or Pasmo card for easy payments. For traveling between cities, the Shinkansen (bullet train) is efficient though pricey - a Japan Rail Pass might be cost-effective if you plan multiple intercity trips.";
    } else if (destination.toLowerCase().contains("london") || destination.toLowerCase().contains("uk")) {
      return "London has an extensive public transport network. The Underground (Tube) is the fastest way around, while buses offer scenic routes. Get an Oyster card or use contactless payment for the best fares. For travel outside London, trains connect major cities, though booking in advance can save significantly.";
    } else if (destination.toLowerCase().contains("bali")) {
      return "In Bali, transportation options include renting a scooter (only if you're experienced), hiring a driver (very affordable for full-day tours), or using ride-sharing apps like Grab. Public transportation is limited, so most tourists rely on taxis or pre-arranged drivers. Many hotels also offer shuttle services to popular destinations.";
    } else if (destination.toLowerCase().contains("europe")) {
      return "Europe has excellent public transportation systems. In most major European cities, public transit (subway, trams, buses) is the best way to get around. For travel between cities, consider trains - they're often more comfortable than buses and take you city-center to city-center. The Eurail pass might be cost-effective if you're visiting multiple countries.";
    } else {
      return "In $destination, transportation options typically include public transit in major cities, taxis, and possibly ride-sharing services depending on the location. When you book your trip, we'll provide detailed information about the best ways to get around your specific destination, including any transportation passes that might save you money.";
    }
  }
  
  static String _generateVisaResponse(String destination) {
    return "Visa requirements for $destination depend on your nationality and the length of your stay. Generally, you'll need a passport valid for at least six months beyond your stay. When you book your trip, we'll provide specific visa information based on your citizenship. It's always a good idea to check your government's travel website for the most up-to-date requirements, as these can change.";
  }
}