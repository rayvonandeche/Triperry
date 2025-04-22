// import 'package:flutter/material.dart';

// /// A service that provides realistic demo data for the travel app MVP
// /// This allows showcasing features without real API connections
// class DemoDataService {
//   // Popular destinations with pre-built information
//   static final Map<String, Map<String, dynamic>> _destinationData = {
//     'paris': {
//       'name': 'Paris, France',
//       'description': 'Known as the "City of Light," Paris is famous for its iconic landmarks, world-class museums, and romantic ambiance. The city combines historic architecture with modern cultural attractions and is renowned for its cuisine and fashion scene.',
//       'bestTimeToVisit': 'April to June or September to October for mild weather and fewer tourists',
//       'language': 'French',
//       'currency': 'Euro (€)',
//       'attractions': [
//         {
//           'name': 'Eiffel Tower',
//           'shortDescription': 'Iconic 19th-century tower with panoramic city views',
//           'imageQuery': 'Paris Eiffel Tower landmark',
//           'rating': 4.8
//         },
//         {
//           'name': 'Louvre Museum',
//           'shortDescription': 'World\'s largest art museum, home to the Mona Lisa',
//           'imageQuery': 'Paris Louvre Museum Mona Lisa',
//           'rating': 4.7
//         },
//         {
//           'name': 'Notre-Dame Cathedral',
//           'shortDescription': 'Medieval Catholic cathedral with Gothic architecture',
//           'imageQuery': 'Paris Notre Dame Cathedral Gothic',
//           'rating': 4.6
//         },
//         {
//           'name': 'Montmartre',
//           'shortDescription': 'Bohemian hillside area with Sacré-Cœur Basilica',
//           'imageQuery': 'Paris Montmartre Sacre Coeur',
//           'rating': 4.5
//         },
//         {
//           'name': 'Champs-Élysées',
//           'shortDescription': 'Famous avenue known for luxury shops and theaters',
//           'imageQuery': 'Paris Champs Elysees shopping avenue',
//           'rating': 4.4
//         }
//       ],
//       'weather': [
//         {'date': '2025-04-21', 'condition': 'Partly cloudy', 'tempC': 18, 'tempF': 64},
//         {'date': '2025-04-22', 'condition': 'Sunny', 'tempC': 20, 'tempF': 68},
//         {'date': '2025-04-23', 'condition': 'Light rain', 'tempC': 16, 'tempF': 61},
//         {'date': '2025-04-24', 'condition': 'Overcast', 'tempC': 15, 'tempF': 59},
//         {'date': '2025-04-25', 'condition': 'Sunny', 'tempC': 19, 'tempF': 66},
//         {'date': '2025-04-26', 'condition': 'Clear', 'tempC': 21, 'tempF': 70},
//         {'date': '2025-04-27', 'condition': 'Partly cloudy', 'tempC': 18, 'tempF': 64},
//       ]
//     },
//     'tokyo': {
//       'name': 'Tokyo, Japan',
//       'description': 'Tokyo is a dynamic metropolis that blends ultramodern and traditional elements. The city offers cutting-edge technology, world-renowned cuisine, ancient temples, and vibrant shopping districts, all connected by an efficient public transportation system.',
//       'bestTimeToVisit': 'March to May for cherry blossoms or October to November for autumn colors',
//       'language': 'Japanese',
//       'currency': 'Japanese Yen (¥)',
//       'attractions': [
//         {
//           'name': 'Tokyo Skytree',
//           'shortDescription': 'Tallest tower in Japan with observation decks',
//           'imageQuery': 'Tokyo Skytree tower Japan',
//           'rating': 4.6
//         },
//         {
//           'name': 'Shibuya Crossing',
//           'shortDescription': 'Famous bustling intersection known for scramble crossing',
//           'imageQuery': 'Tokyo Shibuya Crossing busy intersection',
//           'rating': 4.5
//         },
//         {
//           'name': 'Senso-ji Temple',
//           'shortDescription': 'Ancient Buddhist temple in Asakusa',
//           'imageQuery': 'Tokyo Senso-ji Temple Asakusa',
//           'rating': 4.7
//         },
//         {
//           'name': 'Meiji Shrine',
//           'shortDescription': 'Shinto shrine dedicated to Emperor Meiji and Empress Shoken',
//           'imageQuery': 'Tokyo Meiji Shrine peaceful',
//           'rating': 4.6
//         },
//         {
//           'name': 'Tsukiji Outer Market',
//           'shortDescription': 'Historic food market with fresh seafood and local cuisine',
//           'imageQuery': 'Tokyo Tsukiji Market food seafood',
//           'rating': 4.5
//         }
//       ],
//       'weather': [
//         {'date': '2025-04-21', 'condition': 'Clear', 'tempC': 22, 'tempF': 72},
//         {'date': '2025-04-22', 'condition': 'Partly cloudy', 'tempC': 23, 'tempF': 73},
//         {'date': '2025-04-23', 'condition': 'Rain shower', 'tempC': 19, 'tempF': 66},
//         {'date': '2025-04-24', 'condition': 'Rain', 'tempC': 18, 'tempF': 64},
//         {'date': '2025-04-25', 'condition': 'Overcast', 'tempC': 20, 'tempF': 68},
//         {'date': '2025-04-26', 'condition': 'Sunny', 'tempC': 24, 'tempF': 75},
//         {'date': '2025-04-27', 'condition': 'Clear', 'tempC': 25, 'tempF': 77},
//       ]
//     },
//     'new york': {
//       'name': 'New York City, USA',
//       'description': 'New York City is a global hub for culture, finance, media, and entertainment. The city features iconic skyscrapers, diverse neighborhoods, world-class museums, Broadway theaters, and an energetic atmosphere that never sleeps.',
//       'bestTimeToVisit': 'April to June or September to early November for pleasant weather',
//       'language': 'English',
//       'currency': 'US Dollar ($)',
//       'attractions': [
//         {
//           'name': 'Empire State Building',
//           'shortDescription': 'Iconic 102-story skyscraper with observation deck',
//           'imageQuery': 'New York Empire State Building skyline',
//           'rating': 4.7
//         },
//         {
//           'name': 'Central Park',
//           'shortDescription': 'Sprawling urban park with walking paths and lakes',
//           'imageQuery': 'New York Central Park nature urban',
//           'rating': 4.8
//         },
//         {
//           'name': 'Statue of Liberty',
//           'shortDescription': 'Iconic copper statue symbolizing freedom',
//           'imageQuery': 'New York Statue of Liberty harbor',
//           'rating': 4.7
//         },
//         {
//           'name': 'Times Square',
//           'shortDescription': 'Famous intersection known for bright lights and billboards',
//           'imageQuery': 'New York Times Square lights night',
//           'rating': 4.5
//         },
//         {
//           'name': 'The Metropolitan Museum of Art',
//           'shortDescription': 'One of the world\'s largest and finest art museums',
//           'imageQuery': 'New York Metropolitan Museum Art Met',
//           'rating': 4.8
//         }
//       ],
//       'weather': [
//         {'date': '2025-04-21', 'condition': 'Sunny', 'tempC': 16, 'tempF': 61},
//         {'date': '2025-04-22', 'condition': 'Partly cloudy', 'tempC': 18, 'tempF': 64},
//         {'date': '2025-04-23', 'condition': 'Clear', 'tempC': 19, 'tempF': 66},
//         {'date': '2025-04-24', 'condition': 'Overcast', 'tempC': 15, 'tempF': 59},
//         {'date': '2025-04-25', 'condition': 'Rain showers', 'tempC': 13, 'tempF': 55},
//         {'date': '2025-04-26', 'condition': 'Cloudy', 'tempC': 14, 'tempF': 57},
//         {'date': '2025-04-27', 'condition': 'Sunny', 'tempC': 17, 'tempF': 63},
//       ]
//     },
//     'bali': {
//       'name': 'Bali, Indonesia',
//       'description': 'Bali is a tropical paradise known for its lush landscapes, beautiful beaches, rich cultural heritage, and spiritual ambiance. The island offers everything from relaxing beach resorts to adventurous jungle treks, vibrant nightlife, and ancient temples.',
//       'bestTimeToVisit': 'April to October for dry season with sunny days',
//       'language': 'Indonesian (Bahasa Indonesia) and Balinese',
//       'currency': 'Indonesian Rupiah (Rp)',
//       'attractions': [
//         {
//           'name': 'Tanah Lot Temple',
//           'shortDescription': 'Ancient sea temple perched on a rock formation',
//           'imageQuery': 'Bali Tanah Lot Temple sunset',
//           'rating': 4.6
//         },
//         {
//           'name': 'Ubud Monkey Forest',
//           'shortDescription': 'Natural sanctuary with Balinese long-tailed macaques',
//           'imageQuery': 'Bali Ubud Monkey Forest sanctuary',
//           'rating': 4.4
//         },
//         {
//           'name': 'Tegallalang Rice Terraces',
//           'shortDescription': 'Stunning stepped rice paddies in central Bali',
//           'imageQuery': 'Bali Tegallalang Rice Terraces green',
//           'rating': 4.5
//         },
//         {
//           'name': 'Uluwatu Temple',
//           'shortDescription': 'Clifftop temple with traditional Kecak dance performances',
//           'imageQuery': 'Bali Uluwatu Temple cliff ocean',
//           'rating': 4.7
//         },
//         {
//           'name': 'Seminyak Beach',
//           'shortDescription': 'Upscale beach area with luxury resorts and dining',
//           'imageQuery': 'Bali Seminyak Beach sunset relaxation',
//           'rating': 4.5
//         }
//       ],
//       'weather': [
//         {'date': '2025-04-21', 'condition': 'Sunny', 'tempC': 30, 'tempF': 86},
//         {'date': '2025-04-22', 'condition': 'Partly cloudy', 'tempC': 31, 'tempF': 88},
//         {'date': '2025-04-23', 'condition': 'Isolated thunderstorms', 'tempC': 29, 'tempF': 84},
//         {'date': '2025-04-24', 'condition': 'Scattered showers', 'tempC': 28, 'tempF': 82},
//         {'date': '2025-04-25', 'condition': 'Sunny', 'tempC': 30, 'tempF': 86},
//         {'date': '2025-04-26', 'condition': 'Clear', 'tempC': 31, 'tempF': 88},
//         {'date': '2025-04-27', 'condition': 'Partly cloudy', 'tempC': 30, 'tempF': 86},
//       ]
//     },
//     'sydney': {
//       'name': 'Sydney, Australia',
//       'description': 'Sydney is a vibrant coastal city known for its iconic harbour, stunning beaches, and modern skyline. The city offers a perfect blend of outdoor activities, cultural attractions, and cosmopolitan dining and entertainment experiences.',
//       'bestTimeToVisit': 'September to November or March to May for mild temperatures and fewer crowds',
//       'language': 'English',
//       'currency': 'Australian Dollar (A$)',
//       'attractions': [
//         {
//           'name': 'Sydney Opera House',
//           'shortDescription': 'World-famous performing arts center with distinctive sail design',
//           'imageQuery': 'Sydney Opera House harbour iconic',
//           'rating': 4.8
//         },
//         {
//           'name': 'Sydney Harbour Bridge',
//           'shortDescription': 'Iconic steel arch bridge nicknamed "The Coathanger"',
//           'imageQuery': 'Sydney Harbour Bridge landmark',
//           'rating': 4.7
//         },
//         {
//           'name': 'Bondi Beach',
//           'shortDescription': 'Famous crescent-shaped beach with golden sand',
//           'imageQuery': 'Sydney Bondi Beach waves sand',
//           'rating': 4.6
//         },
//         {
//           'name': 'Royal Botanic Garden',
//           'shortDescription': 'Historic botanical garden with harbor views',
//           'imageQuery': 'Sydney Royal Botanic Garden flowers',
//           'rating': 4.6
//         },
//         {
//           'name': 'Taronga Zoo',
//           'shortDescription': 'Zoo with Australian wildlife and panoramic city views',
//           'imageQuery': 'Sydney Taronga Zoo animals wildlife',
//           'rating': 4.5
//         }
//       ],
//       'weather': [
//         {'date': '2025-04-21', 'condition': 'Sunny', 'tempC': 22, 'tempF': 72},
//         {'date': '2025-04-22', 'condition': 'Partly cloudy', 'tempC': 23, 'tempF': 73},
//         {'date': '2025-04-23', 'condition': 'Mostly sunny', 'tempC': 24, 'tempF': 75},
//         {'date': '2025-04-24', 'condition': 'Showers', 'tempC': 21, 'tempF': 70},
//         {'date': '2025-04-25', 'condition': 'Rain', 'tempC': 19, 'tempF': 66},
//         {'date': '2025-04-26', 'condition': 'Partly cloudy', 'tempC': 20, 'tempF': 68},
//         {'date': '2025-04-27', 'condition': 'Sunny', 'tempC': 22, 'tempF': 72},
//       ]
//     }
//   };

