import 'package:flutter/material.dart';

/// This file contains the data for activities in Kenya
/// The data is structured to be used in the activities pages
class KenyaActivitiesData {
  // List of all activity categories
  static List<String> activityCategories = [
    'All', 
    'Safari', 
    'Coastal', 
    'Adventure', 
    'Cultural', 
    'Urban', 
    'Nature'
  ];

  // Activities by category
  static List<Map<String, dynamic>> getAllActivities() {
    return [
      // Safari Activities
      {
        'title': 'Maasai Mara Safari',
        'description': 'Experience the Great Migration',
        'image': 'assets/images/buffalo.png',
        'price': 'KSh 15,000/person',
        'priceValue': 15000,
        'rating': 4.9,
        'reviews': 324,
        'location': 'Maasai Mara Reserve',
        'duration': '3-6 hours',
        'category': 'Safari',
        'featured': true,
        'coordinates': {'lat': -1.4833, 'lng': 35.0833},
        'tags': ['Wildlife', 'Photography', 'Big Five'],
        'amenities': ['Transport', 'Guide', 'Lunch Box', 'Binoculars'],
        'description_full': 'Embark on an unforgettable safari adventure in the world-famous Maasai Mara National Reserve. Witness the spectacular Great Migration, where millions of wildebeest, zebras, and other herbivores cross the Mara River in search of greener pastures. Spot the Big Five (lion, leopard, elephant, buffalo, and rhino) and other incredible wildlife in their natural habitat. Our experienced guides will ensure you have the best possible game viewing experience while sharing their knowledge about the ecosystem and animal behavior.',
      },
      {
        'title': 'Amboseli Elephant Tour',
        'description': 'Meet the gentle giants with Mt. Kilimanjaro backdrop',
        'image': 'assets/images/elephant.png',
        'price': 'KSh 12,000/person',
        'priceValue': 12000,
        'rating': 4.8,
        'reviews': 278,
        'location': 'Amboseli National Park',
        'duration': '4-5 hours',
        'category': 'Safari',
        'coordinates': {'lat': -2.6516, 'lng': 37.2606},
        'tags': ['Elephants', 'Mountain View', 'Photography'],
        'amenities': ['Transport', 'Guide', 'Water', 'Lunch'],
        'description_full': 'Visit Amboseli National Park, known as one of the best places in Africa to get close to free-ranging elephants. Witness these majestic creatures against the backdrop of Africa\'s highest mountain, Mount Kilimanjaro. The park is also home to over 400 species of birds, including water birds, pelicans, kingfishers, and 47 raptor species. Our expert guides will help you spot wildlife and share fascinating facts about the local ecosystem.',
      },

      // Coastal Activities
      {
        'title': 'Diani Beach Snorkeling',
        'description': 'Explore vibrant coral reefs and marine life',
        'image': 'assets/images/diani beach.png',
        'price': 'KSh 5,000/person',
        'priceValue': 5000,
        'rating': 4.7,
        'reviews': 189,
        'location': 'Diani Beach, South Coast',
        'duration': '2-3 hours',
        'category': 'Coastal',
        'featured': true,
        'coordinates': {'lat': -4.3077, 'lng': 39.5984},
        'tags': ['Snorkeling', 'Marine Life', 'Beach'],
        'amenities': ['Equipment', 'Instructor', 'Refreshments'],
        'description_full': 'Discover the underwater wonders of Diani Beach with a guided snorkeling excursion. The crystal-clear waters of this white sand paradise are home to colorful coral reefs teeming with tropical fish, sea turtles, and other fascinating marine creatures. No experience necessary - our professional instructors will provide all equipment and ensure your safety while helping you spot the most interesting sea life. Perfect for families and beginners!',
      },
      {
        'title': 'Lamu Island Dhow Cruise',
        'description': 'Sail on traditional wooden boats around historic island',
        'image': 'assets/images/lamu old town.png',
        'price': 'KSh 4,500/person',
        'priceValue': 4500,
        'rating': 4.6,
        'reviews': 157,
        'location': 'Lamu Island',
        'duration': '4 hours',
        'category': 'Coastal',
        'coordinates': {'lat': -2.2697, 'lng': 40.9025},
        'tags': ['Cultural', 'Sunset', 'History'],
        'amenities': ['Refreshments', 'Local Guide', 'Swimming Stop'],
        'description_full': 'Experience the magic of Lamu Island aboard a traditional dhow boat. These handcrafted wooden vessels have been used for centuries along the East African coast. Sail around the UNESCO World Heritage site of Lamu Old Town as the sun sets over the Indian Ocean. Learn about the rich Swahili culture and history from your local guide, enjoy fresh tropical fruits, and have the option to stop for swimming. The perfect blend of relaxation, history, and natural beauty.',
      },

      // Adventure Activities
      {
        'title': 'Mt. Kenya Trekking',
        'description': 'Summit Africa\'s second highest peak',
        'image': 'assets/images/mount kenya.png',
        'price': 'KSh 25,000/person',
        'priceValue': 25000,
        'rating': 4.9,
        'reviews': 102,
        'location': 'Mt. Kenya National Park',
        'duration': '3-7 days',
        'category': 'Adventure',
        'coordinates': {'lat': -0.1522, 'lng': 37.3084},
        'tags': ['Hiking', 'Mountain', 'Camping'],
        'amenities': ['Equipment', 'Guides', 'Meals', 'Accommodation'],
        'description_full': 'Challenge yourself with a guided trek up Mount Kenya, Africa\'s second-highest peak. Choose from different routes suitable for various fitness levels and durations. Trek through diverse landscapes - from lush rainforest to alpine meadows and glaciers. Expert mountain guides will ensure your safety while sharing knowledge about the mountain\'s unique flora, fauna, and geology. Summit at Point Lenana (4,985m) for breathtaking panoramic views. This all-inclusive package provides camping equipment, meals, and porter services.',
      },
      {
        'title': 'Hell\'s Gate Biking',
        'description': 'Cycle among wildlife and dramatic rock formations',
        'image': 'assets/images/hells gorges.png',
        'price': 'KSh 3,800/person',
        'priceValue': 3800,
        'rating': 4.7,
        'reviews': 215,
        'location': 'Hell\'s Gate National Park',
        'duration': '5-6 hours',
        'category': 'Adventure',
        'featured': true,
        'coordinates': {'lat': -0.9, 'lng': 36.4},
        'tags': ['Cycling', 'Gorges', 'Wildlife'],
        'amenities': ['Bikes', 'Guide', 'Water', 'Park Fees'],
        'description_full': 'Experience the unique thrill of cycling through Hell\'s Gate National Park - one of the few parks where you can explore on foot or bicycle among wildlife. Ride past grazing zebras, giraffes, and gazelles while surrounded by impressive volcanic rock formations. Visit the famous gorges that inspired scenes from The Lion King, and enjoy optional hot springs afterward. Our quality mountain bikes and knowledgeable guides ensure a safe, unforgettable adventure for riders of all levels.',
      },

      // Cultural Activities
      {
        'title': 'Maasai Village Visit',
        'description': 'Immerse in traditional Maasai culture and customs',
        'image': 'assets/images/masaai village.png',
        'price': 'KSh 2,500/person',
        'priceValue': 2500,
        'rating': 4.6,
        'reviews': 178,
        'location': 'Various locations near Maasai Mara',
        'duration': '2-3 hours',
        'category': 'Cultural',
        'coordinates': {'lat': -1.5, 'lng': 35.2},
        'tags': ['Indigenous', 'Culture', 'Traditional'],
        'amenities': ['Guide', 'Local Interaction'],
        'description_full': 'Gain insight into the fascinating culture of the Maasai people with an authentic village visit. You\'ll be welcomed with traditional songs and the famous jumping dance performed by warriors. Learn about Maasai customs, daily life, and their deep connection with nature and livestock. See how traditional houses are built, discover ancient crafting techniques, and have the opportunity to purchase handmade jewelry and crafts that support the local community. This respectful cultural exchange is guided by a local Maasai who ensures an authentic and educational experience.',
      },
      {
        'title': 'Nairobi Cultural Tour',
        'description': 'Explore museums, markets and cultural sites',
        'image': 'assets/images/karen blixen.jpeg',
        'price': 'KSh 4,000/person',
        'priceValue': 4000,
        'rating': 4.5,
        'reviews': 134,
        'location': 'Nairobi',
        'duration': '6-7 hours',
        'category': 'Cultural',
        'coordinates': {'lat': -1.2921, 'lng': 36.8219},
        'tags': ['Museum', 'Market', 'History'],
        'amenities': ['Transport', 'Guide', 'Entrance Fees'],
        'description_full': 'Discover Nairobi\'s rich cultural heritage on this comprehensive day tour. Visit the Karen Blixen Museum, former home of the "Out of Africa" author, and learn about colonial Kenya. Explore the National Museum with its impressive collection of artifacts, art and natural history exhibits. Browse handcrafted goods at Maasai Market, where you can practice your bargaining skills with local artisans. The tour includes visits to cultural centers showcasing Kenya\'s diverse ethnic groups and their traditional crafts, music and dance.',
      },

      // Urban Activities
      {
        'title': 'Nairobi Food Tour',
        'description': 'Taste authentic Kenyan cuisine across the city',
        'image': 'assets/images/food.jpeg',
        'price': 'KSh 3,500/person',
        'priceValue': 3500,
        'rating': 4.8,
        'reviews': 98,
        'location': 'Nairobi',
        'duration': '4 hours',
        'category': 'Urban',
        'coordinates': {'lat': -1.2864, 'lng': 36.8172},
        'tags': ['Food', 'Local Cuisine', 'Walking Tour'],
        'amenities': ['Food Tastings', 'Guide', 'Transport'],
        'description_full': 'Embark on a culinary adventure through Kenya\'s capital city. Sample a wide variety of traditional dishes like nyama choma (grilled meat), ugali, sukuma wiki, and mandazi. Visit both upscale restaurants and authentic local eateries where Nairobians actually eat. Learn about the cultural influences on Kenyan cuisine from your knowledgeable foodie guide. The tour includes at least 5 different food stops with generous portions - come hungry! Dietary restrictions can be accommodated with advance notice.',
      },
      {
        'title': 'Nairobi Railway Museum',
        'description': 'Discover Kenya\'s railway history',
        'image': 'assets/images/nairoboi railways.jpeg',
        'price': 'KSh 1,200/person',
        'priceValue': 1200,
        'rating': 4.3,
        'reviews': 75,
        'location': 'Nairobi',
        'duration': '2 hours',
        'category': 'Urban',
        'coordinates': {'lat': -1.2902, 'lng': 36.8259},
        'tags': ['History', 'Museum', 'Education'],
        'amenities': ['Guide', 'Exhibits'],
        'description_full': 'Step back in time at the Nairobi Railway Museum, where Kenya\'s fascinating railway history comes alive. Explore vintage locomotives, passenger cars, and see how the famous "Lunatic Express" connected the coast to Lake Victoria, shaping modern Kenya. The museum houses photographs, memorabilia, and equipment dating back to the early 1900s. Learn about the challenges of building the railway, including the infamous man-eating lions of Tsavo. A knowledgeable guide will share stories about this engineering marvel that changed East Africa forever.',
      },

      // Nature Activities
      {
        'title': 'Lake Nakuru Flamingo Viewing',
        'description': 'See thousands of pink flamingos at the lake',
        'image': 'assets/images/l naivasha with eaagle.png', // Using similar lake image
        'price': 'KSh 7,500/person',
        'priceValue': 7500,
        'rating': 4.7,
        'reviews': 163,
        'location': 'Lake Nakuru National Park',
        'duration': '5-6 hours',
        'category': 'Nature',
        'coordinates': {'lat': -0.3136, 'lng': 36.0800},
        'tags': ['Birdwatching', 'Wildlife', 'Photography'],
        'amenities': ['Transport', 'Guide', 'Park Fees', 'Lunch'],
        'description_full': 'Witness the incredible spectacle of thousands of pink flamingos lining the shores of Lake Nakuru. This alkaline lake is famous for attracting both lesser and greater flamingos, creating a stunning pink band along its edges. Beyond the flamingos, the national park is home to over 450 bird species as well as rhinos, giraffes, lions, and other wildlife. Your expert guide will help spot animals and explain the delicate ecology of this Rift Valley lake. Perfect for bird enthusiasts and photographers seeking unique wildlife encounters.',
      },
      {
        'title': 'Karura Forest Hike',
        'description': 'Explore urban forest with waterfalls and caves',
        'image': 'assets/images/karura waterfall.png',
        'price': 'KSh 1,800/person',
        'priceValue': 1800,
        'rating': 4.5,
        'reviews': 209,
        'location': 'Nairobi',
        'duration': '3-4 hours',
        'category': 'Nature',
        'featured': true,
        'coordinates': {'lat': -1.2438, 'lng': 36.8519},
        'tags': ['Hiking', 'Waterfall', 'Urban Nature'],
        'amenities': ['Guide', 'Entrance Fees'],
        'description_full': 'Discover a natural oasis in the heart of Nairobi at Karura Forest. Follow well-maintained trails through indigenous forest, visit a picturesque waterfall, explore historic caves once used by Mau Mau freedom fighters, and enjoy peaceful lily-covered ponds. This 1,000-hectare urban forest offers a refreshing escape from the city bustle with multiple trail options for different fitness levels. Spot monkeys, butterflies, and numerous bird species along the way. The tour includes a knowledgeable guide who will share the forest\'s ecological importance and fascinating history.',
      }
    ];
  }

  // Featured activities (highlighted on homepage)
  static List<Map<String, dynamic>> getFeaturedActivities() {
    return getAllActivities().where((activity) => activity['featured'] == true).toList();
  }

  // Get popular activities
  static List<Map<String, dynamic>> getPopularActivities() {
    return getAllActivities()
        .where((activity) => (activity['rating'] as double) >= 4.7)
        .take(6)
        .toList();
  }

  // Get recommended activities
  static List<Map<String, dynamic>> getRecommendedActivities() {
    final allActivities = getAllActivities();
    allActivities.sort((a, b) => (b['reviews'] as int).compareTo(a['reviews'] as int));
    return allActivities.take(5).toList();
  }

  // Get activities by category
  static List<Map<String, dynamic>> getActivitiesByCategory(String category) {
    if (category == 'All') {
      return getAllActivities();
    }
    return getAllActivities()
        .where((activity) => activity['category'] == category)
        .toList();
  }
}
