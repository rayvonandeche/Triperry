import 'package:flutter/material.dart';

class Destination {
  final String name;
  final String description;
  final String imageUrl;
  final List<String> tags;
  
  Destination({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.tags,
  });
}

/// Service that provides dummy travel data for the MVP
/// In a production app, this would be replaced with a real database or API service
class TravelDataService {
  /// Returns a list of travel interests with descriptions
  Map<String, String> getTravelInterests() {
    return {
      'beach': 'Beautiful coastal destinations with sandy beaches and ocean activities.',
      'mountain': 'Scenic mountain landscapes perfect for hiking, skiing, and outdoor adventures.',
      'city': 'Vibrant urban destinations with cultural attractions, dining, and nightlife.',
      'cultural': 'Destinations rich in history, art, architecture, and local traditions.',
      'food': 'Culinary destinations known for exceptional dining experiences and local cuisine.',
      'adventure': 'Locations offering thrilling activities like hiking, diving, and extreme sports.',
      'relaxation': 'Peaceful retreats focused on wellness, spas, and natural beauty.'
    };
  }
  
  /// Returns detailed information about a specific interest
  Map<String, dynamic> getInterestInformation(String interest) {
    final Map<String, dynamic> interestData = {
      'beach': {
        'description': 'Beach destinations offer relaxation, water sports, and stunning coastal views.',
        'bestSeasons': ['Summer', 'Spring'],
        'popularActivities': ['Swimming', 'Snorkeling', 'Sunbathing', 'Beach volleyball', 'Boat tours'],
        'tips': [
          'Pack sunscreen with high SPF',
          'Bring water shoes for rocky beaches',
          'Check tide schedules for certain beaches',
          'Consider beach destinations in shoulder seasons for fewer crowds'
        ]
      },
      'mountain': {
        'description': 'Mountain destinations feature breathtaking landscapes, hiking trails, and adventure sports.',
        'bestSeasons': ['Summer', 'Fall', 'Winter'],
        'popularActivities': ['Hiking', 'Skiing', 'Mountain biking', 'Paragliding', 'Photography'],
        'tips': [
          'Pack layers for changing mountain weather',
          'Acclimatize to higher altitudes gradually',
          'Wear proper hiking boots for treks',
          'Check weather forecasts daily as mountain weather can change quickly'
        ]
      },
      'city': {
        'description': 'Cities offer cultural attractions, museums, shopping districts, and vibrant nightlife.',
        'bestSeasons': ['Spring', 'Fall'],
        'popularActivities': ['Museum visits', 'Shopping', 'Dining out', 'Cultural events', 'Architecture tours'],
        'tips': [
          'Get city passes for multiple attractions',
          'Use public transportation to avoid parking issues',
          'Book popular attractions in advance',
          'Explore neighborhoods beyond tourist centers'
        ]
      },
      'cultural': {
        'description': 'Cultural destinations showcase history, art, architecture, and traditional ways of life.',
        'bestSeasons': ['Spring', 'Fall'],
        'popularActivities': ['Museum visits', 'Historical tours', 'Cultural festivals', 'Art galleries', 'Local workshops'],
        'tips': [
          'Research local customs before visiting',
          'Learn a few phrases in the local language',
          'Respect dress codes at religious sites',
          'Book guided tours for deeper understanding of cultural sites'
        ]
      },
      'food': {
        'description': 'Food-focused destinations offer exceptional culinary experiences and food traditions.',
        'bestSeasons': ['Year-round', 'Harvest seasons'],
        'popularActivities': ['Food tours', 'Cooking classes', 'Market visits', 'Wine tastings', 'Restaurant hopping'],
        'tips': [
          'Research seasonal specialties before visiting',
          'Look for restaurants where locals eat',
          'Book popular restaurants well in advance',
          'Take a cooking class to bring skills home'
        ]
      },
      'adventure': {
        'description': 'Adventure destinations feature exciting activities and adrenaline-pumping experiences.',
        'bestSeasons': ['Summer', 'Spring'],
        'popularActivities': ['Hiking', 'Rafting', 'Zip-lining', 'Bungee jumping', 'Scuba diving'],
        'tips': [
          'Verify safety standards for adventure operators',
          'Get appropriate travel insurance for adventure activities',
          'Train beforehand for physically demanding activities',
          'Pack proper gear for specific adventures'
        ]
      },
      'relaxation': {
        'description': 'Relaxation destinations focus on wellness, spa experiences, and peaceful natural settings.',
        'bestSeasons': ['Year-round'],
        'popularActivities': ['Spa treatments', 'Yoga classes', 'Meditation', 'Nature walks', 'Hot springs'],
        'tips': [
          'Book spa treatments in advance',
          'Pack comfortable clothing for wellness activities',
          'Consider digital detox for a true relaxation experience',
          'Look for all-inclusive wellness retreats'
        ]
      }
    };
    
    return interestData[interest] ?? {'description': 'Information not available for this interest'};
  }
  
