import 'package:flutter/material.dart';

/// Represents the different stages of the travel planning conversation
enum TravelStage {
  welcome,
  interestSelected,
  destinationSelected,
  timeSelected,
  complete,
}

/// Represents a message in the conversation history
class ConversationMessage {
  final bool isUser;
  final String text;
  final DateTime timestamp;
  
  const ConversationMessage({
    required this.isUser,
    required this.text,
    required this.timestamp,
  });
}

/// Represents a travel destination option
class TravelOption {
  final String name;
  final String description;
  final String imageUrl;
  final List<String> activities;
  
  const TravelOption({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.activities,
  });
}

/// Represents a day in the travel itinerary
class ItineraryDay {
  final String title;
  final List<String> activities;
  
  const ItineraryDay({
    required this.title,
    required this.activities,
  });
}

/// Pre-defined beach destination options
const List<TravelOption> beachDestinations = [
  TravelOption(
    name: "Bali, Indonesia",
    description: "Paradise island with stunning beaches, temples, and tropical vibes",
    imageUrl: "https://picsum.photos/id/42/600/400",
    activities: ["Beach relaxation", "Surfing", "Temple visits", "Balinese massage"],
  ),
  TravelOption(
    name: "Maldives",
    description: "Pristine white sand beaches and crystal-clear turquoise waters",
    imageUrl: "https://picsum.photos/id/43/600/400",
    activities: ["Snorkeling", "Overwater bungalow stay", "Spa treatments", "Sunset cruises"],
  ),
  TravelOption(
    name: "Amalfi Coast, Italy",
    description: "Breathtaking Mediterranean coastline with colorful villages",
    imageUrl: "https://picsum.photos/id/44/600/400",
    activities: ["Coastal drives", "Beach clubs", "Italian cuisine", "Boat tours"],
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