//   // Activity suggestions by category and location
//   static final Map<String, Map<String, List<Map<String, dynamic>>>> _activityData = {
//     'paris': {
//       'Cultural Experience': [
//         {
//           'name': 'Louvre Museum Tour',
//           'description': 'Guided tour of the world\'s most visited museum, featuring masterpieces like the Mona Lisa and Venus de Milo.',
//           'duration': '3 hours',
//           'price': '€€',
//           'imageQuery': 'Paris Louvre Museum tour art',
//           'highlights': ['Skip-the-line access', 'Expert art historian guides', 'All major masterpieces covered']
//         },
//         {
//           'name': 'Seine River Cruise',
//           'description': 'Leisurely boat ride along the Seine River with views of Paris\'s most famous monuments and bridges.',
//           'duration': '1 hour',
//           'price': '€€',
//           'imageQuery': 'Paris Seine River cruise boat',
//           'highlights': ['Panoramic city views', 'Audio commentary in multiple languages', 'Day and evening options']
//         }
//       ],
//       'Food & Dining': [
//         {
//           'name': 'Parisian Pastry Workshop',
//           'description': 'Learn to make authentic French pastries like croissants and macarons with a professional pastry chef.',
//           'duration': '2-3 hours',
//           'price': '€€€',
//           'imageQuery': 'Paris pastry cooking class macaron',
//           'highlights': ['Hands-on experience', 'Small group setting', 'Take home your creations']
//         },
//         {
//           'name': 'Montmartre Food Tour',
//           'description': 'Walking tour through the bohemian Montmartre neighborhood, sampling local cheeses, wines, and delicacies.',
//           'duration': '3 hours',
//           'price': '€€',
//           'imageQuery': 'Paris Montmartre food tour cheese wine',
//           'highlights': ['6-8 food tastings included', 'Local neighborhood insights', 'Small group experience']
//         }
//       ],
//       'Outdoor Adventure': [
//         {
//           'name': 'Bike Tour of Paris',
//           'description': 'Guided bicycle tour through the historic heart of Paris, covering major landmarks and hidden gems.',
//           'duration': '3-4 hours',
//           'price': '€€',
//           'imageQuery': 'Paris bike tour cycling Seine',
//           'highlights': ['Comfortable bikes provided', 'Scenic routes away from traffic', 'Photo opportunities at key sites']
//         }
//       ]
//     },
//     'tokyo': {
//       'Cultural Experience': [
//         {
//           'name': 'Teamlab Borderless Museum',
//           'description': 'Interactive digital art museum with immersive, boundary-defying installations that respond to viewer presence.',
//           'duration': '3 hours',
//           'price': '¥¥',
//           'imageQuery': 'Tokyo TeamLab Borderless digital art museum interactive',
//           'highlights': ['Interactive art installations', 'Constantly changing exhibits', 'Perfect for photography']
//         },
//         {
//           'name': 'Sumo Wrestling Tournament',
//           'description': 'Experience Japan\'s national sport at a live tournament with ceremonial rituals and thrilling matches.',
//           'duration': '4-6 hours',
//           'price': '¥¥¥',
//           'imageQuery': 'Tokyo sumo wrestling tournament match',
//           'highlights': ['Expert commentary available', 'Experience ancient Japanese tradition', 'Opportunity to see top-ranked wrestlers']
//         }
//       ],
//       'Food & Dining': [
//         {
//           'name': 'Tsukiji Outer Market Tour',
//           'description': 'Guided food tour of the famous outer market area with tastings of fresh seafood and Japanese delicacies.',
//           'duration': '3 hours',
//           'price': '¥¥',
//           'imageQuery': 'Tokyo Tsukiji Market seafood tasting',
//           'highlights': ['Sample 6-8 specialties', 'Local expert guide', 'Learn about Japanese food culture']
//         },
//         {
//           'name': 'Izakaya Hopping in Shinjuku',
//           'description': 'Evening tour of traditional Japanese pubs in Tokyo\'s vibrant nightlife district.',
//           'duration': '3-4 hours',
//           'price': '¥¥',
//           'imageQuery': 'Tokyo izakaya bar hopping night',
//           'highlights': ['Visit 3-4 local establishments', 'Food and drinks included', 'Experience authentic local nightlife']
//         }
//       ],
//       'Outdoor Adventure': [
//         {
//           'name': 'Mount Fuji Day Trip',
//           'description': 'Guided excursion to Japan\'s iconic mountain with opportunities for hiking and scenic views.',
//           'duration': 'Full day',
//           'price': '¥¥¥',
//           'imageQuery': 'Japan Mount Fuji hiking view',
//           'highlights': ['Transportation from Tokyo included', 'Visit 5th Station (weather permitting)', 'Lake Kawaguchi views']
//         }
//       ]
//     }
//   };

