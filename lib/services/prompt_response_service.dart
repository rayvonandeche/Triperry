import 'query_handler.dart';

class PromptResponseService {
  // Method to get pre-defined structured responses based on intent
  static Map<String, dynamic> getStructuredResponse(String message, QueryIntent intent) {
    // Extract location if present
    final location = QueryHandler.extractLocation(message) ?? 'Paris';
    
    switch (intent) {
      case QueryIntent.destination:
        return _getDestinationResponse(location);
      case QueryIntent.activity:
        return _getActivityResponse(location);
      case QueryIntent.schedule:
        return _getScheduleResponse(location);
      default:
        return {'text': 'I\'m not sure how to help with that. Could you ask about destinations, activities, or schedules?'};
    }
  }
  
  // Method to get Markdown responses for general queries
  static String getMarkdownResponse(String message) {
    final messageLower = message.toLowerCase();
    
    // Detect if message is about a specific location
    final location = QueryHandler.extractLocation(message);
    
    if (location != null) {
      if (messageLower.contains('weather') || messageLower.contains('climate')) {
        return _getWeatherResponse(location);
      } else if (messageLower.contains('cost') || messageLower.contains('budget') || messageLower.contains('expensive')) {
        return _getBudgetResponse(location);
      } else if (messageLower.contains('food') || messageLower.contains('eat') || messageLower.contains('cuisine') || messageLower.contains('restaurant')) {
        return _getFoodResponse(location);
      } else {
        return _getGeneralLocationInfo(location);
      }
    }
    
    // Generic travel queries
    if (messageLower.contains('pack') || messageLower.contains('luggage') || messageLower.contains('suitcase')) {
      return '''
## Travel Packing Tips

Here are some essential items to consider when packing for your trip:

1. **Documents**
   - Passport/ID
   - Travel insurance
   - Hotel reservations
   - Flight tickets

2. **Clothing**
   - Weather-appropriate attire
   - Comfortable walking shoes
   - Formal outfit (if needed)

3. **Electronics**
   - Phone and charger
   - Camera
   - Travel adapter

4. **Toiletries**
   - Toothbrush and toothpaste
   - Shampoo and soap
   - Sunscreen
   - Medications

5. **Miscellaneous**
   - Travel pillow
   - Earplugs
   - Books or e-reader
   - Reusable water bottle

Remember to pack light and only bring what you truly need!
''';
    }
    
    if (messageLower.contains('safety') || messageLower.contains('safe')) {
      return '''
## Travel Safety Tips

Staying safe while traveling is essential for an enjoyable experience:

1. **Before You Go**
   - Research your destination
   - Register with your country's travel advisory service
   - Get appropriate vaccinations
   - Purchase travel insurance

2. **Money Matters**
   - Use a money belt for important documents
   - Carry limited cash
   - Have backup credit cards
   - Be cautious at ATMs

3. **While Exploring**
   - Stay aware of your surroundings
   - Keep belongings secure
   - Use official transportation
   - Avoid poorly lit areas at night

4. **Health Precautions**
   - Drink bottled water if tap water isn't safe
   - Be cautious with street food
   - Carry basic medications
   - Know how to contact emergency services

5. **Digital Security**
   - Use VPNs on public Wi-Fi
   - Enable two-factor authentication
   - Back up photos regularly

Remember: Most places are safe for travelers who take reasonable precautions!
''';
    }
    
    // Default response if no specific pattern matched
    return '''
# Welcome to your Travel Assistant!

I can help you plan your perfect trip. Here are some things you can ask me about:

## Destinations
- "Tell me about visiting Paris"
- "What are the best beaches in Thailand?"
- "Where should I go for a winter vacation?"

## Activities
- "Things to do in Tokyo"
- "Family activities in Rome"
- "Adventure sports in New Zealand"

## Planning
- "Create a 3-day itinerary for Barcelona"
- "What's the best time to visit Egypt?"
- "Budget tips for traveling in Europe"

What would you like to know about?
''';
  }
  