  /// Returns destinations that match a particular interest
  List<Map<String, dynamic>> getDestinationsForInterest(String interest) {
    final Map<String, List<Map<String, dynamic>>> interestDestinations = {
      'beach': [
        {
          'name': 'Bali, Indonesia',
          'description': 'Tropical island with beautiful beaches, vibrant culture, and wellness retreats.',
          'imageUrl': 'https://example.com/bali.jpg',
          'travelSeasons': ['April-October', 'Year-round except rainy season (Nov-Mar)']
        },
        {
          'name': 'Maldives',
          'description': 'Pristine beaches and overwater bungalows in a tropical paradise.',
          'imageUrl': 'https://example.com/maldives.jpg',
          'travelSeasons': ['November-April', 'Dry season with minimal rain']
        },
        {
          'name': 'Amalfi Coast, Italy',
          'description': 'Stunning Mediterranean coastline with colorful villages and scenic beaches.',
          'imageUrl': 'https://example.com/amalfi.jpg',
          'travelSeasons': ['May-September', 'Warm weather perfect for swimming']
        }
      ],
      'mountain': [
        {
          'name': 'Swiss Alps, Switzerland',
          'description': 'Majestic mountain range with world-class skiing and hiking opportunities.',
          'imageUrl': 'https://example.com/swiss-alps.jpg',
          'travelSeasons': ['December-March (skiing)', 'June-September (hiking)']
        },
        {
          'name': 'Patagonia, Argentina/Chile',
          'description': 'Dramatic landscapes with towering peaks, glaciers, and pristine wilderness.',
          'imageUrl': 'https://example.com/patagonia.jpg',
          'travelSeasons': ['December-February (summer)', 'March-April (fall colors)']
        },
        {
          'name': 'Canadian Rockies, Canada',
          'description': 'Spectacular mountain scenery with turquoise lakes and abundant wildlife.',
          'imageUrl': 'https://example.com/canadian-rockies.jpg',
          'travelSeasons': ['June-September (summer)', 'December-March (winter sports)']
        }
      ],
      'city': [
        {
          'name': 'Tokyo, Japan',
          'description': 'Ultra-modern city with cutting-edge technology alongside traditional culture.',
          'imageUrl': 'https://example.com/tokyo.jpg',
          'travelSeasons': ['March-May (cherry blossoms)', 'September-November (fall colors)']
        },
        {
          'name': 'Barcelona, Spain',
          'description': 'Mediterranean city known for striking architecture and vibrant street life.',
          'imageUrl': 'https://example.com/barcelona.jpg',
          'travelSeasons': ['May-June', 'September-October (mild weather, fewer crowds)']
        },
        {
          'name': 'New York City, USA',
          'description': 'Iconic global city with world-class museums, dining, and entertainment.',
          'imageUrl': 'https://example.com/nyc.jpg',
          'travelSeasons': ['April-June', 'September-November (pleasant weather)']
        }
      ],
      'cultural': [
        {
          'name': 'Kyoto, Japan',
          'description': 'Ancient capital with over 1,600 Buddhist temples and 400 Shinto shrines.',
          'imageUrl': 'https://example.com/kyoto.jpg',
          'travelSeasons': ['March-May (cherry blossoms)', 'October-November (fall colors)']
        },
        {
          'name': 'Rome, Italy',
          'description': 'Eternal City with ancient ruins, Renaissance art, and vibrant street life.',
          'imageUrl': 'https://example.com/rome.jpg',
          'travelSeasons': ['April-May', 'September-October (mild weather, fewer tourists)']
        },
        {
          'name': 'Marrakech, Morocco',
          'description': 'Ancient walled city with bustling souks, palaces, and vibrant cultural traditions.',
          'imageUrl': 'https://example.com/marrakech.jpg',
          'travelSeasons': ['March-May', 'October-November (mild temperatures)']
        }
      ],
      'food': [
        {
          'name': 'Lyon, France',
          'description': 'Gastronomic capital of France with traditional bouchons and Michelin-starred restaurants.',
          'imageUrl': 'https://example.com/lyon.jpg',
          'travelSeasons': ['April-October (pleasant outdoor dining weather)']
        },
        {
          'name': 'Bangkok, Thailand',
          'description': 'Street food paradise with vibrant markets and bold flavors.',
          'imageUrl': 'https://example.com/bangkok.jpg',
          'travelSeasons': ['November-February (cool dry season)']
        },
        {
          'name': 'San Sebastian, Spain',
          'description': 'Basque culinary haven with the highest concentration of Michelin stars per capita.',
          'imageUrl': 'https://example.com/san-sebastian.jpg',
          'travelSeasons': ['May-July', 'September (best weather and fewer tourists)']
        }
      ],
      'adventure': [
        {
          'name': 'Queenstown, New Zealand',
          'description': 'Adventure capital offering bungee jumping, skydiving, and jet boating.',
          'imageUrl': 'https://example.com/queenstown.jpg',
          'travelSeasons': ['December-February (summer)', 'June-September (skiing)']
        },
        {
          'name': 'Costa Rica',
          'description': 'Tropical paradise with rainforest zip-lining, surfing, and wildlife encounters.',
          'imageUrl': 'https://example.com/costa-rica.jpg',
          'travelSeasons': ['December-April (dry season)']
        },
        {
          'name': 'Moab, Utah, USA',
          'description': 'Desert adventure hub for mountain biking, rock climbing, and river rafting.',
          'imageUrl': 'https://example.com/moab.jpg',
          'travelSeasons': ['March-May', 'September-October (avoid summer heat)']
        }
      ],
      'relaxation': [
        {
          'name': 'Tulum, Mexico',
          'description': 'Beachfront wellness destination with yoga retreats and bohemian atmosphere.',
          'imageUrl': 'https://example.com/tulum.jpg',
          'travelSeasons': ['November-April (dry season with perfect temperatures)']
        },
        {
          'name': 'Bali, Indonesia',
          'description': 'Island of the Gods with spiritual retreats, yoga, and healing traditions.',
          'imageUrl': 'https://example.com/bali-relaxation.jpg',
          'travelSeasons': ['April-October (dry season)']
        },
        {
          'name': 'Santorini, Greece',
          'description': 'Stunning island with white-washed buildings, infinity pools, and spectacular sunsets.',
          'imageUrl': 'https://example.com/santorini.jpg',
          'travelSeasons': ['May-October (warm weather and clear skies)']
        }
      ]
    };
    
    return interestDestinations[interest] ?? 
      [{'name': 'Custom destinations will be suggested based on your specific interests'}];
  }
  
