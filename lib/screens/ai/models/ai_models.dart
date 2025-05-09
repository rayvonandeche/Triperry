/// Represents the different stages of the travel planning conversation
enum TravelStage {
  welcome,
  interestSelected,
  destinationSelected,
  timeSelected,
  activitySelected,
  budgetSelected,
  complete,
}

/// Represents a message in the conversation history
class ConversationMessage {
  final bool isUser;
  final String text;
  final DateTime timestamp;
  final MessageType type;
  final Map<String, dynamic>? metadata;
  
  const ConversationMessage({
    required this.isUser,
    required this.text,
    required this.timestamp,
    this.type = MessageType.text,
    this.metadata,
  });
}

/// Types of messages that can be displayed
enum MessageType {
  text,
  image,
  video,
  map,
  itinerary,
  booking,
  suggestion,
}

/// Represents a travel destination option
class TravelOption {
  final String name;
  final String description;
  final String imageUrl;
  final List<String> activities;
  final double rating;
  final int reviewCount;
  final Map<String, dynamic>? details;
  
  const TravelOption({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.activities,
    this.rating = 4.5,
    this.reviewCount = 100,
    this.details,
  });
}

/// Represents a day in the travel itinerary
class ItineraryDay {
  final String title;
  final List<ItineraryActivity> activities;
  final String? imageUrl;
  final String? weather;
  final double? temperature;
  
  const ItineraryDay({
    required this.title,
    required this.activities,
    this.imageUrl,
    this.weather,
    this.temperature,
  });
}

/// Represents an activity in the itinerary
class ItineraryActivity {
  final String title;
  final String description;
  final String time;
  final String? location;
  final String? imageUrl;
  final double? price;
  final int? duration;
  
  const ItineraryActivity({
    required this.title,
    required this.description,
    required this.time,
    this.location,
    this.imageUrl,
    this.price,
    this.duration,
  });
}

/// Represents a budget range with currency conversion
class BudgetRange {
  final String label;
  final double min;
  final double max;
  final String currency;
  final Map<String, double>? exchangeRates;
  final CostBreakdown? costBreakdown;

  const BudgetRange({
    required this.label,
    required this.min,
    required this.max,
    required this.currency,
    this.exchangeRates,
    this.costBreakdown,
  });
}

/// Detailed breakdown of travel costs
class CostBreakdown {
  final double flights;
  final double accommodation;
  final double activities;
  final double food;
  final double transportation;
  final double miscellaneous;
  final String currency;
  final Map<String, double>? exchangeRates;

  const CostBreakdown({
    required this.flights,
    required this.accommodation,
    required this.activities,
    required this.food,
    required this.transportation,
    required this.miscellaneous,
    required this.currency,
    this.exchangeRates,
  });

  double get total => flights + accommodation + activities + food + transportation + miscellaneous;
}

/// Represents travel season information
class TravelSeason {
  final String name;
  final String description;
  final double averageTemperature;
  final double averageRainfall;
  final double crowdLevel;
  final double priceLevel;
  final List<String> pros;
  final List<String> cons;

  const TravelSeason({
    required this.name,
    required this.description,
    required this.averageTemperature,
    required this.averageRainfall,
    required this.crowdLevel,
    required this.priceLevel,
    required this.pros,
    required this.cons,
  });
}

/// Represents required travel documents
class TravelDocument {
  final String name;
  final String description;
  final bool isRequired;
  final String? validityPeriod;
  final String? processingTime;
  final String? applicationUrl;
  final double? cost;

  const TravelDocument({
    required this.name,
    required this.description,
    required this.isRequired,
    this.validityPeriod,
    this.processingTime,
    this.applicationUrl,
    this.cost,
  });
}

/// Pre-defined budget ranges
const List<BudgetRange> budgetRanges = [
  BudgetRange(label: "Budget", min: 0, max: 1000, currency: "USD"),
  BudgetRange(label: "Mid-range", min: 1000, max: 3000, currency: "USD"),
  BudgetRange(label: "Luxury", min: 3000, max: 10000, currency: "USD"),
];