//   // Sample itineraries for popular destinations
//   static final Map<String, List<Map<String, dynamic>>> _itineraryData = {
//     'paris': [
//       {
//         'day': 1,
//         'date': 'Monday, April 21',
//         'activities': [
//           {
//             'time': 'Morning',
//             'activity': 'Eiffel Tower Visit',
//             'notes': 'Arrive early to avoid long lines. Consider booking tickets in advance for the summit.'
//           },
//           {
//             'time': 'Lunch',
//             'activity': 'Café at Champ de Mars',
//             'notes': 'Enjoy a relaxed lunch with Eiffel Tower views. Try a traditional Croque Monsieur.'
//           },
//           {
//             'time': 'Afternoon',
//             'activity': 'Seine River Cruise',
//             'notes': 'One-hour scenic boat tour passing major landmarks. Audio guides available in multiple languages.'
//           }
//         ]
//       },
//       {
//         'day': 2,
//         'date': 'Tuesday, April 22',
//         'activities': [
//           {
//             'time': 'Morning',
//             'activity': 'Louvre Museum',
//             'notes': 'Focus on key works like Mona Lisa, Venus de Milo, and Winged Victory. Pick up a museum map.'
//           },
//           {
//             'time': 'Afternoon',
//             'activity': 'Tuileries Garden & Place de la Concorde',
//             'notes': 'Leisurely walk through historic gardens and square. Great photo opportunities.'
//           },
//           {
//             'time': 'Evening',
//             'activity': 'Dinner in Le Marais',
//             'notes': 'Explore this trendy district with many restaurant options from traditional to contemporary.'
//           }
//         ]
//       },
//       {
//         'day': 3,
//         'date': 'Wednesday, April 23',
//         'activities': [
//           {
//             'time': 'Morning',
//             'activity': 'Montmartre Walking Tour',
//             'notes': 'Visit Sacré-Cœur Basilica, Place du Tertre, and see where famous artists once lived.'
//           },
//           {
//             'time': 'Lunch',
//             'activity': 'Authentic Crêperie',
//             'notes': 'Try both savory (galettes) and sweet crêpes at a local favorite spot.'
//           },
//           {
//             'time': 'Afternoon',
//             'activity': 'Shopping on Champs-Élysées',
//             'notes': 'Walk the famous avenue from Arc de Triomphe to Place de la Concorde. Mix of luxury and mainstream shops.'
//           }
//         ]
//       }
//     ],
//     'tokyo': [
//       {
//         'day': 1,
//         'date': 'Monday, April 21',
//         'activities': [
//           {
//             'time': 'Morning',
//             'activity': 'Tsukiji Outer Market',
//             'notes': 'Best visited early for breakfast/brunch with the freshest seafood. Try various food stalls.'
//           },
//           {
//             'time': 'Afternoon',
//             'activity': 'Senso-ji Temple & Asakusa',
//             'notes': 'Explore Japan\'s oldest Buddhist temple and the charming traditional area around it.'
//           },
//           {
//             'time': 'Evening',
//             'activity': 'Tokyo Skytree',
//             'notes': 'Visit observation deck for stunning night views of Tokyo\'s skyline. Last admission at 9pm.'
//           }
//         ]
//       },
//       {
//         'day': 2,
//         'date': 'Tuesday, April 22',
//         'activities': [
//           {
//             'time': 'Morning',
//             'activity': 'Meiji Shrine & Yoyogi Park',
//             'notes': 'Peaceful forest shrine in the heart of Tokyo. Try to witness a traditional wedding if lucky.'
//           },
//           {
//             'time': 'Afternoon',
//             'activity': 'Harajuku & Takeshita Street',
//             'notes': 'Experience Tokyo\'s youth culture, fashion boutiques, and unique crepe stands.'
//           },
//           {
//             'time': 'Evening',
//             'activity': 'Shibuya Crossing & Neighborhood',
//             'notes': 'Witness the famous scramble crossing and explore the exciting entertainment district.'
//           }
//         ]
//       },
//       {
//         'day': 3,
//         'date': 'Wednesday, April 23',
//         'activities': [
//           {
//             'time': 'Morning',
//             'activity': 'TeamLab Borderless Museum',
//             'notes': 'Allow plenty of time to explore this immersive digital art space. Book tickets in advance.'
//           },
//           {
//             'time': 'Lunch',
//             'activity': 'Ramen at Yokohama Ramen Museum',
//             'notes': 'Sample different regional ramen styles all in one location.'
//           },
//           {
//             'time': 'Afternoon',
//             'activity': 'Odaiba Waterfront',
//             'notes': 'Visit the entertainment island with shopping malls, games centers and a small replica of the Statue of Liberty.'
//           }
//         ]
//       }
//     ],
//     'new york': [
//       {
//         'day': 1,
//         'date': 'Monday, April 21',
//         'activities': [
//           {
//             'time': 'Morning',
//             'activity': 'Central Park Exploration',
//             'notes': 'Visit Bethesda Fountain, Bow Bridge, and Strawberry Fields. Consider renting bikes.'
//           },
//           {
//             'time': 'Afternoon',
//             'activity': 'Metropolitan Museum of Art',
//             'notes': 'Focus on key collections. Don\'t miss the rooftop garden in good weather (May-October).'
//           },
//           {
//             'time': 'Evening',
//             'activity': 'Times Square',
//             'notes': 'Experience the bright lights and energy of this iconic intersection. Best after dark.'
//           }
//         ]
//       },
//       {
//         'day': 2,
//         'date': 'Tuesday, April 22',
//         'activities': [
//           {
//             'time': 'Morning',
//             'activity': 'Statue of Liberty & Ellis Island',
//             'notes': 'Book reserve tickets in advance for crown access. Allow 4-5 hours for both islands.'
//           },
//           {
//             'time': 'Late Afternoon',
//             'activity': 'Wall Street & Financial District',
//             'notes': 'See the New York Stock Exchange, Bull statue, and Federal Hall.'
//           },
//           {
//             'time': 'Evening',
//             'activity': 'Brooklyn Bridge Sunset Walk',
//             'notes': 'Walk from Manhattan to Brooklyn for spectacular skyline views. Allow 1 hour each way.'
//           }
//         ]
//       },
//       {
//         'day': 3,
//         'date': 'Wednesday, April 23',
//         'activities': [
//           {
//             'time': 'Morning',
//             'activity': 'High Line & Chelsea Market',
//             'notes': 'Walk the elevated park built on former railway tracks, then explore gourmet food stalls.'
//           },
//           {
//             'time': 'Afternoon',
//             'activity': 'Museum of Modern Art (MoMA)',
//             'notes': 'Home to renowned modern artworks. Free admission on Friday afternoons.'
//           },
//           {
//             'time': 'Evening',
//             'activity': 'Broadway Show',
//             'notes': 'Experience world-class theater. Consider TKTS booth for discounted same-day tickets.'
//           }
//         ]
//       }
//     ]
//   };