  /// Returns detailed information about a specific destination
  Map<String, dynamic> getDestinationDetails(String destination) {
    final Map<String, Map<String, dynamic>> destinationData = {
      'Bali, Indonesia': {
        'description': 'Bali is a tropical paradise known for its beautiful beaches, terraced rice fields, and rich cultural heritage. The island offers a mix of relaxation, adventure, and spiritual experiences.',
        'languages': ['Balinese', 'Indonesian', 'English (widely spoken in tourist areas)'],
        'currency': 'Indonesian Rupiah (IDR)',
        'timeZone': 'GMT+8',
        'highlights': [
          'Ubud - cultural heart with art and yoga',
          'Kuta and Seminyak beaches - popular surf spots',
          'Uluwatu Temple - clifftop temple with sunset views',
          'Tegalalang Rice Terraces - stunning agricultural landscapes',
          'Mount Batur - active volcano with sunrise treks'
        ],
        'culturalNotes': [
          'Remove shoes when entering temples or homes',
          'Dress modestly when visiting religious sites',
          'The left hand is considered unclean - use right hand for giving/receiving',
          'Balinese Hinduism is central to daily life, with frequent ceremonies'
        ]
      },
      'Swiss Alps, Switzerland': {
        'description': 'The Swiss Alps are a spectacular mountain range with pristine lakes, charming villages, and world-class outdoor activities. The region is known for excellent infrastructure and breathtaking natural beauty.',
        'languages': ['German', 'French', 'Italian', 'Romansh', 'English (widely spoken in tourist areas)'],
        'currency': 'Swiss Franc (CHF)',
        'timeZone': 'GMT+1 (GMT+2 during daylight saving)',
        'highlights': [
          'Zermatt - resort town below the Matterhorn',
          'St. Moritz - luxury alpine resort town',
          'Interlaken - adventure sports hub between two lakes',
          'Jungfraujoch - "Top of Europe" with spectacular views',
          'Lucerne - picturesque city with mountain backdrop'
        ],
        'culturalNotes': [
          'Punctuality is highly valued in Swiss culture',
          'Hiking trails are well-marked with yellow signs',
          'Recycling is taken seriously - sort waste properly',
          'Swiss people value privacy and personal space'
        ]
      },
      'Tokyo, Japan': {
        'description': 'Tokyo is a dynamic metropolis that blends ultramodern and traditional elements. The city offers cutting-edge technology, exceptional cuisine, and impeccable service alongside ancient temples and traditions.',
        'languages': ['Japanese', 'English (limited but increasing in tourist areas)'],
        'currency': 'Japanese Yen (JPY)',
        'timeZone': 'GMT+9',
        'highlights': [
          'Shibuya Crossing - famous pedestrian scramble',
          'Shinjuku - business district with great nightlife',
          'Meiji Shrine - forested spiritual haven',
          'Tsukiji Outer Market - culinary wonderland',
          'Akihabara - electronics and anime hub'
        ],
        'culturalNotes': [
          'Bow when greeting people - depth indicates respect level',
          'Remove shoes when entering homes and certain restaurants',
          'Tipping is not customary and can cause confusion',
          'Queue etiquette is strictly observed',
          'Public transportation is extremely punctual'
        ]
      },
      // Placeholders for other destinations
      'Maldives': {
        'description': 'An archipelago of 26 atolls with white sand beaches, crystal clear waters, and overwater bungalows. Known for luxury resorts, marine life, and pristine natural beauty.',
        'languages': ['Dhivehi', 'English (widely spoken in resorts)'],
        'currency': 'Maldivian Rufiyaa (MVR), USD accepted in resorts',
        'timeZone': 'GMT+5'
      },
      'Amalfi Coast, Italy': {
        'description': 'A stunning Mediterranean coastline with dramatic cliffs, colorful fishing villages, and azure waters. Known for its scenic beauty, cuisine, and lemons.',
        'languages': ['Italian', 'English (in tourist areas)'],
        'currency': 'Euro (EUR)',
        'timeZone': 'GMT+1 (GMT+2 during daylight saving)'
      }
    };
    
    return destinationData[destination] ?? 
      {'description': 'Detailed information about this destination will be provided upon selection.'};
  }
  
