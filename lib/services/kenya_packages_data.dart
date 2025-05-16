import 'package:flutter/material.dart';

/// This file contains the data for travel packages in Kenya
/// The data is structured to be used in the packages pages
class KenyaPackagesData {
  // List of all package categories
  static List<String> packageCategories = [
    'All', 
    'Safari', 
    'Beach', 
    'Adventure',
    'Cultural', 
    'Family', 
    'Romantic'
  ];

  // Packages by category
  static List<Map<String, dynamic>> getAllPackages() {
    return [
      // Safari Packages
      {
        'title': '7-Day Kenya Safari Experience',
        'description': 'Visit Maasai Mara, Amboseli, and Lake Nakuru',
        'image': 'assets/images/kenya safari.jpeg',
        'price': 'KSh 120,000',
        'priceValue': 120000,
        'rating': 4.9,
        'reviews': 156,
        'location': 'Multiple Locations',
        'duration': '7 days',
        'category': 'Safari',
        'featured': true,
        'coordinates': {'lat': -1.4833, 'lng': 35.0833},
        'tags': ['Wildlife', 'Big Five', 'Photography'],
        'amenities': ['Accommodation', 'Transport', 'Guide', 'Meals'],
        'description_full': 'Experience the best of Kenya\'s wildlife with this comprehensive 7-day safari package. Begin your adventure in the world-famous Maasai Mara National Reserve, where you\'ll witness the spectacular wildlife including the Big Five. Continue to Amboseli National Park for breathtaking views of Mt. Kilimanjaro and large elephant herds. End your journey at Lake Nakuru, famous for its flamingos and rhino sanctuary. This all-inclusive package features comfortable lodging, professional guides, and all meals.',
        'itinerary': [
          {
            'day': 'Day 1',
            'title': 'Nairobi Arrival & Briefing',
            'details': 'Airport pickup, check-in at hotel, safari briefing, overnight in Nairobi'
          },
          {
            'day': 'Day 2-3',
            'title': 'Maasai Mara Adventure',
            'details': 'Travel to Maasai Mara, afternoon game drive, full day game viewing, optional visit to Maasai village'
          },
          {
            'day': 'Day 4-5',
            'title': 'Amboseli National Park',
            'details': 'Travel to Amboseli, game drives with Mt. Kilimanjaro backdrop, elephant herds viewing'
          },
          {
            'day': 'Day 6-7',
            'title': 'Lake Nakuru & Return',
            'details': 'Travel to Lake Nakuru, flamingo viewing, rhino sanctuary visit, return to Nairobi for departure'
          },
        ]
      },
      {
        'title': '5-Day Big Five Safari',
        'description': 'Focused wildlife viewing in premium reserves',
        'image': 'assets/images/lion.jpeg',
        'price': 'KSh 95,000',
        'priceValue': 95000,
        'rating': 4.8,
        'reviews': 112,
        'location': 'Maasai Mara & Tsavo',
        'duration': '5 days',
        'category': 'Safari',
        'coordinates': {'lat': -2.6516, 'lng': 37.2606},
        'tags': ['Big Five', 'Luxury', 'Wildlife'],
        'amenities': ['4-star Lodging', 'Private Transport', 'Expert Guide', 'All Meals'],
        'description_full': 'This focused 5-day safari is designed for wildlife enthusiasts who want maximum opportunities to spot the Big Five (lion, leopard, elephant, buffalo, and rhino). Split your time between the game-rich plains of Maasai Mara and the vast wilderness of Tsavo East National Park. Enjoy comfortable accommodations, professional guides with extensive knowledge of animal behavior and habitats, and custom-designed safari vehicles that ensure the best possible viewing experience.',
        'itinerary': [
          {
            'day': 'Day 1',
            'title': 'Nairobi to Maasai Mara',
            'details': 'Morning departure, travel to Maasai Mara, afternoon game drive'
          },
          {
            'day': 'Day 2-3',
            'title': 'Maasai Mara Exploration',
            'details': 'Full days of game drives in different sectors of the reserve, dawn and dusk drives for optimal wildlife viewing'
          },
          {
            'day': 'Day 4',
            'title': 'Tsavo East National Park',
            'details': 'Flight to Tsavo, afternoon game drive focusing on elephant herds and predators'
          },
          {
            'day': 'Day 5',
            'title': 'Final Safari & Return',
            'details': 'Morning game drive, return to Nairobi by afternoon for departure'
          },
        ]
      },

      // Beach Packages
      {
        'title': 'Beach and Wildlife Combo',
        'description': 'Safari adventure followed by coastal relaxation',
        'image': 'assets/images/tropical beach.jpeg',
        'price': 'KSh 150,000',
        'priceValue': 150000,
        'rating': 4.7,
        'reviews': 98,
        'location': 'Maasai Mara & Diani Beach',
        'duration': '10 days',
        'category': 'Beach',
        'featured': true,
        'coordinates': {'lat': -4.3077, 'lng': 39.5984},
        'tags': ['Wildlife', 'Beach', 'Relaxation'],
        'amenities': ['Accommodation', 'Transport', 'Guide', 'Some Meals'],
        'description_full': 'Combine the excitement of wildlife viewing with the relaxation of Kenya\'s stunning beaches in this perfect 10-day package. Start with an unforgettable safari experience in the Maasai Mara, where you\'ll witness amazing wildlife in their natural habitat. Then fly to the coast for 6 days of pure relaxation on the pristine white sands of Diani Beach. Stay in a beachfront resort with options for water sports, snorkeling, and cultural excursions or simply unwind by the pool with ocean views.',
        'itinerary': [
          {
            'day': 'Day 1-4',
            'title': 'Maasai Mara Safari',
            'details': 'Transfer to Maasai Mara, three days of game drives and wildlife viewing'
          },
          {
            'day': 'Day 5-10',
            'title': 'Diani Beach Relaxation',
            'details': 'Flight to Ukunda, transfer to beach resort, free days for relaxation and optional activities'
          }
        ]
      },
      {
        'title': 'Luxurious Lamu Retreat',
        'description': 'Exclusive island getaway with private villa',
        'image': 'assets/images/lamu old town.png',
        'price': 'KSh 185,000',
        'priceValue': 185000,
        'rating': 4.9,
        'reviews': 45,
        'location': 'Lamu Island',
        'duration': '7 days',
        'category': 'Beach',
        'coordinates': {'lat': -2.2697, 'lng': 40.9025},
        'tags': ['Luxury', 'Private', 'Island'],
        'amenities': ['Private Villa', 'Chef', 'Boat Tours', 'All Meals'],
        'description_full': 'Escape to the exclusive Lamu Island for a week of luxury and tranquility. Stay in a private beachfront villa with dedicated staff including a personal chef preparing fresh seafood and local delicacies daily. Explore the UNESCO World Heritage site of Lamu Old Town, sail on traditional dhow boats at sunset, and enjoy the pristine beaches without the crowds. This package offers the perfect balance of cultural immersion and peaceful seclusion.',
        'itinerary': [
          {
            'day': 'Day 1',
            'title': 'Arrival in Lamu',
            'details': 'Flight to Lamu, boat transfer to private villa, welcome dinner'
          },
          {
            'day': 'Day 2-6',
            'title': 'Island Experience',
            'details': 'Flexible days with options for town tours, dhow cruises, fishing trips, beach relaxation'
          },
          {
            'day': 'Day 7',
            'title': 'Departure',
            'details': 'Leisurely morning, boat transfer to airport, departure flight'
          }
        ]
      },

      // Family Packages
      {
        'title': 'Kenya Family Adventure',
        'description': 'Kid-friendly activities across Kenya',
        'image': 'assets/images/girraffe.png',
        'price': 'KSh 240,000',
        'priceValue': 240000,
        'rating': 4.8,
        'reviews': 74,
        'location': 'Multiple Locations',
        'duration': '8 days',
        'category': 'Family',
        'coordinates': {'lat': -1.2921, 'lng': 36.8219},
        'tags': ['Family', 'Educational', 'Wildlife'],
        'amenities': ['Family Accommodation', 'Kid-friendly Meals', 'Private Transport', 'Activities'],
        'description_full': 'Create lasting memories with this specially designed family adventure across Kenya. This package features accommodations and activities suitable for all ages, with flexible itineraries that can be adjusted based on your children\'s ages and interests. Visit the Giraffe Centre in Nairobi where kids can feed these gentle giants, enjoy child-focused game drives with specially trained guides who make wildlife spotting fun and educational, and participate in cultural activities where children can interact with local kids.',
        'itinerary': [
          {
            'day': 'Day 1-2',
            'title': 'Nairobi Activities',
            'details': 'Giraffe Centre, Elephant Orphanage, Bomas of Kenya cultural center'
          },
          {
            'day': 'Day 3-5',
            'title': 'Safari Adventure',
            'details': 'Family-friendly lodge in Ol Pejeta Conservancy, special kid-focused game drives'
          },
          {
            'day': 'Day 6-8',
            'title': 'Beach Time',
            'details': 'Beach resort with children\'s programs, family water activities, return to Nairobi'
          }
        ]
      },
      {
        'title': 'Educational Wildlife Camp',
        'description': 'Learning and adventure for the whole family',
        'image': 'assets/images/buffalo.png',
        'price': 'KSh 165,000',
        'priceValue': 165000,
        'rating': 4.7,
        'reviews': 62,
        'location': 'Laikipia Plateau',
        'duration': '6 days',
        'category': 'Family',
        'featured': true,
        'coordinates': {'lat': 0.6167, 'lng': 36.7333},
        'tags': ['Educational', 'Wildlife', 'Conservation'],
        'amenities': ['Family Tents', 'All Meals', 'Activities', 'Conservation Programs'],
        'description_full': 'This family-oriented wildlife camp combines adventure with education in Kenya\'s pristine Laikipia region. Stay in comfortable family tents at a conservation-focused camp where children learn about wildlife protection through fun, hands-on activities. Participate in junior ranger programs, track animals with experienced guides, and meet local communities to learn about traditional ways of living alongside wildlife. A perfect blend of education, conservation awareness, and family bonding in nature.',
        'itinerary': [
          {
            'day': 'Day 1',
            'title': 'Welcome to Camp',
            'details': 'Arrival, camp orientation, evening wildlife spotting walk'
          },
          {
            'day': 'Day 2-5',
            'title': 'Wildlife & Learning',
            'details': 'Junior ranger activities, animal tracking, conservation projects, game drives'
          },
          {
            'day': 'Day 6',
            'title': 'Farewell',
            'details': 'Final morning activity, junior ranger graduation ceremony, departure'
          }
        ]
      },

      // Cultural Packages
      {
        'title': 'Cultural Heritage Tour',
        'description': 'Explore Kenya\'s rich cultural diversity',
        'image': 'assets/images/masaai village.png',
        'price': 'KSh 95,000',
        'priceValue': 95000,
        'rating': 4.6,
        'reviews': 87,
        'location': 'Multiple Locations',
        'duration': '6 days',
        'category': 'Cultural',
        'coordinates': {'lat': -3.0674, 'lng': 37.3556},
        'tags': ['Culture', 'History', 'Community'],
        'amenities': ['Accommodation', 'Transport', 'Cultural Guide', 'Most Meals'],
        'description_full': 'Immerse yourself in the rich cultural heritage of Kenya with this comprehensive tour showcasing the country\'s diverse ethnic communities. Visit authentic Maasai villages where you can participate in traditional dances and learn about their nomadic lifestyle. Explore the Swahili culture along the coast, with its unique blend of African, Arab, and European influences. Experience local cuisine with cooking classes, witness traditional crafts being made, and even spend a night in a community-based accommodation for a genuine cultural exchange.',
        'itinerary': [
          {
            'day': 'Day 1-2',
            'title': 'Maasai Culture',
            'details': 'Visit to Maasai community, cultural activities, overnight in traditional accommodations'
          },
          {
            'day': 'Day 3-4',
            'title': 'Lake Region Cultures',
            'details': 'Explore Luo and Kisii communities, traditional music and craft demonstrations'
          },
          {
            'day': 'Day 5-6',
            'title': 'Coastal Heritage',
            'details': 'Swahili culture exploration in Mombasa Old Town, traditional cooking class, departure'
          }
        ]
      },

      // Adventure Packages
      {
        'title': 'Mt. Kenya and Savannah',
        'description': 'Hiking and wildlife in one amazing package',
        'image': 'assets/images/mount kenya.png',
        'price': 'KSh 135,000',
        'priceValue': 135000,
        'rating': 4.8,
        'reviews': 53,
        'location': 'Mt. Kenya & Laikipia',
        'duration': '9 days',
        'category': 'Adventure',
        'coordinates': {'lat': -0.1517, 'lng': 37.3081},
        'tags': ['Hiking', 'Wildlife', 'Adventure'],
        'amenities': ['Accommodation', 'Equipment', 'Guide', 'Meals'],
        'description_full': 'Combine the thrill of summiting Africa\'s second-highest peak with exhilarating wildlife encounters in this perfect adventure package. Start with a guided climb of Mt. Kenya, taking the scenic Sirimon route with its diverse vegetation zones and breathtaking views. After your mountain adventure, recover and celebrate with a luxurious safari in the wildlife-rich Laikipia region, where you\'ll see a variety of animals in a pristine and less-crowded environment. This package is ideal for active travelers who want to experience both Kenya\'s highland and savannah ecosystems.',
        'itinerary': [
          {
            'day': 'Day 1',
            'title': 'Preparation Day',
            'details': 'Arrival in Nairobi, equipment check, briefing with mountain guide'
          },
          {
            'day': 'Day 2-5',
            'title': 'Mt. Kenya Trek',
            'details': 'Transfer to mountain base, 4-day trek via Sirimon route, camping on mountain'
          },
          {
            'day': 'Day 6-9',
            'title': 'Wildlife Recovery',
            'details': 'Transfer to Laikipia conservancy, safari game drives, luxury lodge accommodation'
          }
        ]
      },

      // Romantic Packages
      {
        'title': 'Kenya Honeymoon Escape',
        'description': 'Romantic safari and beach getaway for couples',
        'image': 'assets/images/tropical beach.jpeg',
        'price': 'KSh 270,000',
        'priceValue': 270000,
        'rating': 4.9,
        'reviews': 42,
        'location': 'Masai Mara & Coast',
        'duration': '10 days',
        'category': 'Romantic',
        'featured': true,
        'coordinates': {'lat': -4.0541, 'lng': 39.6682},
        'tags': ['Honeymoon', 'Luxury', 'Private'],
        'amenities': ['Luxury Accommodation', 'Private Transport', 'Special Dinners', 'Couple Activities'],
        'description_full': 'Begin your life together with this unforgettable romantic journey through Kenya\'s most breathtaking landscapes. Start with a luxurious safari in a private conservancy adjacent to the Maasai Mara, staying in an intimate tented camp with personal butler service and private game drives. Then fly to a secluded beach resort on the Kenyan coast for days of relaxation and romance. Enjoy couples spa treatments, private beachfront dinners under the stars, and optional water activities. Every detail is designed with privacy and romance in mind.',
        'itinerary': [
          {
            'day': 'Day 1-4',
            'title': 'Romantic Safari',
            'details': 'Private conservancy stay, exclusive game drives, sundowner experiences, bush dinner'
          },
          {
            'day': 'Day 5-10',
            'title': 'Beach Romance',
            'details': 'Luxury beach villa, couples treatments, private dining experiences, optional excursions'
          }
        ]
      }
    ];
  }
  