//   // Find destination information based on location name
//   Future<Map<String, dynamic>?> getDestinationInfo(String destination) async {
//     final normalizedDestination = destination.toLowerCase().trim();
    
//     // Try exact match first
//     if (_destinationData.containsKey(normalizedDestination)) {
//       return _destinationData[normalizedDestination];
//     }
    
//     // Try partial match if exact match not found
//     for (final key in _destinationData.keys) {
//       if (key.contains(normalizedDestination) || normalizedDestination.contains(key)) {
//         return _destinationData[key];
//       }
//     }
    
//     // No match found
//     return null;
//   }

//   // Get attractions for a location
//   Future<List<Map<String, dynamic>>?> getAttractions(String location) async {
//     final normalizedLocation = location.toLowerCase().trim();
    
//     // Try exact match first
//     if (_destinationData.containsKey(normalizedLocation)) {
//       return _destinationData[normalizedLocation]?['attractions'] as List<Map<String, dynamic>>?;
//     }
    
//     // Try partial match
//     for (final key in _destinationData.keys) {
//       if (key.contains(normalizedLocation) || normalizedLocation.contains(key)) {
//         return _destinationData[key]?['attractions'] as List<Map<String, dynamic>>?;
//       }
//     }
    
//     // No match found
//     return null;
//   }

