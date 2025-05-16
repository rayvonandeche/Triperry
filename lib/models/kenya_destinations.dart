// Detailed data for Kenyan travel destinations
import 'package:flutter/material.dart';

enum TravelType {
  romantic,
  family,
  group,
  business,
  solo,
  adventure,
}

enum TravelSeason {
  drySeasonJanFeb,
  wetSeasonMarMay,
  dryCoolSeasonJunOct,
  shortRainsNovDec,
}

class KenyaDestination {
  final String name;
  final String region;
  final String description;
  final double latitude;
  final double longitude;
  final List<String> imageUrls;
  final List<String> activities;
  final List<TravelType> bestFor;
  final Map<TravelSeason, int> seasonRating; // 1-10 rating for each season
  final String priceRange; // $ to $$$$$
  final Map<String, List<String>> nearbyAttractions;
  final List<String> travelTips;
  
  const KenyaDestination({
    required this.name,
    required this.region,
    required this.description,
    required this.latitude, 
    required this.longitude,
    required this.imageUrls,
    required this.activities,
    required this.bestFor,
    required this.seasonRating,
    required this.priceRange,
    required this.nearbyAttractions,
    required this.travelTips,
  });
  
  bool isGoodForSeason(TravelSeason season) {
    return (seasonRating[season] ?? 0) > 6;
  }
  
  bool isSuitableFor(TravelType type) {
    return bestFor.contains(type);
  }
}