/// Pre-defined beach destination options
const List<TravelOption> beachDestinations = [
  TravelOption(
    name: "Bali, Indonesia",
    description: "Paradise island with stunning beaches, temples, and tropical vibes",
    imageUrl: "https://picsum.photos/id/42/600/400",
    activities: ["Beach relaxation", "Surfing", "Temple visits", "Balinese massage"],
    rating: 4.8,
    reviewCount: 2500,
    details: {
      "bestTime": "April to October",
      "flightTime": "12-15 hours",
      "language": "Indonesian, English",
      "currency": "IDR",
    },
  ),
  TravelOption(
    name: "Maldives",
    description: "Pristine white sand beaches and crystal-clear turquoise waters",
    imageUrl: "https://picsum.photos/id/43/600/400",
    activities: ["Snorkeling", "Overwater bungalow stay", "Spa treatments", "Sunset cruises"],
    rating: 4.9,
    reviewCount: 1800,
    details: {
      "bestTime": "November to April",
      "flightTime": "10-12 hours",
      "language": "Dhivehi, English",
      "currency": "MVR",
    },
  ),
  TravelOption(
    name: "Amalfi Coast, Italy",
    description: "Breathtaking Mediterranean coastline with colorful villages",
    imageUrl: "https://picsum.photos/id/44/600/400",
    activities: ["Coastal drives", "Beach clubs", "Italian cuisine", "Boat tours"],
    rating: 4.7,
    reviewCount: 3200,
    details: {
      "bestTime": "May to September",
      "flightTime": "8-10 hours",
      "language": "Italian, English",
      "currency": "EUR",
    },
  ),
  TravelOption(
    name: "Diani Beach, Kenya",
    description: "Award-winning pristine white sand beach with turquoise waters and vibrant marine life",
    imageUrl: "https://images.unsplash.com/photo-1590523741831-ab7e8b8f9c7f",
    activities: ["Snorkeling", "Dhow cruises", "Kite surfing", "Dolphin watching"],
    rating: 4.9,
    reviewCount: 1850,
    details: {
      "bestTime": "January to March, July to October",
      "flightTime": "1 hour from Nairobi",
      "language": "Swahili, English",
      "currency": "KES",
    },
  ),
  TravelOption(
    name: "Watamu, Kenya",
    description: "Beautiful coastal town with pristine beaches, coral reefs and a marine national park",
    imageUrl: "https://images.unsplash.com/photo-1590784355451-9bc87c8a65af",
    activities: ["Snorkeling", "Turtle watching", "Deep-sea fishing", "Gede Ruins visits"],
    rating: 4.8,
    reviewCount: 1200,
    details: {
      "bestTime": "December to March, July to October",
      "flightTime": "30 minutes from Malindi Airport",
      "language": "Swahili, English",
      "currency": "KES",
    },
  ),
  TravelOption(
    name: "Lamu Island, Kenya",
    description: "UNESCO World Heritage site with pristine beaches and rich Swahili culture",
    imageUrl: "https://images.unsplash.com/photo-1506953823976-52e1fdc0149a",
    activities: ["Dhow sailing", "Old Town exploration", "Beach relaxation", "Cultural experiences"],
    rating: 4.7,
    reviewCount: 980,
    details: {
      "bestTime": "November to March",
      "flightTime": "1.5 hours from Nairobi",
      "language": "Swahili, English",
      "currency": "KES",
    },
  ),
];