  /// Returns information about the best times to travel to a destination
  Map<String, dynamic> getBestTimesToTravel(String destination) {
    final Map<String, Map<String, dynamic>> travelTimesData = {
      'Bali, Indonesia': {
        'bestTimes': [
          {'season': 'Dry Season (May-September)', 'description': 'Perfect beach weather with sunny days and lower humidity.'},
          {'season': 'Shoulder Season (April & October)', 'description': 'Good weather with fewer tourists and better prices.'}
        ],
        'avoidTimes': [
          {'season': 'Rainy Season (November-March)', 'description': 'Heavy rainfall can disrupt outdoor activities and create transportation challenges.'},
          {'season': 'Peak Tourist Season (July-August)', 'description': 'Very crowded with higher prices and packed beaches.'}
        ],
        'weatherByMonth': {
          'January': 'Rainy, humid, 26-30°C',
          'February': 'Rainy, humid, 26-30°C',
          'March': 'Decreasing rain, humid, 26-31°C',
          'April': 'Mild rain, pleasant, 26-32°C',
          'May': 'Dry, sunny, 25-32°C',
          'June': 'Dry, sunny, 24-31°C',
          'July': 'Dry, sunny, 23-30°C',
          'August': 'Dry, sunny, 23-30°C',
          'September': 'Dry, sunny, 24-31°C',
          'October': 'Some rain, pleasant, 25-32°C',
          'November': 'Increasing rain, 26-31°C',
          'December': 'Rainy, humid, 26-30°C'
        }
      },
      'Swiss Alps, Switzerland': {
        'bestTimes': [
          {'season': 'Summer (June-August)', 'description': 'Ideal hiking season with lush alpine meadows and pleasant temperatures.'},
          {'season': 'Winter (December-March)', 'description': 'Perfect for skiing and winter sports with reliable snowfall.'}
        ],
        'avoidTimes': [
          {'season': 'Off-season (November & April-May)', 'description': 'Many facilities closed during transition seasons, muddy hiking trails.'}
        ],
        'weatherByMonth': {
          'January': 'Snowy, cold, -10 to 0°C',
          'February': 'Snowy, cold, -10 to 0°C',
          'March': 'Snowy, warming, -5 to 5°C',
          'April': 'Melting snow, mild, 0 to 10°C',
          'May': 'Spring, mild, 5 to 15°C',
          'June': 'Pleasant, mild, 8 to 20°C',
          'July': 'Warm days, mild nights, 10 to 25°C',
          'August': 'Warm days, mild nights, 10 to 25°C',
          'September': 'Mild, cooling, 7 to 18°C',
          'October': 'Cool, possible snow at high elevations, 3 to 12°C',
          'November': 'Cold, possible snow, -2 to 5°C',
          'December': 'Snowy, cold, -10 to 0°C'
        }
      },
      'Tokyo, Japan': {
        'bestTimes': [
          {'season': 'Spring (Late March-May)', 'description': 'Cherry blossom season with mild temperatures and beautiful gardens.'},
          {'season': 'Fall (September-November)', 'description': 'Colorful autumn foliage with comfortable temperatures and clear skies.'}
        ],
        'avoidTimes': [
          {'season': 'Summer (July-August)', 'description': 'Hot, humid, and rainy with temperatures often exceeding 35°C.'},
          {'season': 'New Year Holiday (Late December-Early January)', 'description': 'Many businesses closed as locals travel for holidays.'}
        ],
        'weatherByMonth': {
          'January': 'Cold, dry, 2 to 10°C',
          'February': 'Cold, dry, 2 to 10°C',
          'March': 'Mild, cherry blossoms start, 5 to 13°C',
          'April': 'Pleasant, cherry blossoms in full bloom, 10 to 18°C',
          'May': 'Warm, occasional rain, 15 to 23°C',
          'June': 'Rainy season, humid, 19 to 25°C',
          'July': 'Hot, humid, occasional typhoons, 23 to 30°C',
          'August': 'Hot, humid, 25 to 33°C',
          'September': 'Warm, typhoon risk, 21 to 27°C',
          'October': 'Pleasant, autumn colors begin, 15 to 22°C',
          'November': 'Cool, autumn colors peak, 9 to 17°C',
          'December': 'Cold, dry, 4 to 12°C'
        }
      }
    };
    
    return travelTimesData[destination] ?? {
      'bestTimes': [{'season': 'Custom recommendations', 'description': 'Will be provided upon selection'}]
    };
  }
  