  // Pre-defined response for Paris with family
  static String getParisWithFamilyResponse() {
    return '''
# Family-Friendly Activities in Paris

Paris isn't just for romantic getaways! The city offers numerous attractions that both children and adults can enjoy together:

## 1. Disneyland Paris
Just a short train ride from the city center, Disneyland Paris offers two theme parks, entertainment, and magical experiences for the whole family.

## 2. Jardin d'Acclimatation
This amusement park and garden in the Bois de Boulogne features rides, a water park, and a small zoo - perfect for younger children.

## 3. Cité des Sciences et de l'Industrie
Europe's largest science museum has interactive exhibits designed specifically for children, including a special area for ages 2-7.

## 4. Luxembourg Gardens
Let the kids sail toy boats in the pond, enjoy the puppet theater, or ride the vintage carousel while you relax in these beautiful gardens.

## 5. Seine River Cruise
A boat tour offers a relaxing way to see many Paris landmarks without tiring little legs - most cruises last about an hour.

## 6. Eiffel Tower
While there might be lines, the views from the top are unforgettable for children and adults alike!

## 7. Natural History Museum and Gallery of Evolution
The impressive animal displays and dinosaur skeletons are sure to captivate children's imagination.

## Tips for Family Visits
- Consider the Paris Museum Pass for savings on multiple attractions
- Use the Metro for transportation (children under 4 ride free)
- Plan indoor activities for rainy days
- Schedule downtime between major attractions
- Visit parks and gardens for free play opportunities

Would you like me to create a specific family-friendly itinerary for your Paris trip?
''';
  }
  
  // Private methods for generating specific structured responses
  static Map<String, dynamic> _getDestinationResponse(String location) {
    // This would be replaced with actual dynamic content in a production app
    if (location.toLowerCase() == 'paris') {
      return {
        'options': [
          {
            'label': 'Eiffel Tower District',
            'description': 'The iconic symbol of Paris surrounded by beautiful gardens and upscale neighborhoods. Perfect for first-time visitors wanting classic Parisian views and atmosphere.',
            'imageQuery': 'Paris Eiffel Tower landmark',
            'highlights': ['Panoramic city views', 'Champ de Mars gardens', 'Seine River proximity', 'Romantic atmosphere']
          },
          {
            'label': 'Le Marais',
            'description': 'A historic district with medieval architecture, trendy boutiques, and vibrant Jewish and LGBTQ+ communities. Known for charming streets and exceptional food scene.',
            'imageQuery': 'Paris Le Marais historic district',
            'highlights': ['Historic architecture', 'Trendy shopping', 'Art galleries', 'Vibrant nightlife']
          },
          {
            'label': 'Montmartre',
            'description': 'Bohemian hilltop neighborhood known for its artistic history and the stunning Sacré-Cœur Basilica. Offers authentic Parisian charm with sweeping city views.',
            'imageQuery': 'Paris Montmartre Sacre Coeur',
            'highlights': ['Sacré-Cœur Basilica', 'Artist square', 'Historic windmills', 'Village atmosphere']
          }
        ]
      };
    } else if (location.toLowerCase() == 'tokyo') {
      return {
        'options': [
          {
            'label': 'Shinjuku',
            'description': 'Tokyo\'s bustling business and entertainment district featuring the world\'s busiest train station and countless dining options. Experience modern Tokyo at its most vibrant.',
            'imageQuery': 'Tokyo Shinjuku skyline night',
            'highlights': ['Skyscraper district', 'Robot Restaurant', 'Golden Gai bars', 'Gyoen National Garden']
          },
          {
            'label': 'Asakusa',
            'description': 'Tokyo\'s old town featuring the iconic Senso-ji Temple and traditional shopping streets. Best area for experiencing Japan\'s traditional culture and architecture.',
            'imageQuery': 'Tokyo Asakusa Senso-ji Temple',
            'highlights': ['Senso-ji Temple', 'Nakamise shopping street', 'Sumida River views', 'Traditional festivals']
          },
          {
            'label': 'Shibuya',
            'description': 'Trendy shopping district famous for its scramble crossing and youth culture. The perfect place to experience Tokyo\'s famous fashion scene and nightlife.',
            'imageQuery': 'Tokyo Shibuya Crossing busy',
            'highlights': ['Shibuya Crossing', 'Center Gai shopping', 'Yoyogi Park', 'Fashion boutiques']
          }
        ]
      };
    } else {
      // Generic response for other locations
      return {
        'options': [
          {
            'label': '$location City Center',
            'description': 'The historic heart of $location offering cultural attractions and landmarks. Perfect for first-time visitors wanting to experience the essence of the city.',
            'imageQuery': '$location downtown skyline',
            'highlights': ['Historic buildings', 'Cultural attractions', 'Central location', 'Shopping districts']
          },
          {
            'label': '$location Waterfront',
            'description': 'Beautiful coastal area of $location with stunning views and outdoor activities. Ideal for those looking for a mix of urban amenities and natural beauty.',
            'imageQuery': '$location waterfront harbor view',
            'highlights': ['Scenic views', 'Waterfront dining', 'Outdoor activities', 'Sunset spots']
          },
          {
            'label': '$location Old Town',
            'description': 'Charming historic district of $location with traditional architecture and local culture. Perfect for travelers interested in authentic local experiences.',
            'imageQuery': '$location old town historic district',
            'highlights': ['Traditional architecture', 'Local cuisine', 'Artisan shops', 'Historic landmarks']
          }
        ]
      };
    }
  }
  