/// Pre-defined mountain destination options
const List<TravelOption> mountainDestinations = [
  TravelOption(
    name: "Mount Kenya National Park",
    description: "UNESCO World Heritage site featuring Africa's second-highest mountain with stunning glaciers and lakes",
    imageUrl: "https://images.unsplash.com/photo-1573998615946-de94d29fbc57",
    activities: ["Mountain climbing", "Wildlife viewing", "Nature trails", "Lake Michaelson visits"],
    rating: 4.8,
    reviewCount: 1250,
    details: {
      "bestTime": "January-February, July-October",
      "distance": "175 km from Nairobi",
      "language": "Swahili, English",
      "currency": "KES",
    },
  ),
  TravelOption(
    name: "Aberdare National Park",
    description: "Beautiful mountain range with dense forests, spectacular waterfalls and diverse wildlife",
    imageUrl: "https://images.unsplash.com/photo-1630351841456-8ac731b4cf06",
    activities: ["Wildlife safaris", "Trout fishing", "Waterfall hikes", "Bird watching"],
    rating: 4.7,
    reviewCount: 980,
    details: {
      "bestTime": "June to September, December to February",
      "distance": "150 km from Nairobi",
      "language": "Swahili, English",
      "currency": "KES",
    },
  ),
  TravelOption(
    name: "Hell's Gate National Park",
    description: "Dramatic landscape with towering cliffs, gorges, and geothermal features",
    imageUrl: "https://images.unsplash.com/photo-1608369511685-628aa2a1df4e",
    activities: ["Rock climbing", "Cycling", "Hiking", "Geothermal spa visits"],
    rating: 4.6,
    reviewCount: 1100,
    details: {
      "bestTime": "January to March, June to October",
      "distance": "90 km from Nairobi",
      "language": "Swahili, English",
      "currency": "KES",
    },
  ),
];

/// Pre-defined city destination options
const List<TravelOption> cityDestinations = [
  TravelOption(
    name: "Nairobi, Kenya",
    description: "Dynamic capital city with modern amenities alongside wildlife and natural beauty",
    imageUrl: "https://images.unsplash.com/photo-1611348524140-53c9a25263d6",
    activities: ["Nairobi National Park", "Giraffe Centre", "David Sheldrick Wildlife Trust", "Maasai Market"],
    rating: 4.6,
    reviewCount: 2100,
    details: {
      "bestTime": "June to October, January to February",
      "airport": "Jomo Kenyatta International Airport",
      "language": "Swahili, English",
      "currency": "KES",
    },
  ),
  TravelOption(
    name: "Mombasa, Kenya",
    description: "Vibrant coastal city with rich history, diverse cultures and beautiful beaches",
    imageUrl: "https://images.unsplash.com/photo-1588697362969-9e4efe86edf1",
    activities: ["Fort Jesus", "Old Town", "Haller Park", "Nyali Beach"],
    rating: 4.7,
    reviewCount: 1850,
    details: {
      "bestTime": "January to March, July to October",
      "airport": "Moi International Airport",
      "language": "Swahili, English",
      "currency": "KES",
    },
  ),
  TravelOption(
    name: "Kisumu, Kenya",
    description: "Lakeside city with beautiful sunsets, vibrant culture, and the largest freshwater lake in Africa",
    imageUrl: "https://images.unsplash.com/photo-1609910696986-7869c7a15a34",
    activities: ["Lake Victoria", "Kisumu Museum", "Impala Sanctuary", "Dunga Beach"],
    rating: 4.5,
    reviewCount: 980,
    details: {
      "bestTime": "June to September, December to February",
      "airport": "Kisumu International Airport",
      "language": "Swahili, English, Luo",
      "currency": "KES",
    },
  ),
];