//   // Get activities for a location by category
//   Future<Map<String, List<Map<String, dynamic>>>?> getActivities(String location) async {
//     final normalizedLocation = location.toLowerCase().trim();
    
//     // Try exact match first
//     if (_activityData.containsKey(normalizedLocation)) {
//       return _activityData[normalizedLocation];
//     }
    
//     // Try partial match
//     for (final key in _activityData.keys) {
//       if (key.contains(normalizedLocation) || normalizedLocation.contains(key)) {
//         return _activityData[key];
//       }
//     }
    
//     // Use Paris as fallback for demo purposes if no match found
//     return _activityData['paris'];
//   }

//   // Get weather forecast for a location
//   Future<List<Map<String, dynamic>>?> getWeatherForecast(String location, {int days = 7}) async {
//     final normalizedLocation = location.toLowerCase().trim();
    
//     // Try exact match first
//     if (_destinationData.containsKey(normalizedLocation)) {
//       final List<Map<String, dynamic>> forecast = List<Map<String, dynamic>>.from(
//         _destinationData[normalizedLocation]?['weather'] ?? []
//       );
//       return forecast.take(days).toList();
//     }
    
//     // Try partial match
//     for (final key in _destinationData.keys) {
//       if (key.contains(normalizedLocation) || normalizedLocation.contains(key)) {
//         final List<Map<String, dynamic>> forecast = List<Map<String, dynamic>>.from(
//           _destinationData[key]?['weather'] ?? []
//         );
//         return forecast.take(days).toList();
//       }
//     }
    