  static Map<String, dynamic> _getActivityResponse(String location) {
    // This would be replaced with actual dynamic content in a production app
    if (location.toLowerCase() == 'paris') {
      return {
        'activities': [
          {
            'name': 'Eiffel Tower Visit',
            'category': 'Landmarks',
            'description': 'Ascend the iconic Eiffel Tower for panoramic views of Paris from its three observation levels. For an extra special experience, visit at night to see the hourly light show.',
            'imageQuery': 'Eiffel Tower Paris landmark',
            'highlights': ['Panoramic city views', 'Gourmet restaurants', 'Light show at night']
          },
          {
            'name': 'Louvre Museum Tour',
            'category': 'Arts & Culture',
            'description': 'Explore the world\'s largest art museum housing over 38,000 objects including the famous Mona Lisa and Venus de Milo. Plan at least half a day to see the highlights.',
            'imageQuery': 'Louvre Museum Paris Mona Lisa',
            'highlights': ['Mona Lisa', 'Venus de Milo', 'Napoleon Apartments']
          },
          {
            'name': 'Seine River Cruise',
            'category': 'Sightseeing',
            'description': 'Glide along the Seine River past iconic landmarks on a relaxing boat tour. Choose from daytime sightseeing cruises or romantic dinner cruises with French cuisine.',
            'imageQuery': 'Seine River cruise Paris Notre Dame',
            'highlights': ['Notre Dame views', 'Pont Alexandre III', 'Relaxing atmosphere']
          },
          {
            'name': 'Montmartre Walking Tour',
            'category': 'Neighborhood Exploration',
            'description': 'Discover the artistic hilltop district known for Sacré-Cœur Basilica and its bohemian history. Visit the artists\' square and explore charming winding streets.',
            'imageQuery': 'Montmartre Paris steps Sacre Coeur',
            'highlights': ['Sacré-Cœur views', 'Place du Tertre artists', 'Historic windmills']
          }
        ]
      };
    } else {
      // Generic response for other locations
      return {
        'activities': [
          {
            'name': 'Visit $location Landmarks',
            'category': 'Sightseeing',
            'description': 'Explore the most iconic sights in $location to learn about its history and culture. A perfect introduction to the city for first-time visitors.',
            'imageQuery': '$location famous landmark tourism',
            'highlights': ['Historic significance', 'Photo opportunities', 'Cultural insights']
          },
          {
            'name': '$location Food Tour',
            'category': 'Culinary',
            'description': 'Taste the authentic flavors of $location cuisine with a guided food tour through markets and local eateries. Discover traditional dishes and local specialties.',
            'imageQuery': '$location traditional food cuisine',
            'highlights': ['Local specialties', 'Market exploration', 'Culinary traditions']
          },
          {
            'name': '$location Museums',
            'category': 'Arts & Culture',
            'description': 'Discover the rich cultural heritage of $location through its world-class museums and galleries. Learn about local history, art, and traditions.',
            'imageQuery': '$location museum art gallery',
            'highlights': ['Cultural artifacts', 'Art collections', 'Interactive exhibits']
          },
          {
            'name': '$location Nature Excursion',
            'category': 'Outdoor',
            'description': 'Escape the city and explore the natural beauty surrounding $location. Perfect for outdoor enthusiasts and those looking to see a different side of the region.',
            'imageQuery': '$location nature park landscape',
            'highlights': ['Scenic views', 'Outdoor activities', 'Wildlife spotting']
          }
        ]
      };
    }
  }