  /// Gets activities available at a destination during a specific time
  List<Map<String, dynamic>> getActivitiesForDestinationAndTime(String destination, String travelTime) {
    // Simplified model - in a real app, this would be a more complex matching algorithm
    final Map<String, List<Map<String, dynamic>>> destinationActivities = {
      'Bali, Indonesia': [
        {
          'name': 'Surfing lessons at Kuta Beach',
          'description': 'Learn to surf with experienced instructors at one of Bali\'s most famous beaches.',
          'cost': 'Medium',
          'bestFor': ['Adventure seekers', 'Beach lovers', 'Active travelers']
        },
        {
          'name': 'Visit the Sacred Monkey Forest',
          'description': 'Explore ancient temples while encountering hundreds of mischievous macaques.',
          'cost': 'Low',
          'bestFor': ['Nature lovers', 'Photographers', 'Cultural experiences']
        },
        {
          'name': 'Ubud Art and Craft Markets',
          'description': 'Shop for traditional Balinese crafts, textiles, and souvenirs in Ubud\'s bustling market.',
          'cost': 'Low',
          'bestFor': ['Shoppers', 'Cultural experiences', 'Souvenir hunters']
        },
        {
          'name': 'Tegalalang Rice Terrace Tour',
          'description': 'Visit the stunning stepped rice fields and learn about the traditional irrigation system.',
          'cost': 'Low',
          'bestFor': ['Photographers', 'Nature lovers', 'Cultural experiences']
        },
        {
          'name': 'Balinese Cooking Class',
          'description': 'Learn to cook traditional Balinese dishes using fresh local ingredients.',
          'cost': 'Medium',
          'bestFor': ['Foodies', 'Cultural experiences', 'Couples']
        }
      ],
      'Swiss Alps, Switzerland': [
        {
          'name': 'Skiing in St. Moritz',
          'description': 'World-class skiing across 350km of slopes in this glamorous Alpine resort.',
          'cost': 'High',
          'bestFor': ['Winter sports enthusiasts', 'Advanced skiers', 'Luxury travelers']
        },
        {
          'name': 'Jungfraujoch Excursion',
          'description': 'Visit "The Top of Europe" with spectacular views from 3,454 meters above sea level.',
          'cost': 'High',
          'bestFor': ['Photographers', 'First-time visitors', 'Train enthusiasts']
        },
        {
          'name': 'Hiking the Eiger Trail',
          'description': 'Spectacular trail along the foot of the Eiger\'s imposing north face.',
          'cost': 'Low',
          'bestFor': ['Hikers', 'Nature lovers', 'Photographers']
        },
        {
          'name': 'Lake Geneva Cruise',
          'description': 'Scenic boat tour of one of Switzerland\'s most beautiful lakes.',
          'cost': 'Medium',
          'bestFor': ['Relaxation seekers', 'Photographers', 'Families']
        },
        {
          'name': 'Chocolate and Cheese Tasting',
          'description': 'Sample Switzerland\'s famous culinary products with expert guidance.',
          'cost': 'Medium',
          'bestFor': ['Foodies', 'Couples', 'Cultural experiences']
        }
      ],
      'Tokyo, Japan': [
        {
          'name': 'Tsukiji Outer Market Tour',
          'description': 'Explore Japan\'s culinary traditions at this famous food market.',
          'cost': 'Low',
          'bestFor': ['Foodies', 'Early risers', 'Cultural experiences']
        },
        {
          'name': 'Robot Restaurant Show',
          'description': 'Experience an over-the-top, uniquely Japanese entertainment spectacle.',
          'cost': 'High',
          'bestFor': ['Entertainment seekers', 'First-time visitors', 'Night owls']
        },
        {
          'name': 'Meiji Shrine and Harajuku Exploration',
          'description': 'Contrast the peaceful shrine with the trendy youth culture district nearby.',
          'cost': 'Low',
          'bestFor': ['Culture seekers', 'Photographers', 'Fashion enthusiasts']
        },
        {
          'name': 'Tokyo Skytree Visit',
          'description': 'See Tokyo from 450 meters up in one of the world\'s tallest towers.',
          'cost': 'Medium',
          'bestFor': ['View seekers', 'Photographers', 'First-time visitors']
        },
        {
          'name': 'Teamlab Borderless Digital Art Museum',
          'description': 'Immerse yourself in this unique interactive digital art experience.',
          'cost': 'Medium',
          'bestFor': ['Art lovers', 'Photographers', 'Families']
        }
      ]
    };
    
    return destinationActivities[destination] ?? 
      [{'name': 'Custom activities', 'description': 'Will be recommended based on your preferences'}];
  }
  