//     // No match found, return Paris weather as demo fallback
//     final List<Map<String, dynamic>> parisWeather = List<Map<String, dynamic>>.from(
//       _destinationData['paris']?['weather'] ?? []
//     );
//     return parisWeather.take(days).toList();
//   }

//   // Get a sample itinerary for a location
//   Future<List<Map<String, dynamic>>?> getItinerary(String location, {int days = 3}) async {
//     final normalizedLocation = location.toLowerCase().trim();
    
//     // Try exact match first
//     if (_itineraryData.containsKey(normalizedLocation)) {
//       return _itineraryData[normalizedLocation]?.take(days).toList();
//     }
    
//     // Try partial match
//     for (final key in _itineraryData.keys) {
//       if (key.contains(normalizedLocation) || normalizedLocation.contains(key)) {
//         return _itineraryData[key]?.take(days).toList();
//       }
//     }
    
//     // Use Paris as fallback for demo purposes
//     return _itineraryData['paris']?.take(days).toList();
//   }
  
//   // Integration with the travel data service - enhances prompts with demo data
//   Future<String> augmentPromptWithData(String originalPrompt, String location) async {
//     final StringBuffer augmentedPrompt = StringBuffer(originalPrompt);
//     augmentedPrompt.write("\n\nHere is some real-time data to help you make accurate recommendations:\n");
    