  static Map<String, dynamic> _getScheduleResponse(String location) {
    // Current date for the itinerary
    final now = DateTime.now();
    
    if (location.toLowerCase() == 'paris') {
      return {
        'days': [
          {
            'day': 1,
            'date': '${_getDayName(now)}, ${now.month}/${now.day}',
            'activities': [
              {
                'time': 'Morning',
                'activity': 'Eiffel Tower Visit',
                'notes': 'Book tickets in advance to avoid long lines. Best views in the morning light.'
              },
              {
                'time': 'Afternoon',
                'activity': 'Seine River Cruise',
                'notes': 'One-hour boat tour passing major landmarks. Board near the Eiffel Tower.'
              },
              {
                'time': 'Evening',
                'activity': 'Dinner in Latin Quarter',
                'notes': 'Explore charming streets with diverse dining options on Rue Mouffetard.'
              }
            ]
          },
          {
            'day': 2,
            'date': '${_getDayName(now.add(Duration(days: 1)))}, ${now.month}/${now.day + 1}',
            'activities': [
              {
                'time': '9:00 AM',
                'activity': 'Louvre Museum',
                'notes': 'Enter through Porte des Lions entrance to avoid crowds. Focus on key highlights.'
              },
              {
                'time': '2:00 PM',
                'activity': 'Tuileries Garden & Orangerie Museum',
                'notes': 'Relax in the gardens and see Monet\'s Water Lilies in the Orangerie.'
              },
              {
                'time': 'Evening',
                'activity': 'Champs-Élysées Stroll',
                'notes': 'Walk from Place de la Concorde to Arc de Triomphe. Shopping and dining options.'
              }
            ]
          },
          {
            'day': 3,
            'date': '${_getDayName(now.add(Duration(days: 2)))}, ${now.month}/${now.day + 2}',
            'activities': [
              {
                'time': 'Morning',
                'activity': 'Montmartre & Sacré-Cœur',
                'notes': 'Take funicular to avoid steep climb. Visit early to avoid crowds.'
              },
              {
                'time': 'Afternoon',
                'activity': 'Musée d\'Orsay',
                'notes': 'Home to impressionist masterpieces. Don\'t miss the famous clock view.'
              },
              {
                'time': 'Evening',
                'activity': 'Marais District Exploration',
                'notes': 'Historic district with trendy shops, galleries and excellent dining options.'
              }
            ]
          }
        ]
      };
    } else {
      // Generic response for other locations
      return {
        'days': [
          {
            'day': 1,
            'date': '${_getDayName(now)}, ${now.month}/${now.day}',
            'activities': [
              {
                'time': 'Morning',
                'activity': 'City Orientation Tour',
                'notes': 'Start with a guided tour to get oriented and see the main landmarks of $location.'
              },
              {
                'time': 'Afternoon',
                'activity': '$location Main Attractions',
                'notes': 'Visit the most popular sites in the city center. Comfortable walking shoes recommended.'
              },
              {
                'time': 'Evening',
                'activity': 'Welcome Dinner',
                'notes': 'Try local cuisine at a restaurant in the central district to sample regional specialties.'
              }
            ]
          },
          {
            'day': 2,
            'date': '${_getDayName(now.add(Duration(days: 1)))}, ${now.month}/${now.day + 1}',
            'activities': [
              {
                'time': 'Morning',
                'activity': 'Cultural Exploration',
                'notes': 'Visit museums and cultural sites to learn about $location\'s history and traditions.'
              },
              {
                'time': 'Afternoon',
                'activity': 'Shopping & Local Markets',
                'notes': 'Explore local markets for souvenirs and authentic local products.'
              },
              {
                'time': 'Evening',
                'activity': 'Entertainment Experience',
                'notes': 'Enjoy a performance or entertainment option popular in $location.'
              }
            ]
          },
          {
            'day': 3,
            'date': '${_getDayName(now.add(Duration(days: 2)))}, ${now.month}/${now.day + 2}',
            'activities': [
              {
                'time': 'Morning',
                'activity': 'Nature/Outdoor Activity',
                'notes': 'Explore natural attractions or parks in or near $location.'
              },
              {
                'time': 'Afternoon',
                'activity': 'Relaxation Time',
                'notes': 'Free time for personal exploration or relaxation based on your interests.'
              },
              {
                'time': 'Evening',
                'activity': 'Farewell Experience',
                'notes': 'Special dining experience or activity to conclude your visit to $location.'
              }
            ]
          }
        ]
      };
    }
  }
  