// Comprehensive Kenya destinations dataset
final List<KenyaDestination> kenyaDestinations = [
  KenyaDestination(
    name: 'Maasai Mara National Reserve',
    region: 'Rift Valley',
    description: 'World-renowned for the Great Migration, when millions of wildebeest, zebra, and Thomson\'s gazelle travel to and from the Serengeti in Tanzania. Home to the "Big Five" and many other wildlife species.',
    latitude: -1.5064, 
    longitude: 35.1482,
    imageUrls: [
      'assets/images/destinations/masai_mara1.jpg',
      'assets/images/destinations/masai_mara2.jpg',
      'assets/images/destinations/masai_mara3.jpg',
    ],
    activities: [
      'Wildlife Safari',
      'Hot Air Balloon Rides',
      'Cultural Visits to Maasai Villages',
      'Bird Watching',
      'Photography Tours',
    ],
    bestFor: [
      TravelType.family,
      TravelType.group,
      TravelType.romantic,
      TravelType.adventure,
    ],
    seasonRating: {
      TravelSeason.drySeasonJanFeb: 8,
      TravelSeason.wetSeasonMarMay: 5,
      TravelSeason.dryCoolSeasonJunOct: 10, // Best for Great Migration
      TravelSeason.shortRainsNovDec: 6,
    },
    priceRange: '\$\$\$\$',
    nearbyAttractions: {
      'Nature': ['Mara River', 'Talek River', 'Oloololo Escarpment'],
      'Wildlife': ['Lion prides', 'Elephant herds', 'Hippo pools'],
      'Cultural': ['Maasai Villages', 'Local Markets'],
    },
    travelTips: [
      'Visit between July and October to witness the Great Migration',
      'Book accommodations well in advance during peak season',
      'Bring warm clothes for early morning game drives',
      'Consider a hot air balloon safari for a unique perspective',
    ],
  ),
  
  KenyaDestination(
    name: 'Diani Beach',
    region: 'Coast',
    description: 'A stunning white sand beach on the Indian Ocean, featuring crystal-clear waters, coral reefs, and swaying palm trees. Perfect for relaxation and water activities.',
    latitude: -4.2765, 
    longitude: 39.5942,
    imageUrls: [
      'assets/images/destinations/diani1.jpg',
      'assets/images/destinations/diani2.jpg',
      'assets/images/destinations/diani3.jpg',
    ],
    activities: [
      'Snorkeling and Diving',
      'Kite Surfing',
      'Deep-Sea Fishing',
      'Dolphin Watching',
      'Beach Relaxation',
      'Sunset Dhow Cruises',
    ],
    bestFor: [
      TravelType.romantic,
      TravelType.family,
      TravelType.group,
      TravelType.solo,
    ],
    seasonRating: {
      TravelSeason.drySeasonJanFeb: 10,
      TravelSeason.wetSeasonMarMay: 6,
      TravelSeason.dryCoolSeasonJunOct: 8,
      TravelSeason.shortRainsNovDec: 7,
    },
    priceRange: '\$\$\$ - \$\$\$\$',
    nearbyAttractions: {
      'Nature': ['Shimba Hills National Reserve', 'Kaya Kinondo Sacred Forest'],
      'Activities': ['Wasini Island', 'Kisite-Mpunguti Marine Park'],
      'Cultural': ['Diani Beach Art Gallery', 'Local Markets'],
    },
    travelTips: [
      'December to March offers the best beach weather',
      'Bring reef-safe sunscreen for water activities',
      'Be cautious of beach boys offering services',
      'Consider day trips to nearby marine parks',
    ],
  ),
  
  KenyaDestination(
    name: 'Mount Kenya',
    region: 'Central Kenya',
    description: 'Africa\'s second-highest mountain, offering breathtaking scenery, diverse wildlife, and challenging hiking routes for adventurers of different skill levels.',
    latitude: -0.1521, 
    longitude: 37.3084,
    imageUrls: [
      'assets/images/destinations/mtkenya1.jpg',
      'assets/images/destinations/mtkenya2.jpg',
      'assets/images/destinations/mtkenya3.jpg',
    ],
    activities: [
      'Mountain Climbing',
      'Hiking',
      'Wildlife Viewing',
      'Bird Watching',
      'Photography',
      'Camping',
    ],
    bestFor: [
      TravelType.adventure,
      TravelType.solo,
      TravelType.group,
    ],
    seasonRating: {
      TravelSeason.drySeasonJanFeb: 9,
      TravelSeason.wetSeasonMarMay: 3,
      TravelSeason.dryCoolSeasonJunOct: 7,
      TravelSeason.shortRainsNovDec: 4,
    },
    priceRange: '\$\$\$ - \$\$\$\$',
    nearbyAttractions: {
      'Nature': ['Mount Kenya National Park', 'Lake Alice', 'Lake Michaelson'],
      'Wildlife': ['Elephants', 'Buffalo', 'Monkeys', 'Unique Alpine Species'],
      'Cultural': ['Local Mountain Communities', 'Kikuyu Cultural Sites'],
    },
    travelTips: [
      'January and February are best for summit attempts',
      'Allow several days for acclimatization before attempting the peak',
      'Hire a qualified guide for safety',
      'Bring layers as temperatures change dramatically with elevation',
    ],
  ),
  
  KenyaDestination(
    name: 'Nairobi',
    region: 'Central Kenya',
    description: 'Kenya\'s vibrant capital city, offering a unique blend of urban experiences, wildlife, and cultural attractions. The only capital city with a national park within its boundaries.',
    latitude: -1.2921, 
    longitude: 36.8219,
    imageUrls: [
      'assets/images/destinations/nairobi1.jpg',
      'assets/images/destinations/nairobi2.jpg',
      'assets/images/destinations/nairobi3.jpg',
    ],
    activities: [
      'Nairobi National Park Safaris',
      'Giraffe Centre Visits',
      'David Sheldrick Elephant Orphanage',
      'Museum Tours',
      'Shopping at Markets',
      'Fine Dining',
      'Nightlife',
    ],
    bestFor: [
      TravelType.business,
      TravelType.family,
      TravelType.solo,
    ],
    seasonRating: {
      TravelSeason.drySeasonJanFeb: 8,
      TravelSeason.wetSeasonMarMay: 6,
      TravelSeason.dryCoolSeasonJunOct: 9,
      TravelSeason.shortRainsNovDec: 7,
    },
    priceRange: '\$\$ - \$\$\$\$\$',
    nearbyAttractions: {
      'Wildlife': ['Nairobi National Park', 'Giraffe Centre', 'David Sheldrick Wildlife Trust'],
      'Cultural': ['National Museum', 'Karen Blixen Museum', 'Maasai Market'],
      'Urban': ['Westlands', 'Village Market', 'KICC Building'],
    },
    travelTips: [
      'Use trusted transportation like Uber or official taxis',
      'Visit the elephant orphanage during feeding times',
      'Explore the national park early morning for best wildlife viewing',
      'Be security conscious especially at night',
    ],
  ),
  
  KenyaDestination(
    name: 'Amboseli National Park',
    region: 'Southern Kenya',
    description: 'Famous for its large elephant herds and stunning views of Mount Kilimanjaro. The park offers some of the best wildlife viewing experiences in Kenya.',
    latitude: -2.6527, 
    longitude: 37.2606,
    imageUrls: [
      'assets/images/destinations/amboseli1.jpg',
      'assets/images/destinations/amboseli2.jpg',
      'assets/images/destinations/amboseli3.jpg',
    ],
    activities: [
      'Elephant Watching',
      'Wildlife Photography',
      'Bird Watching',
      'Game Drives',
      'Cultural Tours to Maasai Villages',
    ],
    bestFor: [
      TravelType.family,
      TravelType.romantic,
      TravelType.adventure,
      TravelType.group,
    ],
    seasonRating: {
      TravelSeason.drySeasonJanFeb: 10,
      TravelSeason.wetSeasonMarMay: 6,
      TravelSeason.dryCoolSeasonJunOct: 9,
      TravelSeason.shortRainsNovDec: 7,
    },
    priceRange: '\$\$\$ - \$\$\$\$',
    nearbyAttractions: {
      'Nature': ['Mount Kilimanjaro Views', 'Observation Hill', 'Enkongo Narok Swamp'],
      'Wildlife': ['Elephant Herds', 'Hippo Pools', 'Over 400 Bird Species'],
      'Cultural': ['Maasai Villages', 'Cultural Demonstrations'],
    },
    travelTips: [
      'Visit during dry seasons for clearer views of Kilimanjaro',
      'Early mornings offer the best lighting for photography',
      'Bring binoculars for bird watching',
      'Respect Maasai customs when visiting villages',
    ],
  ),
  
  KenyaDestination(
    name: 'Lamu Island',
    region: 'North Coast',
    description: 'A UNESCO World Heritage site featuring one of the oldest and best-preserved Swahili settlements. Known for its narrow streets, traditional architecture, and relaxed atmosphere.',
    latitude: -2.2717, 
    longitude: 40.9019,
    imageUrls: [
      'assets/images/destinations/lamu1.jpg',
      'assets/images/destinations/lamu2.jpg',
      'assets/images/destinations/lamu3.jpg',
    ],
    activities: [
      'Historic Old Town Tours',
      'Dhow Sailing',
      'Beach Relaxation',
      'Lamu Cultural Festival',
      'Local Cuisine Tasting',
      'Snorkeling',
    ],
    bestFor: [
      TravelType.romantic,
      TravelType.solo,
      TravelType.adventure,
    ],
    seasonRating: {
      TravelSeason.drySeasonJanFeb: 9,
      TravelSeason.wetSeasonMarMay: 5,
      TravelSeason.dryCoolSeasonJunOct: 8,
      TravelSeason.shortRainsNovDec: 6,
    },
    priceRange: '\$\$ - \$\$\$\$',
    nearbyAttractions: {
      'Cultural': ['Lamu Fort', 'Swahili House Museum', 'Donkey Sanctuary'],
      'Nature': ['Shela Beach', 'Manda Island', 'Kipungani'],
      'Activities': ['Sailing Dhows', 'Seafood Markets'],
    },
    travelTips: [
      'There are no cars on the island - transportation is by foot, donkey, or boat',
      'Dress modestly to respect the predominantly Muslim culture',
      'Book accommodations well in advance during the Lamu Cultural Festival',
      'Check travel advisories before visiting',
    ],
  ),
];