  /// Gets seasonal information for a destination during a specific time
  Map<String, dynamic> getSeasonalInformation(String destination, String travelTime) {
    // Extract season from travel time (simple parsing)
    String season = 'unknown';
    if (travelTime.toLowerCase().contains('summer')) {
      season = 'summer';
    } else if (travelTime.toLowerCase().contains('winter')) {
      season = 'winter';
    } else if (travelTime.toLowerCase().contains('spring')) {
      season = 'spring';
    } else if (travelTime.toLowerCase().contains('fall') || travelTime.toLowerCase().contains('autumn')) {
      season = 'fall';
    }
    
    final Map<String, Map<String, Map<String, dynamic>>> seasonalData = {
      'Bali, Indonesia': {
        'summer': {
          'weather': 'Dry and sunny, 23-30°C with low humidity',
          'crowds': 'Peak tourist season, especially July-August',
          'prices': 'High season rates for accommodation and activities',
          'events': ['Bali Arts Festival (June-July)', 'Kite Festival (July-August)'],
          'tips': [
            'Book accommodation well in advance',
            'Visit popular sites early in the morning to avoid crowds',
            'Hydrate regularly as days can be hot'
          ]
        },
        'winter': {
          'weather': 'Rainy season, 26-30°C with high humidity',
          'crowds': 'Lower except during Christmas/New Year holiday period',
          'prices': 'Lower rates except for holiday periods',
          'events': ['Nyepi (Day of Silence - varies, Feb/Mar)', 'Galungan ceremony (varies)'],
          'tips': [
            'Pack rain gear and mosquito repellent',
            'Plan indoor activities for rainy afternoons',
            'Enjoy discounted accommodation rates',
            'Northern coastal areas receive less rainfall'
          ]
        },
        'spring': {
          'weather': 'Transitioning from wet to dry, 26-32°C',
          'crowds': 'Moderate, building toward high season',
          'prices': 'Moderate, good deals still available',
          'events': ['Nyepi (Day of Silence - varies, Feb/Mar)', 'Saraswati Day (varies)'],
          'tips': [
            'Good balance of weather and crowd levels',
            'Some afternoon rain still possible in April',
            'Book mid-range accommodations a few weeks ahead'
          ]
        },
        'fall': {
          'weather': 'Transitioning from dry to wet, 24-31°C',
          'crowds': 'Moderate, decreasing through November',
          'prices': 'Moderate, decreasing as rainy season approaches',
          'events': ['Ubud Writers & Readers Festival (October)', 'Nusa Dua Festival (October)'],
          'tips': [
            'October is an excellent month with good weather and fewer crowds',
            'November sees increasing rainfall but good deals',
            'Bring lightweight rain gear just in case'
          ]
        }
      },
      'Swiss Alps, Switzerland': {
        'summer': {
          'weather': 'Warm days (15-25°C), cool evenings (8-15°C)',
          'crowds': 'Peak hiking season, popular areas can be crowded',
          'prices': 'High season rates, but lower than winter ski season',
          'events': ['Swiss National Day (August 1)', 'Alpine festivals and yodeling competitions'],
          'tips': [
            'Book mountain huts in advance for popular routes',
            'Start hikes early to avoid afternoon thunderstorms',
            'Purchase regional travel passes for good value'
          ]
        },
        'winter': {
          'weather': 'Cold (-10 to 0°C), snowy conditions',
          'crowds': 'Peak ski season, especially around holidays and weekends',
          'prices': 'Premium rates for ski resorts and accommodations',
          'events': ['Christmas markets (December)', 'World Snow Festival (January)'],
          'tips': [
            'Book ski accommodations months in advance',
            'Consider less famous resorts for better deals',
            'Purchase ski passes online in advance',
            'Winter driving requires chains or winter tires'
          ]
        },
        'spring': {
          'weather': 'Variable (0-15°C), melting snow at lower elevations',
          'crowds': 'Low except for Easter holidays',
          'prices': 'Shoulder season with good deals',
          'events': ['Sechseläuten spring festival in Zurich (April)', 'Basel Fasnacht (varies)'],
          'tips': [
            'Many facilities closed during April-May transition period',
            'Lower elevations good for hiking, upper still good for skiing',
            'Pack layers for variable temperatures'
          ]
        },
        'fall': {
          'weather': 'Cool (5-15°C), possibility of early snow at high elevations',
          'crowds': 'Low, peaceful atmosphere',
          'prices': 'Shoulder season with good deals',
          'events': ['Alpine cattle descents (September)', 'Wine festivals (September-October)'],
          'tips': [
            'September offers beautiful hiking with fewer crowds',
            'Check facility operations as some close in November',
            'Autumn foliage is spectacular in October',
            'Pack warm clothing as evenings are chilly'
          ]
        }
      },
      'Tokyo, Japan': {
        'summer': {
          'weather': 'Hot and humid (25-35°C), rainy season in June',
          'crowds': 'Domestic tourism high, international moderate',
          'prices': 'Moderate with good deals in August',
          'events': ['Sumidagawa Fireworks Festival (July)', 'Obon Festival (August)'],
          'tips': [
            'Use cooling towels and UV umbrellas like locals',
            'Hydrate frequently and take advantage of air-conditioned spaces',
            'Visit museums and indoor attractions during peak heat',
            'Book accommodations with good air conditioning'
          ]
        },
        'winter': {
          'weather': 'Cold and dry (2-10°C), occasional snow',
          'crowds': 'Low except for New Year period',
          'prices': 'Good deals except for New Year holiday',
          'events': ['Emperor\'s Birthday (February 23)', 'Winter illuminations (Dec-Feb)'],
          'tips': [
            'Layer clothing as indoor heating is strong',
            'Enjoy winter illuminations throughout the city',
            'Take advantage of fewer crowds at major attractions',
            'Try seasonal winter foods like hot pot and roasted sweet potatoes'
          ]
        },
        'spring': {
          'weather': 'Mild and pleasant (10-20°C)',
          'crowds': 'Very high during cherry blossom season',
          'prices': 'Premium rates during cherry blossom peak',
          'events': ['Cherry Blossom Festivals (late March-April)', 'Golden Week (late April-early May)'],
          'tips': [
            'Book accommodations months in advance for cherry blossom season',
            'Check cherry blossom forecasts as timing varies each year',
            'Avoid Golden Week (extremely crowded and expensive)',
            'Pack layers as temperatures vary throughout the day'
          ]
        },
        'fall': {
          'weather': 'Mild and pleasant (15-25°C), occasional typhoons in September',
          'crowds': 'High during foliage season (November)',
          'prices': 'Moderate with increases during peak foliage',
          'events': ['Tokyo International Film Festival (October)', 'Shichi-Go-San children\'s festival (November)'],
          'tips': [
            'November offers the best autumn colors',
            'Check typhoon forecasts if visiting in September',
            'Pack layers as temperatures drop in November',
            'Visit gardens like Rikugien for spectacular autumn foliage'
          ]
        }
      }
    };
    
    if (seasonalData.containsKey(destination) && seasonalData[destination]!.containsKey(season)) {
      return seasonalData[destination]![season]!;
    }
    
    // Fallback for unknown destination/season combinations
    return {
      'weather': 'Information will be provided based on your specific travel dates',
      'crowds': 'Varies by season',
      'prices': 'Varies by season',
      'events': ['Various seasonal events'],
      'tips': ['Research specific dates for more accurate seasonal information']
    };
  }
  