  // Helper methods for generating Markdown responses
  static String _getWeatherResponse(String location) {
    // In a real app, this would pull from a weather API
    final locationLower = location.toLowerCase();
    
    if (locationLower == 'paris') {
      return '''
## Weather in Paris

Paris has a temperate climate with four distinct seasons:

🌸 **Spring (March-May)**
- Temperature: 5°C-18°C (41°F-64°F)
- Weather: Mild and occasionally rainy with beautiful blooming gardens
- Recommendation: Pack layers and a light waterproof jacket

☀️ **Summer (June-August)**
- Temperature: 14°C-25°C (57°F-77°F)
- Weather: Generally warm with occasional heat waves and thunderstorms
- Recommendation: Light clothing with a light jacket for evenings

🍂 **Fall (September-November)**
- Temperature: 7°C-21°C (45°F-70°F)
- Weather: Mild with beautiful autumn colors and increasing rainfall
- Recommendation: Light layers with a waterproof jacket

❄️ **Winter (December-February)**
- Temperature: 1°C-8°C (34°F-46°F)
- Weather: Cold with occasional freezing temperatures and light snow
- Recommendation: Warm coat, scarf, gloves, and waterproof shoes

**Best time to visit:** Late spring (May-June) and early fall (September) offer pleasant temperatures and fewer tourists.
''';
    } else if (locationLower == 'tokyo') {
      return '''
## Weather in Tokyo

Tokyo experiences distinct seasons with significant variations throughout the year:

🌸 **Spring (March-May)**
- Temperature: 10°C-23°C (50°F-73°F)
- Weather: Mild and comfortable with famous cherry blossoms in late March/early April
- Recommendation: Light layers and an umbrella for occasional showers

☀️ **Summer (June-August)**
- Temperature: 19°C-31°C (66°F-88°F)
- Weather: Hot and humid with a rainy season in June
- Recommendation: Lightweight, breathable clothing and rain gear

🍂 **Fall (September-November)**
- Temperature: 12°C-27°C (54°F-81°F)
- Weather: Mild and dry with beautiful autumn colors in November
- Recommendation: Light layers with a light jacket for evenings

❄️ **Winter (December-February)**
- Temperature: 2°C-12°C (36°F-54°F)
- Weather: Cold and dry with occasional light snow
- Recommendation: Warm coat, scarf, and gloves

**Best time to visit:** Late March to early April for cherry blossoms, or October to November for autumn colors and comfortable temperatures.
''';
    } else {
      return '''
## Weather in $location

Weather information for $location varies by season:

🌸 **Spring**
- Weather: Generally mild temperatures with possible showers
- Recommendation: Pack layers and a light waterproof jacket

☀️ **Summer**
- Weather: Warmer temperatures, potentially hot depending on location
- Recommendation: Lightweight clothing, sun protection, and hydration

🍂 **Fall**
- Weather: Cooling temperatures and potentially beautiful autumn colors
- Recommendation: Light to medium layers that can be adjusted

❄️ **Winter**
- Weather: Cooler to cold temperatures depending on region
- Recommendation: Warm clothing, possibly with waterproof options

**Best time to visit:** Check local tourism sites for the optimal visiting season based on your preferred activities and weather conditions.

_For current weather forecasts and specific temperature ranges, I recommend checking a weather service closer to your travel date._
''';
    }
  }
  
  static String _getBudgetResponse(String location) {
    final locationLower = location.toLowerCase();
    
    if (locationLower == 'paris') {
      return '''
## Budget Guide for Paris

Paris can be expensive, but there are ways to enjoy it on different budgets:

### Accommodations
- **Budget:** €50-100/night (hostels, budget hotels in outer arrondissements)
- **Mid-range:** €100-250/night (3-star hotels, apartments)
- **Luxury:** €250+/night (4-5 star hotels in central locations)

### Food & Dining
- **Budget:** €30-40/day (bakeries, street food, grocery stores)
- **Mid-range:** €60-80/day (cafés, bistros, occasional restaurant)
- **Luxury:** €120+/day (fine dining restaurants, wine experiences)

### Transportation
- **Metro/Bus ticket:** €1.90 single journey
- **Carnet of 10 tickets:** €16.90 (saving €2.10)
- **Navigo weekly pass:** €22.80 (unlimited travel zones 1-5)
- **Taxi from airport:** €50-60

### Attractions
- **Eiffel Tower:** €10.70-26.80 depending on level and method
- **Louvre Museum:** €17
- **Seine River cruise:** €15-20
- **Paris Museum Pass (4 days):** €66 (free entry to 50+ museums)

### Money-Saving Tips
- Visit museums on the first Sunday of the month (many are free)
- Enjoy free attractions like Notre Dame exterior, Sacré-Cœur, and parks
- Have picnics with food from local markets instead of restaurants
- Look for "prix fixe" lunch menus which offer better value
- Book accommodations in neighborhoods like Montmartre, Canal St. Martin, or the Latin Quarter for better value

### Average Daily Budget
- **Backpacker:** €70-100/day
- **Mid-range traveler:** €150-250/day
- **Luxury traveler:** €350+/day
''';
    } else if (locationLower == 'tokyo') {
      return '''
## Budget Guide for Tokyo

Tokyo offers experiences across all budget ranges:

### Accommodations
- **Budget:** ¥3,000-8,000/night (hostels, capsule hotels)
- **Mid-range:** ¥10,000-20,000/night (business hotels, moderate ryokans)
- **Luxury:** ¥30,000+/night (high-end hotels, luxury ryokans)

### Food & Dining
- **Budget:** ¥1,500-3,000/day (convenience stores, ramen shops, food courts)
- **Mid-range:** ¥4,000-8,000/day (casual restaurants, izakayas)
- **Luxury:** ¥15,000+/day (sushi omakase, kaiseki dining)

### Transportation
- **JR Yamanote Line:** ¥140-200 per ride (connects major districts)
- **Tokyo Metro day pass:** ¥600
- **Suica/PASMO IC card:** ¥2,000 initial (includes ¥1,500 credit + ¥500 deposit)
- **Airport to city center:** ¥900-3,000 depending on method

### Attractions
- **Tokyo Skytree:** ¥2,100-3,400 depending on height
- **Robot Restaurant:** ¥8,000
- **TeamLab Borderless:** ¥3,200
- **Temples/shrines:** Many are free or ¥300-500

### Money-Saving Tips
- Eat lunch sets ("teishoku") which offer better value than dinner
- Stay in neighborhoods like Asakusa, Ueno, or Koenji instead of Shinjuku/Shibuya
- Use convenience stores for affordable meals and snacks
- Visit free attractions like Meiji Shrine, Sensoji Temple, and Shibuya Crossing
- Consider the Tokyo Free Guide volunteer guide service

### Average Daily Budget
- **Backpacker:** ¥8,000-12,000/day
- **Mid-range traveler:** ¥15,000-25,000/day
- **Luxury traveler:** ¥40,000+/day

*Note: ¥1,000 is approximately \$6.50-7.50 USD depending on exchange rates*
''';
    } else {
      return '''
## Budget Considerations for $location

When planning your trip to $location, consider these general budget guidelines:

### Accommodation Options
- **Budget:** Hostels, guesthouses, budget hotels, or shared accommodations
- **Mid-range:** 3-star hotels, private rentals, or boutique accommodations
- **Luxury:** 4-5 star hotels, resort properties, or premium vacation rentals

### Food & Dining
- **Budget:** Street food, local casual eateries, self-catering
- **Mid-range:** Mid-level restaurants, cafes with table service
- **Luxury:** Fine dining establishments, specialty restaurants, food tours

### Transportation
- Public transportation is typically the most economical option
- Ride-sharing or taxis for convenience at moderate cost
- Private transportation or guided tours for comfort at higher cost

### Attraction Costs
- Look into city passes or multi-attraction discounts
- Many cities offer free museums on certain days of the month
- Natural attractions and walking tours are often free or low-cost

### Money-Saving Tips
- Travel during shoulder season for better rates
- Book accommodations with free cancellation in advance
- Research free activities and attractions
- Consider accommodations with kitchen facilities to save on meals
- Use local transportation apps for the best routes and fares

For specific pricing in $location, I recommend checking recent travel guides or destination websites as prices can vary significantly by season and current economic conditions.
''';
    }
  }
  