// Specialized recommendation functions
List<KenyaDestination> getDestinationsForTravelType(TravelType type) {
  return kenyaDestinations.where((dest) => dest.bestFor.contains(type)).toList();
}

List<KenyaDestination> getDestinationsForSeason(TravelSeason season) {
  return kenyaDestinations.where((dest) => dest.seasonRating[season]! > 7).toList();
}

List<KenyaDestination> getDestinationsForActivity(String activity) {
  return kenyaDestinations.where((dest) => 
    dest.activities.any((act) => act.toLowerCase().contains(activity.toLowerCase()))
  ).toList();
}

List<KenyaDestination> getDestinationsForBudget(int budgetLevel) {
  // Budget level from 1 (lowest) to 5 (highest)
  return kenyaDestinations.where((dest) => 
    dest.priceRange.length >= budgetLevel && dest.priceRange.length <= budgetLevel + 2
  ).toList();
}

List<KenyaDestination> getRecommendedItinerary({
  required TravelType type, 
  required TravelSeason season, 
  required int budgetLevel,
  required int numberOfDays,
}) {
  // Get suitable destinations based on type, season and budget
  final suitable = kenyaDestinations.where((dest) => 
    dest.bestFor.contains(type) &&
    (dest.seasonRating[season] ?? 0) > 6 &&
    dest.priceRange.length >= budgetLevel && dest.priceRange.length <= budgetLevel + 2
  ).toList();
  
  // Sort by season rating
  suitable.sort((a, b) => (b.seasonRating[season] ?? 0) - (a.seasonRating[season] ?? 0));
  
  // Select based on number of days (rough calculation)
  final int destinationsToInclude = (numberOfDays / 3).ceil(); // Assume 2-3 days per destination
  return suitable.take(destinationsToInclude).toList();
}