  /// Gets a sample itinerary for a destination
  Map<String, dynamic> getSampleItinerary(String destination, String travelTime, String interest) {
    // In a real app, this would generate a customized itinerary using AI
    // For MVP, we'll return a generic template
    
    return {
      'destination': destination,
      'duration': '3 days',
      'focus': interest,
      'days': [
        {
          'day': 1,
          'title': 'Arrival & Orientation',
          'activities': [
            {'time': 'Morning', 'activity': 'Arrive and check in to accommodation'},
            {'time': 'Afternoon', 'activity': 'Walking tour of main area to get oriented'},
            {'time': 'Evening', 'activity': 'Welcome dinner at popular local restaurant'}
          ],
          'tips': 'Take it easy on your first day to adjust to any time differences'
        },
        {
          'day': 2,
          'title': 'Key Attractions',
          'activities': [
            {'time': 'Morning', 'activity': 'Visit the most famous attraction in the area'},
            {'time': 'Afternoon', 'activity': 'Explore secondary attractions or shopping district'},
            {'time': 'Evening', 'activity': 'Experience local entertainment options'}
          ],
          'tips': 'Book any must-see attractions in advance to avoid disappointment'
        },
        {
          'day': 3,
          'title': 'Local Experiences',
          'activities': [
            {'time': 'Morning', 'activity': 'Participate in a local activity or workshop'},
            {'time': 'Afternoon', 'activity': 'Relax at a park, beach, or spa'},
            {'time': 'Evening', 'activity': 'Farewell dinner at recommended restaurant'}
          ],
          'tips': 'Leave some flexibility in your schedule for spontaneous discoveries'
        }
      ]
    };
  }
  
  /// Gets accommodation options for a destination
  List<Map<String, dynamic>> getAccommodationOptions(String destination) {
    final Map<String, List<Map<String, dynamic>>> accommodations = {
      'Bali, Indonesia': [
        {
          'type': 'Luxury Villa',
          'description': 'Private villas with personal pools, often in Seminyak or Ubud',
          'priceRange': '\$\$\$-\$\$\$\$',
          'bestFor': ['Couples', 'Privacy seekers', 'Honeymooners']
        },
        {
          'type': 'Beach Resort',
          'description': 'Full-service resorts along Nusa Dua or Jimbaran Bay',
          'priceRange': '\$\$\$-\$\$\$\$',
          'bestFor': ['Families', 'Beach lovers', 'All-inclusive seekers']
        },
        {
          'type': 'Boutique Hotel',
          'description': 'Smaller, stylish hotels often featuring Balinese design elements',
          'priceRange': '\$\$-\$\$\$',
          'bestFor': ['Culture enthusiasts', 'Design lovers', 'Couples']
        },
        {
          'type': 'Budget Guesthouse',
          'description': 'Family-run accommodations, especially in Ubud and Canggu',
          'priceRange': '\$-\$\$',
          'bestFor': ['Budget travelers', 'Long-term stays', 'Solo travelers']
        },
        {
          'type': 'Eco-Resort',
          'description': 'Sustainable bamboo structures and organic approaches in natural settings',
          'priceRange': '\$\$-\$\$\$',
          'bestFor': ['Environmentally conscious travelers', 'Nature lovers', 'Wellness seekers']
        }
      ],
      'Swiss Alps, Switzerland': [
        {
          'type': 'Luxury Alpine Hotel',
          'description': 'Five-star hotels with spas and gourmet restaurants in prime locations',
          'priceRange': '\$\$\$\$',
          'bestFor': ['Luxury travelers', 'Spa enthusiasts', 'Skiers wanting ski-in/ski-out']
        },
        {
          'type': 'Traditional Chalet',
          'description': 'Wooden Alpine chalets, often family-run with authentic Swiss atmosphere',
          'priceRange': '\$\$\$',
          'bestFor': ['Families', 'Traditional experience seekers', 'Groups']
        },
        {
          'type': 'Mountain Lodge',
          'description': 'Rustic accommodations in scenic mountain locations',
          'priceRange': '\$\$-\$\$\$',
          'bestFor': ['Hikers', 'Nature enthusiasts', 'Active travelers']
        },
        {
          'type': 'Alpine Hostel',
          'description': 'Budget-friendly options with dormitory and private rooms',
          'priceRange': '\$-\$\$',
          'bestFor': ['Budget travelers', 'Solo hikers', 'Young travelers']
        },
        {
          'type': 'Mountain Hut',
          'description': 'Basic accommodations along hiking routes, often at high elevations',
          'priceRange': '\$',
          'bestFor': ['Adventurous hikers', 'Authenticity seekers', 'Budget travelers']
        }
      ],
      'Tokyo, Japan': [
        {
          'type': 'Luxury Hotel',
          'description': 'International and Japanese luxury brands in Ginza or Shinjuku',
          'priceRange': '\$\$\$\$',
          'bestFor': ['Luxury travelers', 'Business travelers', 'First-time visitors']
        },
        {
          'type': 'Boutique Hotel',
          'description': 'Stylish smaller hotels with personalized service',
          'priceRange': '\$\$\$',
          'bestFor': ['Design enthusiasts', 'Couples', 'Neighborhood experience seekers']
        },
        {
          'type': 'Business Hotel',
          'description': 'Efficient, compact rooms with the essentials',
          'priceRange': '\$\$',
          'bestFor': ['Solo travelers', 'Budget-conscious travelers', 'Short stays']
        },
        {
          'type': 'Capsule Hotel',
          'description': 'Ultra-compact sleeping pods with shared facilities',
          'priceRange': '\$',
          'bestFor': ['Budget travelers', 'Solo travelers', 'Unique experience seekers']
        },
        {
          'type': 'Ryokan',
          'description': 'Traditional Japanese inns with tatami floors and futon bedding',
          'priceRange': '\$\$-\$\$\$\$',
          'bestFor': ['Cultural experience seekers', 'Couples', 'Foodie travelers']
        }
      ]
    };
    
    return accommodations[destination] ?? 
      [{'type': 'Various options', 'description': 'Will be recommended based on your preferences'}];
  }
  