  static String _getFoodResponse(String location) {
    final locationLower = location.toLowerCase();
    
    if (locationLower == 'paris') {
      return '''
# Food Guide to Paris

Paris is a culinary paradise with options ranging from casual bistros to Michelin-starred restaurants.

## Must-Try Dishes
* **Croissants & Pain au Chocolat** - Best enjoyed fresh in the morning from a local boulangerie
* **Steak Frites** - Classic French dish of steak with french fries
* **Coq au Vin** - Chicken braised with wine, mushrooms, and garlic
* **Escargot** - Snails prepared with garlic and parsley butter
* **Crème Brûlée** - Custard dessert with caramelized sugar top
* **Macarons** - Colorful almond meringue cookies with ganache filling

## Where to Eat
### Budget-Friendly Options
* **Bouillon Chartier** - Historic restaurant serving classic French dishes at reasonable prices
* **L'As du Fallafel** - Famous falafel shop in the Marais district
* **Street Crêpe Stands** - Sweet or savory crêpes made to order

### Traditional Bistros
* **Bistrot Paul Bert** - Classic bistro experience with seasonal menu
* **Le Comptoir du Relais** - Popular Saint-Germain bistro (reservation recommended)
* **Chez Georges** - Old-school Parisian atmosphere with traditional fare

### Fine Dining
* **Le Jules Verne** - Elegant dining inside the Eiffel Tower
* **L'Atelier de Joël Robuchon** - Innovative French cuisine
* **Septime** - Modern French cooking with emphasis on vegetables

## Foodie Experiences
* **Visit a Fromagerie** - Cheese shops with hundreds of varieties
* **Explore Rue Cler Market** - Pedestrian market street with specialty food shops
* **Take a Cooking Class** - Learn to make French classics or pastries
* **Food Tours** - Guided tastings through different neighborhoods

## Dining Tips
* Lunch prix fixe menus offer the best value at upscale restaurants
* Reservations are essential for popular restaurants
* Service (tip) is included in the bill ("service compris")
* Water isn't automatically free - specify "une carafe d'eau" for tap water
* Coffee is typically enjoyed after dessert, not with it
''';
    } else if (locationLower == 'tokyo') {
      return '''
# Food Guide to Tokyo

Tokyo is one of the world's greatest food cities with everything from street food to the highest concentration of Michelin-starred restaurants globally.

## Must-Try Dishes
* **Sushi** - From conveyor belt to high-end omakase experiences
* **Ramen** - Varied styles including tonkotsu, shoyu, miso, and tsukemen
* **Tempura** - Lightly battered and fried seafood and vegetables
* **Yakitori** - Grilled chicken skewers with various parts and seasonings
* **Okonomiyaki** - Savory pancake with cabbage and various toppings
* **Wagashi** - Traditional Japanese sweets often served with matcha

## Where to Eat
### Budget-Friendly Options
* **Ramen Shops** - Look for vending machine ticket systems outside
* **Donburi Restaurants** - Rice bowls topped with meat, fish, or vegetables
* **Conveyor Belt Sushi** - Affordable sushi options like Genki Sushi or Uobei
* **Depachika** - Department store basement food halls with takeaway options

### Mid-Range Dining
* **Izakayas** - Japanese pubs serving small plates with drinks
* **Shabu-shabu/Sukiyaki Restaurants** - Interactive hotpot dining
* **Tonkatsu Restaurants** - Specializing in breaded, deep-fried pork cutlets
* **Yakitori Alley** - Memory Lane (Omoide Yokocho) in Shinjuku

### Fine Dining
* **Sushi Saito** - World-renowned sushi requiring reservations months ahead
* **Narisawa** - Innovative Japanese cuisine focused on sustainability
* **Ryugin** - Modern kaiseki dining experience

## Foodie Experiences
* **Tsukiji Outer Market** - Food stalls and shops outside the former fish market
* **Kitchen Town (Kappabashi)** - Street selling restaurant supplies and food models
* **Sake Tasting** - Try different varieties of Japan's rice wine
* **Cooking Classes** - Learn to make sushi, ramen, or Japanese home cooking

## Dining Tips
* It's considered rude to eat while walking (except at festivals)
* Tipping is not customary and can cause confusion
* Many restaurants display plastic food models in their windows
* Cash is still king at many smaller establishments
* Look for restaurants with ticket machines outside for easy ordering
* "Irasshaimase!" is a greeting, not requiring a response
''';
    } else {
      return '''
# Food Guide to $location

Exploring local cuisine is one of the best ways to experience a destination's culture and traditions.

## Finding Great Food
* **Research Local Specialties** - Every region has dishes they're known for
* **Look Where Locals Eat** - Restaurants filled with locals are usually good choices
* **Food Markets** - Great for sampling various dishes and ingredients
* **Street Food** - Often provides authentic flavors at affordable prices
* **Food Tours** - Guided experiences can introduce you to hidden gems

## General Dining Tips
* **Meal Times** - Be aware that dining hours vary by culture
* **Reservations** - Recommended for popular restaurants
* **Language** - Learn basic food-related phrases in the local language
* **Allergies** - Research how to communicate dietary restrictions
* **Payment** - Check if cards are accepted or cash is preferred
* **Tipping** - Research local tipping customs before dining out

## Foodie Experiences
* **Cooking Classes** - Learn to recreate local dishes at home
* **Food Festivals** - Time your visit with local culinary events
* **Farm/Producer Visits** - Connect with the source of regional specialties
* **Food Photography** - Document memorable meals and ingredients

For specific restaurant recommendations and local specialties in $location, I suggest looking at recent food blogs, travel guides, or apps like TripAdvisor and Yelp that have up-to-date reviews.
''';
    }
  }
  
