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
];

/// Pre-defined mountain destination options
const List<TravelOption> mountainDestinations = [
  TravelOption(
    name: "Swiss Alps",
    description: "Majestic mountain ranges with picturesque villages and excellent hiking",
    imageUrl: "https://picsum.photos/id/29/600/400",
    activities: ["Hiking", "Skiing", "Cable car rides", "Swiss chocolate tasting"],
  ),
  TravelOption(
    name: "Patagonia",
    description: "Dramatic landscapes with glaciers, mountains, and unique wildlife",
    imageUrl: "https://picsum.photos/id/28/600/400",
    activities: ["Trekking", "Wildlife watching", "Photography", "Camping"],
  ),
  TravelOption(
    name: "Canadian Rockies",
    description: "Stunning mountain range with emerald lakes and abundant wildlife",
    imageUrl: "https://picsum.photos/id/27/600/400",
    activities: ["Hiking", "Lake activities", "Wildlife spotting", "Scenic drives"],
  ),
];

/// Pre-defined city destination options
const List<TravelOption> cityDestinations = [
  TravelOption(
    name: "Tokyo, Japan",
    description: "Ultramodern metropolis with traditional elements and vibrant culture",
    imageUrl: "https://picsum.photos/id/30/600/400",
    activities: ["Shopping in Shibuya", "Visiting temples", "Food tours", "Robot restaurant"],
  ),
  TravelOption(
    name: "Barcelona, Spain",
    description: "Vibrant city with stunning architecture, beaches, and amazing food",
    imageUrl: "https://picsum.photos/id/31/600/400",
    activities: ["Sagrada Familia tour", "Tapas hopping", "Beach time", "Gothic Quarter"],
  ),
  TravelOption(
    name: "New York City, USA",
    description: "Iconic global city with world-famous landmarks and endless entertainment",
    imageUrl: "https://picsum.photos/id/32/600/400",
    activities: ["Broadway shows", "Museum visits", "Central Park", "Skyline views"],
  ),
];

/// Pre-defined culinary destination options
const List<TravelOption> culinaryDestinations = [
  TravelOption(
    name: "Lyon, France",
    description: "Gastronomic capital with exceptional cuisine and charming atmosphere",
    imageUrl: "https://picsum.photos/id/33/600/400",
    activities: ["Food tours", "Cooking classes", "Wine tasting", "Market visits"],
  ),
  TravelOption(
    name: "Bangkok, Thailand",
    description: "Street food paradise with vibrant flavors and culinary diversity",
    imageUrl: "https://picsum.photos/id/34/600/400",
    activities: ["Street food tours", "Cooking classes", "Market exploration", "Restaurant dining"],
  ),
  TravelOption(
    name: "Bologna, Italy",
    description: "Italy's food capital known for pasta, cured meats, and cheeses",
    imageUrl: "https://picsum.photos/id/35/600/400",
    activities: ["Pasta making", "Food market tours", "Parmesan factories", "Wine tasting"],
  ),
];

/// Pre-defined popular destination options
const List<TravelOption> popularDestinations = [
  TravelOption(
    name: "Paris, France",
    description: "City of lights with iconic landmarks and romantic atmosphere",
    imageUrl: "https://picsum.photos/id/36/600/400",
    activities: ["Eiffel Tower", "Louvre Museum", "Seine River cruise", "Café culture"],
  ),
  TravelOption(
    name: "Kyoto, Japan",
    description: "Cultural heart of Japan with ancient temples and traditional gardens",
    imageUrl: "https://picsum.photos/id/37/600/400",
    activities: ["Temple visits", "Geisha district", "Tea ceremonies", "Garden tours"],
  ),
  TravelOption(
    name: "Costa Rica",
    description: "Biodiverse paradise with rainforests, beaches, and adventure activities",
    imageUrl: "https://picsum.photos/id/38/600/400",
    activities: ["Zip-lining", "Wildlife watching", "Surfing", "Rainforest hikes"],
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