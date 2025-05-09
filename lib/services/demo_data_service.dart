// import 'package:flutter/material.dart';

// /// A service that provides realistic demo data for the travel app MVP
// /// This allows showcasing features without real API connections
// class DemoDataService {
//   // Popular destinations with pre-built information
//   static final Map<String, Map<String, dynamic>> _destinationData = {
//     'nairobi': {
//       'name': 'Nairobi, Kenya',
//       'description': 'Nairobi is Kenya\'s capital city. In addition to its urban core, the city has Nairobi National Park, a large game reserve known for breeding endangered black rhinos and home to giraffes, zebras and lions.',
//       'bestTimeToVisit': 'June to October (Dry Season) or January to February (Hot, Dry)',
//       'language': 'Swahili, English',
//       'currency': 'Kenyan Shilling (KES)',
//       'attractions': [
//         {
//           'name': 'Nairobi National Park',
//           'shortDescription': 'Wildlife park on the outskirts of the city',
//           'imageQuery': 'Nairobi National Park animals',
//           'rating': 4.6
//         },
//         {
//           'name': 'David Sheldrick Wildlife Trust',
//           'shortDescription': 'Elephant orphanage and rehabilitation center',
//           'imageQuery': 'David Sheldrick elephants Nairobi',
//           'rating': 4.8
//         },
//         {
//           'name': 'Giraffe Centre',
//           'shortDescription': 'Conservation center for Rothschild giraffes',
//           'imageQuery': 'Giraffe Centre Nairobi Kenya',
//           'rating': 4.7
//         },
//         {
//           'name': 'Karen Blixen Museum',
//           'shortDescription': 'Former home of the "Out of Africa" author',
//           'imageQuery': 'Karen Blixen Museum Nairobi',
//           'rating': 4.5
//         },
//         {
//           'name': 'Bomas of Kenya',
//           'shortDescription': 'Cultural center showcasing traditional Kenyan villages and dances',
//           'imageQuery': 'Bomas of Kenya cultural dance',
//           'rating': 4.4
//         }
//       ],
//       'weather': [
//         {'date': '2025-07-15', 'condition': 'Sunny', 'tempC': 22, 'tempF': 72},
//         {'date': '2025-07-16', 'condition': 'Partly cloudy', 'tempC': 21, 'tempF': 70},
//         {'date': '2025-07-17', 'condition': 'Clear', 'tempC': 23, 'tempF': 73},
//         {'date': '2025-01-20', 'condition': 'Hot and Sunny', 'tempC': 28, 'tempF': 82},
//         {'date': '2025-01-21', 'condition': 'Clear', 'tempC': 29, 'tempF': 84},
//       ]
//     },
//     'mombasa': {
//       'name': 'Mombasa, Kenya',
//       'description': 'Mombasa is a coastal city in southeastern Kenya along the Indian Ocean. It has a rich history and is known for its beautiful beaches, coral reefs, and Swahili culture.',
//       'bestTimeToVisit': 'June to October (Cool and Dry) or January to March (Hot and Humid)',
//       'language': 'Swahili, English',
//       'currency': 'Kenyan Shilling (KES)',
//       'attractions': [
//         {
//           'name': 'Fort Jesus',
//           'shortDescription': '16th-century Portuguese fort, a UNESCO World Heritage site',
//           'imageQuery': 'Fort Jesus Mombasa Kenya',
//           'rating': 4.5
//         },
//         {
//           'name': 'Diani Beach',
//           'shortDescription': 'Popular beach destination south of Mombasa',
//           'imageQuery': 'Diani Beach Kenya white sand',
//           'rating': 4.8
//         },
//         {
//           'name': 'Haller Park',
//           'shortDescription': 'Rehabilitated quarry now a nature park with animals',
//           'imageQuery': 'Haller Park Mombasa animals',
//           'rating': 4.6
//         },
//         {
//           'name': 'Mombasa Old Town',
//           'shortDescription': 'Historic area with narrow streets and Swahili architecture',
//           'imageQuery': 'Mombasa Old Town architecture',
//           'rating': 4.4
//         },
//         {
//           'name': 'Mombasa Marine National Park',
//           'shortDescription': 'Marine reserve with coral reefs and diverse sea life',
//           'imageQuery': 'Mombasa Marine Park snorkeling',
//           'rating': 4.7
//         }
//       ],
//       'weather': [
//         {'date': '2025-08-10', 'condition': 'Sunny intervals', 'tempC': 27, 'tempF': 81},
//         {'date': '2025-08-11', 'condition': 'Breezy', 'tempC': 26, 'tempF': 79},
//         {'date': '2025-02-15', 'condition': 'Hot and Sunny', 'tempC': 32, 'tempF': 90},
//       ]
//     },
//     'maasai-mara': {
//       'name': 'Maasai Mara National Reserve, Kenya',
//       'description': 'One of Africa\'s greatest wildlife reserves, famous for the Great Migration of wildebeest and other animals. It offers incredible safari experiences.',
//       'bestTimeToVisit': 'July to October (Great Migration) or January to March (Dry Season)',
//       'language': 'Maa, Swahili, English',
//       'currency': 'Kenyan Shilling (KES)',
//       'attractions': [
//         {
//           'name': 'Great Wildebeest Migration',
//           'shortDescription': 'Annual migration of millions of wildebeest, zebras, and gazelles',
//           'imageQuery': 'Maasai Mara Great Migration river crossing',
//           'rating': 5.0
//         },
//         {
//           'name': 'Hot Air Balloon Safari',
//           'shortDescription': 'Scenic balloon rides over the Mara plains at sunrise',
//           'imageQuery': 'Maasai Mara hot air balloon safari',
//           'rating': 4.9
//         },
//         {
//           'name': 'Maasai Village Visit',
//           'shortDescription': 'Cultural experience visiting a traditional Maasai village',
//           'imageQuery': 'Maasai village Kenya culture',
//           'rating': 4.6
//         },
//         {
//           'name': 'Big Five Sighting',
//           'shortDescription': 'Opportunity to see lions, leopards, elephants, rhinos, and buffalo',
//           'imageQuery': 'Maasai Mara Big Five safari',
//           'rating': 4.8
//         }
//       ],
//       'weather': [
//         {'date': '2025-09-05', 'condition': 'Sunny with cool mornings', 'tempC': 24, 'tempF': 75},
//         {'date': '2025-09-06', 'condition': 'Clear skies', 'tempC': 25, 'tempF': 77},
//         {'date': '2025-02-10', 'condition': 'Warm and dry', 'tempC': 29, 'tempF': 84},
//       ]
//     },
//      'amboseli': {
//       'name': 'Amboseli National Park, Kenya',
//       'description': 'Known for its large elephant herds and views of immense Mount Kilimanjaro, across the border in Tanzania. Observation Hill offers panoramas of the peak and the park’s plains and swamps.',
//       'bestTimeToVisit': 'June to October (Dry season) or January to February',
//       'language': 'Maa, Swahili, English',
//       'currency': 'Kenyan Shilling (KES)',
//       'attractions': [
//         {
//           'name': 'View of Mount Kilimanjaro',
//           'shortDescription': 'Iconic views of Africa\'s highest peak',
//           'imageQuery': 'Amboseli Mount Kilimanjaro view elephants',
//           'rating': 4.9
//         },
//         {
//           'name': 'Large Elephant Herds',
//           'shortDescription': 'Famous for its significant population of African elephants',
//           'imageQuery': 'Amboseli elephant herds Kenya',
//           'rating': 4.8
//         },
//         {
//           'name': 'Observation Hill',
//           'shortDescription': 'Panoramic views of the park, swamps, and Kilimanjaro',
//           'imageQuery': 'Amboseli Observation Hill view',
//           'rating': 4.7
//         },
//         {
//           'name': 'Bird Watching',
//           'shortDescription': 'Rich birdlife with over 400 species, including pelicans and flamingos in swamp areas',
//           'imageQuery': 'Amboseli bird watching flamingos',
//           'rating': 4.5
//         }
//       ],
//       'weather': [
//         {'date': '2025-07-20', 'condition': 'Clear and Sunny', 'tempC': 26, 'tempF': 79},
//         {'date': '2025-07-21', 'condition': 'Dry and Warm', 'tempC': 27, 'tempF': 81},
//       ]
//     },
//     'lamu': {
//       'name': 'Lamu Island, Kenya',
//       'description': 'A part of Kenya’s Lamu Archipelago, Lamu Old Town is the oldest and best-preserved Swahili settlement in East Africa, a UNESCO World Heritage Site. Known for its narrow streets, dhows, and relaxed pace of life.',
//       'bestTimeToVisit': 'July to October or January to March',
//       'language': 'Swahili, English',
//       'currency': 'Kenyan Shilling (KES)',
//       'attractions': [
//         {
//           'name': 'Lamu Old Town',
//           'shortDescription': 'UNESCO World Heritage site with unique Swahili architecture',
//           'imageQuery': 'Lamu Old Town Kenya streets',
//           'rating': 4.7
//         },
//         {
//           'name': 'Shela Beach',
//           'shortDescription': 'Pristine beach known for its tranquility and beauty',
//           'imageQuery': 'Shela Beach Lamu Kenya',
//           'rating': 4.8
//         },
//         {
//           'name': 'Dhow Sailing',
//           'shortDescription': 'Traditional sailing boat trips around the archipelago',
//           'imageQuery': 'Lamu dhow sailing sunset',
//           'rating': 4.9
//         },
//         {
//           'name': 'Lamu Museum',
//           'shortDescription': 'Exhibits on Swahili culture and local history',
//           'imageQuery': 'Lamu Museum Kenya artifacts',
//           'rating': 4.4
//         }
//       ],
//       'weather': [
//         {'date': '2025-08-15', 'condition': 'Warm and Breezy', 'tempC': 28, 'tempF': 82},
//         {'date': '2025-02-20', 'condition': 'Hot and Sunny', 'tempC': 31, 'tempF': 88},
//       ]
//     }
//   };