  static String _getGeneralLocationInfo(String location) {
    final locationLower = location.toLowerCase();
    
    if (locationLower == 'paris') {
      return '''
# Paris, France - The City of Light

## Overview
Paris, the capital of France, is renowned for its stunning architecture, art museums, historical landmarks, and its influence on fashion, cuisine, and culture. The city is divided into 20 arrondissements (districts) that spiral outward from the center.

## Top Attractions
1. **Eiffel Tower** - The iconic symbol of Paris offers panoramic views from its observation decks
2. **Louvre Museum** - Home to thousands of works of art, including the Mona Lisa
3. **Notre-Dame Cathedral** - Gothic masterpiece (currently under restoration after the 2019 fire)
4. **Montmartre & Sacré-Cœur** - Bohemian hilltop district with stunning basilica
5. **Champs-Élysées & Arc de Triomphe** - Famous avenue leading to the historical arch
6. **Seine River** - The heart of Paris with beautiful bridges and riverside walks
7. **Musée d'Orsay** - Impressionist artwork housed in a former railway station
8. **Luxembourg Gardens** - Beautiful park perfect for relaxation
9. **Centre Pompidou** - Modern art museum with distinctive architecture

## When to Visit
* **Spring (April-June)** - Mild weather, blooming gardens, moderate crowds
* **Summer (June-August)** - Warmer weather, longer days, most crowded
* **Fall (September-October)** - Comfortable temperatures, fewer tourists
* **Winter (November-March)** - Chilly but festive atmosphere, lowest prices

## Getting Around
* **Metro** - Extensive subway system, easiest way to navigate the city
* **Bus** - Good for scenic routes above ground
* **Walking** - Many attractions are within walking distance in central Paris
* **Vélib** - Bike-sharing program for short trips
* **Taxi/Uber** - Available but often slower due to traffic

## Neighborhoods to Explore
* **Le Marais** - Historic district with trendy shops and vibrant Jewish quarter
* **Saint-Germain-des-Prés** - Intellectual hub with cafes and boutiques
* **Canal Saint-Martin** - Hip area with waterside hangouts
* **Montmartre** - Artistic hilltop neighborhood with village feel
* **Latin Quarter** - Student district with lively atmosphere

## Practical Tips
* Purchase a Paris Museum Pass for entry to over 50 museums and monuments
* Learn basic French phrases – locals appreciate the effort
* Make dinner reservations in advance for popular restaurants
* Be aware of common scams targeting tourists
* Many shops close on Sundays and some restaurants on Mondays
''';
    } else if (locationLower == 'tokyo') {
      return '''
# Tokyo, Japan - Where Tradition Meets Innovation

## Overview
Tokyo, Japan's busy capital, mixes ultramodern and traditional elements, from neon-lit skyscrapers to historic temples. The city is divided into various districts, each with its own character and attractions.

## Top Attractions
1. **Senso-ji Temple** - Tokyo's oldest Buddhist temple in Asakusa
2. **Meiji Shrine** - Peaceful Shinto shrine set in a lush forest
3. **Tokyo Skytree** - One of the world's tallest towers with observation decks
4. **Shibuya Crossing** - Famous busy intersection known as "The Scramble"
5. **Shinjuku Gyoen National Garden** - Beautiful park with Japanese, English, and French gardens
6. **Tsukiji Outer Market** - Food stalls and shops near the former fish market
7. **Akihabara** - Electronic and anime/manga district
8. **Ueno Park** - Spacious public park with museums and zoo
9. **Imperial Palace** - Residence of Japan's Imperial Family with beautiful grounds

## When to Visit
* **Spring (March-May)** - Cherry blossom season, mild weather
* **Summer (June-August)** - Hot and humid with festivals
* **Fall (September-November)** - Comfortable temperatures, autumn colors
* **Winter (December-February)** - Cold but clear days, fewer tourists

## Getting Around
* **Tokyo Metro & JR Lines** - Extensive rail network covering the entire city
* **IC Cards (Suica/Pasmo)** - Rechargeable cards for public transportation
* **Taxis** - Clean and reliable but expensive for long distances
* **Walking** - Best for exploring individual neighborhoods
* **Buses** - Useful for areas not covered by trains

## Neighborhoods to Explore
* **Shinjuku** - Business district with skyscrapers and entertainment
* **Shibuya** - Youth fashion center and nightlife
* **Harajuku** - Trendy shopping area popular with younger crowds
* **Ginza** - Upscale shopping district with flagship stores
* **Asakusa** - Traditional area with temples and crafts

## Practical Tips
* Get a Suica/Pasmo card for easy transport
* Many places still prefer cash over credit cards
* Free Wi-Fi is not as widespread as in other major cities
* Learn basic Japanese phrases and etiquette
* Be aware that most signs have English translations in tourist areas
* Restaurants often display plastic food models of their dishes in windows
''';
    } else {
      return '''
# $location - Travel Guide

I'd be happy to provide more specific information about $location with more context! Here's some general travel information:

## Planning Your Visit
* Research the best time to visit based on weather and local events
* Check visa requirements and travel advisories
* Consider local transportation options from the airport/station to your accommodation
* Look into city passes that may save money on attractions

## Accommodation Tips
* Book accommodations in central locations to minimize travel time
* Consider the neighborhood atmosphere - quiet residential or lively entertainment district
* Read recent reviews from other travelers
* Check for included amenities like Wi-Fi, breakfast, or airport transfers

## Getting Around
* Research public transportation options
* Download local transportation apps before arrival
* Consider whether a rental car is necessary or if public transit is sufficient
* Look into walking tours for an orientation to the destination

## Cultural Considerations
* Learn about local customs and etiquette
* Research appropriate dress for various situations
* Learn a few basic phrases in the local language
* Be respectful of local traditions and practices

## Safety Tips
* Register with your country's travel advisory service
* Keep copies of important documents
* Know emergency numbers and location of your country's embassy/consulate
* Research common tourist scams in the area

For more specific information about $location including attractions, dining recommendations, and local experiences, please let me know what aspects of your trip you'd like to learn more about!
''';
    }
  }
  
  // Helper to get day name
  static String _getDayName(DateTime date) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[date.weekday - 1]; // weekday is 1-based (1 = Monday, 7 = Sunday)
  }
}