/// Pre-defined culinary destination options
const List<TravelOption> culinaryDestinations = [
  TravelOption(
    name: "Nairobi Food Scene, Kenya",
    description: "Vibrant culinary landscape with international restaurants and local delicacies",
    imageUrl: "https://images.unsplash.com/photo-1589010588553-46e8e7c21788",
    activities: ["Carnivore Restaurant", "Maasai Market food stalls", "Coffee tasting", "Nyama choma experiences"],
    rating: 4.6,
    reviewCount: 1850,
    details: {
      "bestTime": "Year-round",
      "specialties": "Nyama Choma, Ugali, Kenyan coffee",
      "language": "Swahili, English",
      "currency": "KES",
    },
  ),
  TravelOption(
    name: "Coastal Cuisine, Mombasa",
    description: "Delicious blend of African, Arab and Indian influences creating unique coastal flavors",
    imageUrl: "https://images.unsplash.com/photo-1606576219741-c8d0b8304658",
    activities: ["Seafood sampling", "Spice market tours", "Swahili cooking classes", "Street food exploration"],
    rating: 4.7,
    reviewCount: 1240,
    details: {
      "bestTime": "January to March, July to October",
      "specialties": "Biryani, Pilau, Fresh seafood",
      "language": "Swahili, English",
      "currency": "KES",
    },
  ),
  TravelOption(
    name: "Lake Victoria Food, Kisumu",
    description: "Fresh lake fish and traditional Luo cuisine in a picturesque lakeside setting",
    imageUrl: "https://images.unsplash.com/photo-1585937421612-70a008356fbe",
    activities: ["Tilapia tasting", "Fish market visits", "Traditional cooking demonstrations", "Sunset dinner cruises"],
    rating: 4.5,
    reviewCount: 980,
    details: {
      "bestTime": "June to September, December to February",
      "specialties": "Fried Tilapia, Ugali, Omena",
      "language": "Swahili, English, Luo",
      "currency": "KES",
    },
  ),
];

/// Pre-defined popular destination options
const List<TravelOption> popularDestinations = [
  TravelOption(
    name: "Maasai Mara National Reserve",
    description: "World-renowned wildlife reserve famous for the Great Migration and incredible safari experiences",
    imageUrl: "https://images.unsplash.com/photo-1516426122078-c23e76319801",
    activities: ["Wildlife safaris", "Hot air balloon rides", "Maasai village visits", "Bird watching"],
    rating: 4.9,
    reviewCount: 3200,
    details: {
      "bestTime": "July to October (Migration), January to March (Calving)",
      "distance": "270 km from Nairobi",
      "language": "Swahili, English, Maa",
      "currency": "KES",
    },
  ),
  TravelOption(
    name: "Amboseli National Park",
    description: "Iconic views of Mount Kilimanjaro with large elephant herds roaming the plains",
    imageUrl: "https://images.unsplash.com/photo-1535350356005-fd52b3b524fb",
    activities: ["Elephant watching", "Kilimanjaro views", "Cultural visits", "Wildlife photography"],
    rating: 4.8,
    reviewCount: 2100,
    details: {
      "bestTime": "June to October, January to February",
      "distance": "230 km from Nairobi",
      "language": "Swahili, English",
      "currency": "KES",
    },
  ),
  TravelOption(
    name: "Lake Nakuru National Park",
    description: "Famous flamingo lake and rhino sanctuary with diverse wildlife and stunning landscapes",
    imageUrl: "https://images.unsplash.com/photo-1544735716-ea9ef4d89c6f",
    activities: ["Flamingo watching", "Rhino sightings", "Game drives", "Tree-top birdwatching"],
    rating: 4.7,
    reviewCount: 1850,
    details: {
      "bestTime": "June to March (dry seasons)",
      "distance": "160 km from Nairobi",
      "language": "Swahili, English",
      "currency": "KES",
    },
  ),
];

class TravelRecommendation {
  final String title;
  final String description;
  final HotelDetails hotelDetails;
  final FlightDetails flightDetails;
  final List<String> activities;
  double totalPrice;
  final String duration;
  final List<String> accessibilityFeatures;

  TravelRecommendation({
    required this.title,
    required this.description,
    required this.hotelDetails,
    required this.flightDetails,
    required this.activities,
    required this.totalPrice,
    required this.duration,
    required this.accessibilityFeatures,
  });
}

class HotelDetails {
  final String name;
  final double rating;
  final double pricePerNight;
  final List<String> features;
  final List<String> images;

  HotelDetails({
    required this.name,
    required this.rating,
    required this.pricePerNight,
    required this.features,
    required this.images,
  });
}

class FlightDetails {
  final String airline;
  final String departureTime;
  final String returnTime;
  final int stopCount;
  final double price;
  final List<String> features;

  FlightDetails({
    required this.airline,
    required this.departureTime,
    required this.returnTime,
    required this.stopCount,
    required this.price,
    required this.features,
  });
}