  // Get featured packages
  static List<Map<String, dynamic>> getFeaturedPackages() {
    return getAllPackages().where((package) => package['featured'] == true).toList();
  }
  
  // Get packages by category
  static List<Map<String, dynamic>> getPackagesByCategory(String category) {
    if (category == 'All') {
      return getAllPackages();
    } else {
      return getAllPackages().where((package) => package['category'] == category).toList();
    }
  }
  
  // Helper method to filter packages by price range
  static List<Map<String, dynamic>> filterPackagesByPriceRange(List<Map<String, dynamic>> packages, RangeValues priceRange) {
    return packages.where((package) => 
      package['priceValue'] >= priceRange.start && 
      package['priceValue'] <= priceRange.end
    ).toList();
  }
  
  // Helper method to filter packages by minimum rating
  static List<Map<String, dynamic>> filterPackagesByRating(List<Map<String, dynamic>> packages, double minRating) {
    return packages.where((package) => 
      package['rating'] >= minRating
    ).toList();
  }
  
  // Helper method to search packages by name
  static List<Map<String, dynamic>> searchPackages(String query) {
    if (query.isEmpty) {
      return getAllPackages();
    }
    return getAllPackages().where((package) => 
      package['title'].toString().toLowerCase().contains(query.toLowerCase()) ||
      package['description'].toString().toLowerCase().contains(query.toLowerCase()) ||
      package['location'].toString().toLowerCase().contains(query.toLowerCase()) ||
      package['category'].toString().toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