//     // Add destination info
//     final destinationInfo = await getDestinationInfo(location);
//     if (destinationInfo != null) {
//       augmentedPrompt.write("\nDESTINATION INFORMATION:\n");
//       // Format key information about the destination
//       if (destinationInfo['description'] != null) {
//         augmentedPrompt.write("${destinationInfo['description']}\n");
//       }
//       if (destinationInfo['bestTimeToVisit'] != null) {
//         augmentedPrompt.write("Best time to visit: ${destinationInfo['bestTimeToVisit']}\n");
//       }
//       if (destinationInfo['language'] != null) {
//         augmentedPrompt.write("Language: ${destinationInfo['language']}\n");
//       }
//       if (destinationInfo['currency'] != null) {
//         augmentedPrompt.write("Currency: ${destinationInfo['currency']}\n");
//       }
//     }
    
//     // Add attractions
//     final attractions = await getAttractions(location);
//     if (attractions != null && attractions.isNotEmpty) {
//       augmentedPrompt.write("\nTOP ATTRACTIONS:\n");
//       final int count = attractions.length > 5 ? 5 : attractions.length;
//       for (int i = 0; i < count; i++) {
//         final attraction = attractions[i];
//         augmentedPrompt.write("- ${attraction['name']}: ${attraction['shortDescription']}\n");
//       }
//     }
    
//     // Add weather information
//     final weather = await getWeatherForecast(location);
//     if (weather != null && weather.isNotEmpty) {
//       augmentedPrompt.write("\nWEATHER FORECAST:\n");
//       for (final day in weather) {
//         augmentedPrompt.write("- ${day['date']}: ${day['condition']}, " +
//             "High: ${day['tempC']}°C / ${day['tempF']}°F\n");
//       }
//     }
    
//     augmentedPrompt.write("\nBased on this real data, please provide accurate recommendations.");
//     debugPrint("Augmented prompt with demo data for: $location");
//     return augmentedPrompt.toString();
//   }
// }