  /// Gets travel tips for a destination
  List<String> getTravelTips(String destination, String travelTime) {
    final Map<String, List<String>> tips = {
      'Bali, Indonesia': [
        'Always carry small Indonesian Rupiah notes for small purchases and tips',
        'Use ride-hailing apps like Grab or GoJek for reliable transportation',
        'Drink bottled water and avoid tap water and ice in smaller establishments',
        'Negotiate prices at markets - start at about 40% of the initial asking price',
        'Learn a few basic Indonesian phrases - locals appreciate the effort',
        'Respect temple etiquette by wearing a sarong and sash (often provided at entrance)',
        'Avoid drinking alcohol labeled "arak" from unofficial vendors due to safety concerns',
        'Apply for the Visa On Arrival if your stay is under 30 days',
        'Be respectful during religious ceremonies - ask permission before taking photos'
      ],
      'Swiss Alps, Switzerland': [
        'Purchase a Swiss Travel Pass if planning to use public transportation extensively',
        'Most shops are closed on Sundays - plan grocery shopping accordingly',
        'Tap water is excellent quality and safe to drink throughout Switzerland',
        'Learn basic phrases in the regional language (German, French, or Italian)',
        'Hiking paths are marked with yellow signs - follow the color coding system',
        'Make dinner reservations in advance, especially in smaller mountain villages',
        'Carry cash (Swiss Francs) for smaller establishments and mountain huts',
        'Purchase travel insurance that covers mountain rescue if planning outdoor activities',
        'Be aware of strict quiet hours in residential areas (typically 10pm-7am)'
      ],
      'Tokyo, Japan': [
        'Purchase a Suica or Pasmo card for convenient public transportation',
        'For trash disposal, follow sorting rules carefully - there are few public trash cans',
        'Public transportation stops operating around midnight - check last train times',
        'Look for "tax-free" shopping for tourists at major department stores',
        'Download translation apps as English signage may be limited in some areas',
        'Carry hand sanitizer as many restrooms may not have soap or hand dryers',
        'Convenience stores (konbini) are excellent for quick meals and essentials',
        'When dining out, look for plastic food displays or picture menus for easier ordering',
        'Bowing is customary - a slight bow of the head shows respect in most situations'
      ]
    };
    
    return tips[destination] ?? ['Travel tips will be provided upon destination selection'];
  }
  
  /// Augments a prompt with real destination data to make AI responses more accurate
  /// Returns the enhanced prompt with location-specific data included
  Future<String> augmentPromptWithData(String basePrompt, String location) async {
    try {
      // Get destination data using existing method
      final data = await getDestinationData(location);
      
      if (data != null && data.isNotEmpty) {
        // Enhance the base prompt with real data
        basePrompt = "$basePrompt\n\nIncorporate these facts about $location:\n";
        
        if (data.containsKey('description')) {
          basePrompt += "- ${data['description']}\n";
        }
        
        if (data.containsKey('highlights') && data['highlights'] is List) {
          final highlights = data['highlights'] as List;
          for (int i = 0; i < highlights.length && i < 3; i++) {
            basePrompt += "- ${highlights[i]}\n";
          }
        }
        
        if (data.containsKey('culturalNotes') && data['culturalNotes'] is List) {
          final culturalNotes = data['culturalNotes'] as List;
          if (culturalNotes.isNotEmpty) {
            basePrompt += "- Cultural note: ${culturalNotes[0]}\n";
          }
        }
      }
      
      return basePrompt;
    } catch (e) {
      debugPrint('Error augmenting prompt with data: $e');
      // Return the original prompt if there's an error
      return basePrompt;
    }
  }
  
  /// Gets detailed data for a specific destination
  /// This method combines various data points from other methods
  Future<Map<String, dynamic>> getDestinationData(String location) async {
    // Combine data from existing methods
    final details = getDestinationDetails(location);
    final data = <String, dynamic>{...details};
    
    // Add best times to travel
    final travelTimes = getBestTimesToTravel(location);
    if (travelTimes.isNotEmpty) {
      data['bestTimes'] = travelTimes['bestTimes'];
    }
    
    // Add travel tips
    final tips = getTravelTips(location, '');
    if (tips.isNotEmpty) {
      data['tips'] = tips;
    }
    
    return data;
  }
}