//   // Sample itineraries for popular destinations
//   static final Map<String, List<Map<String, dynamic>>> _itineraryData = {
//     'nairobi': [
//       {
//         'day': 1,
//         'date': 'Day 1',
//         'activities': [
//           {
//             'time': 'Morning',
//             'activity': 'David Sheldrick Wildlife Trust',
//             'notes': 'Visit during public viewing hours (usually 11am-12pm) to see baby elephants being fed.'
//           },
//           {
//             'time': 'Lunch',
//             'activity': 'Utamaduni Craft Centre or nearby restaurant',
//             'notes': 'Shop for crafts and enjoy a Kenyan meal.'
//           },
//           {
//             'time': 'Afternoon',
//             'activity': 'Giraffe Centre',
//             'notes': 'Feed the Rothschild giraffes and learn about conservation efforts.'
//           },
//           {
//             'time': 'Evening',
//             'activity': 'Dinner at Carnivore Restaurant',
//             'notes': 'Experience a unique "beast of a feast" with various game meats (and vegetarian options).'
//           }
//         ]
//       },
//       {
//         'day': 2,
//         'date': 'Day 2',
//         'activities': [
//           {
//             'time': 'Morning',
//             'activity': 'Nairobi National Park Safari',
//             'notes': 'Early morning game drive to see wildlife against the city skyline.'
//           },
//           {
//             'time': 'Lunch',
//             'activity': 'Picnic in the park or restaurant near the park',
//             'notes': 'Enjoy the natural surroundings.'
//           },
//           {
//             'time': 'Afternoon',
//             'activity': 'Karen Blixen Museum & Kazuri Beads Factory',
//             'notes': 'Explore colonial history and support local women artisans.'
//           }
//         ]
//       }
//     ],
//     'mombasa': [
//       {
//         'day': 1,
//         'date': 'Day 1',
//         'activities': [
//           {
//             'time': 'Morning',
//             'activity': 'Fort Jesus Visit',
//             'notes': 'Explore the historic fort and learn about Mombasa\'s past.'
//           },
//           {
//             'time': 'Lunch',
//             'activity': 'Swahili cuisine in Old Town',
//             'notes': 'Try local dishes like pilau or biryani.'
//           },
//           {
//             'time': 'Afternoon',
//             'activity': 'Explore Mombasa Old Town',
//             'notes': 'Wander through the narrow streets, admire the architecture, and shop for souvenirs.'
//           },
//           {
//             'time': 'Evening',
//             'activity': 'Dinner at a beachfront restaurant',
//             'notes': 'Enjoy fresh seafood with ocean views.'
//           }
//         ]
//       },
//       {
//         'day': 2,
//         'date': 'Day 2',
//         'activities': [
//           {
//             'time': 'Full Day',
//             'activity': 'Diani Beach Relaxation & Activities',
//             'notes': 'Travel to Diani. Relax on the white sandy beaches, swim, snorkel, or try watersports.'
//           },
//           {
//             'time': 'Evening',
//             'activity': 'Sunset Dhow Cruise (optional)',
//             'notes': 'Enjoy a scenic cruise if available.'
//           }
//         ]
//       }
//     ],
//     'maasai-mara': [
//       {
//         'day': 1,
//         'date': 'Day 1',
//         'activities': [
//           {
//             'time': 'Afternoon',
//             'activity': 'Arrival & Evening Game Drive',
//             'notes': 'Fly or drive to Maasai Mara, check into your lodge/camp, and head out for your first game drive.'
//           },
//           {
//             'time': 'Evening',
//             'activity': 'Dinner and Relaxation at Lodge/Camp',
//             'notes': 'Enjoy the sounds of the African bush.'
//           }
//         ]
//       },
//       {
//         'day': 2,
//         'date': 'Day 2',
//         'activities': [
//           {
//             'time': 'Morning',
//             'activity': 'Full Day Game Drive with Picnic Lunch',
//             'notes': 'Explore different areas of the Mara, searching for the Big Five and other wildlife. Witness the Great Migration if in season (July-Oct).'
//           },
//            {
//             'time': 'Afternoon',
//             'activity': 'Continue Game Drive or Optional Maasai Village Visit',
//             'notes': 'Learn about Maasai culture (additional cost usually applies).'
//           }
//         ]
//       },
//       {
//         'day': 3,
//         'date': 'Day 3',
//         'activities': [
//           {
//             'time': 'Morning',
//             'activity': 'Optional Hot Air Balloon Safari or Early Morning Game Drive',
//             'notes': 'Balloon safari offers breathtaking views (book in advance, extra cost). Followed by breakfast and departure.'
//           }
//         ]
//       }
//     ]
//   };

//   // Activity suggestions by category and location
//   static final Map<String, Map<String, List<Map<String, dynamic>>>> _activityData = {
//     'nairobi': {
//       'Wildlife & Nature': [
//         {
//           'name': 'Nairobi National Park Safari Drive',
//           'description': 'Experience a unique safari with the city skyline as a backdrop. Spot lions, giraffes, rhinos, and more.',
//           'duration': '4-5 hours',
//           'price': 'KES $$$',
//           'imageQuery': 'Nairobi National Park safari vehicle',
//           'highlights': ['Closest National Park to a city center', 'Black rhino sanctuary', 'Diverse wildlife']
//         },
//         {
//           'name': 'Visit the Giraffe Centre',
//           'description': 'Get up close and personal with endangered Rothschild giraffes. Feed them and learn about conservation.',
//           'duration': '1-2 hours',
//           'price': 'KES $',
//           'imageQuery': 'Feeding giraffe Nairobi Centre',
//           'highlights': ['Kiss a giraffe', 'Educational talks', 'Nature trail']
//         }
//       ],
//       'Cultural Experience': [
//         {
//           'name': 'Bomas of Kenya Tour',
//           'description': 'Discover Kenya\'s diverse ethnic groups through traditional dances, music, and homestead replicas.',
//           'duration': '3-4 hours',
//           'price': 'KES $$',
//           'imageQuery': 'Bomas of Kenya dancers',
//           'highlights': ['Vibrant traditional dances', 'Cultural village tour', 'Acrobatic shows']
//         },
//         {
//           'name': 'Karen Blixen Museum Visit',
//           'description': 'Step back in time at the former home of the "Out of Africa" author, Karen Blixen.',
//           'duration': '1-2 hours',
//           'price': 'KES $$',
//           'imageQuery': 'Karen Blixen Museum house Nairobi',
//           'highlights': ['Colonial history', 'Beautiful gardens', 'Movie memorabilia']
//         }
//       ],
//       'Food & Dining': [
//         {
//           'name': 'Dinner at Carnivore Restaurant',
//           'description': 'A world-famous restaurant offering a variety of game meats roasted on traditional Maasai swords.',
//           'duration': '2-3 hours',
//           'price': 'KES $$$$',
//           'imageQuery': 'Carnivore Restaurant Nairobi meat',
//           'highlights': ['Unique dining experience', 'Nyama Choma (roasted meat)', 'Vegetarian options available']
//         }
//       ]
//     },
//     'mombasa': {
//       'Beach & Water Activities': [
//         {
//           'name': 'Diani Beach Relaxation',
//           'description': 'Unwind on the pristine white sands of Diani Beach, swim in the turquoise waters, or enjoy beachside amenities.',
//           'duration': 'Half to Full Day',
//           'price': 'Free (activity costs vary)',
//           'imageQuery': 'Diani Beach Kenya palm trees',
//           'highlights': ['Award-winning beach', 'Watersports (snorkeling, diving, kitesurfing)', 'Beach resorts']
//         },
//         {
//           'name': 'Mombasa Marine Park Snorkeling/Diving',
//           'description': 'Explore vibrant coral reefs and diverse marine life in the protected waters of the marine park.',
//           'duration': '3-4 hours',
//           'price': 'KES $$$',
//           'imageQuery': 'Mombasa Marine Park colorful fish',
//           'highlights': ['Clear waters', 'Coral gardens', 'Chance to see dolphins']
//         }
//       ],
//       'Historical & Cultural': [
//         {
//           'name': 'Fort Jesus Exploration',
//           'description': 'Discover the rich history of this 16th-century Portuguese fort, a UNESCO World Heritage site.',
//           'duration': '2-3 hours',
//           'price': 'KES $$',
//           'imageQuery': 'Fort Jesus Mombasa cannons',
//           'highlights': ['Historical architecture', 'Museum exhibits', 'Panoramic ocean views']
//         },
//         {
//           'name': 'Old Town Walking Tour',
//           'description': 'Wander through the narrow, winding streets of Mombasa\'s historic Old Town, admiring the unique Swahili architecture and bustling markets.',
//           'duration': '2-3 hours',
//           'price': 'KES $ (guide optional)',
//           'imageQuery': 'Mombasa Old Town carved doors',
//           'highlights': ['Swahili culture', 'Spice market', 'Local crafts']
//         }
//       ]
//     },
//     'maasai-mara': {
//       'Safari Experience': [
//         {
//           'name': 'Full Day Game Drive',
//           'description': 'Embark on an extensive game drive across the Maasai Mara plains to spot the Big Five and witness the incredible wildlife density.',
//           'duration': '8-10 hours',
//           'price': 'Included in most safari packages',
//           'imageQuery': 'Maasai Mara safari jeep lions',
//           'highlights': ['High chance of Big Five sightings', 'Great Migration (seasonal)', 'Vast landscapes']
//         },
//         {
//           'name': 'Hot Air Balloon Safari',
//           'description': 'Experience a breathtaking sunrise hot air balloon ride over the Mara, followed by a champagne bush breakfast.',
//           'duration': '3-4 hours (early morning)',
//           'price': 'KES $$$$$',
//           'imageQuery': 'Maasai Mara balloon safari sunrise animals',
//           'highlights': ['Unforgettable aerial views', 'Wildlife spotting from above', 'Champagne breakfast']
//         }
//       ],
//       'Cultural Immersion': [
//         {
//           'name': 'Maasai Village Visit',
//           'description': 'Visit a traditional Maasai village to learn about their unique culture, customs, and way of life.',
//           'duration': '1-2 hours',
//           'price': 'KES $$',
//           'imageQuery': 'Maasai warriors jumping Kenya',
//           'highlights': ['Traditional dances', 'Manyatta homes', 'Local crafts']
//         }
//       ]
//     }
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