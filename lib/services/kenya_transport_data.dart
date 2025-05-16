
import 'package:flutter/material.dart';

/// This file contains the data for the transport options in Kenya
/// The data is structured to be used in the transport pages
class KenyaTransportData {
  // List of all transport categories
  static List<String> transportCategories = ['All', 'Cars', 'Flights', 'Trains', 'Boats', 'Safari'];

  // Transport options by category
  static List<Map<String, dynamic>> getAllTransport() {
    return [
      // Cars
      {
        'title': 'Economy Car',
        'description': 'Affordable city transport',
        'image': 'assets/images/city.jpeg',
        'price': 'KSh 3,000/day',
        'rating': 4.2,
        'reviews': 83,
        'address': 'Nairobi',
        'amenities': ['Air conditioning', 'Bluetooth', '5 seats', 'Unlimited mileage'],
        'tags': ['Economic', 'City', 'Sedan'],
        'type': 'Cars',
        'id': 'car-economy-1',
      },
      {
        'title': 'SUV Rental',
        'description': 'Comfortable for rough terrain',
        'image': 'assets/images/safari vehicel.jpeg',
        'price': 'KSh 8,000/day',
        'rating': 4.6,
        'reviews': 124,
        'address': 'Nairobi',
        'amenities': ['4x4', '7 seats', 'Air conditioning', 'Safari ready'],
        'tags': ['Adventure', 'Family', 'Spacious'],
        'type': 'Cars',
        'id': 'car-suv-1',
      },
      {
        'title': 'Luxury Sedan',
        'description': 'Premium city transport',
        'image': 'assets/images/city.jpeg',
        'price': 'KSh 12,000/day',
        'rating': 4.8,
        'reviews': 45,
        'address': 'Nairobi',
        'amenities': ['Leather seats', 'Premium sound', 'Driver included'],
        'tags': ['Luxury', 'Business', 'Comfort'],
        'type': 'Cars',
        'id': 'car-luxury-1',
      },
      
      // Flights
      {
        'title': 'Nairobi - Mombasa Flight',
        'description': 'Daily scheduled flights',
        'image': 'assets/images/small aircraft landing.png',
        'price': 'KSh 10,000/person',
        'rating': 4.3,
        'reviews': 210,
        'address': 'Wilson Airport',
        'amenities': ['45 minute flight', 'Snacks', '15kg luggage'],
        'tags': ['Quick', 'Scheduled', 'Coastal'],
        'type': 'Flights',
        'id': 'flight-nairobi-mombasa',
      },
      {
        'title': 'Masai Mara Safari Flight',
        'description': 'Direct to the national reserve',
        'image': 'assets/images/small aircraft landing.png',
        'price': 'KSh 15,000/person',
        'rating': 4.9,
        'reviews': 178,
        'address': 'Wilson Airport',
        'amenities': ['1 hour flight', 'Game viewing', 'Landing inside park'],
        'tags': ['Safari', 'Wildlife', 'Adventure'],
        'type': 'Flights',
        'id': 'flight-masai-mara',
      },
      {
        'title': 'Lamu Island Charter',
        'description': 'Private flights to coastal paradise',
        'image': 'assets/images/small aircraft landing.png',
        'price': 'KSh 80,000/charter',
        'rating': 4.7,
        'reviews': 32,
        'address': 'Wilson Airport',
        'amenities': ['Private plane', 'Flexible schedule', 'Up to 6 passengers'],
        'tags': ['Luxury', 'Privacy', 'Island'],
        'type': 'Flights',
        'id': 'flight-lamu-charter',
      },
      
      // Trains
      {
        'title': 'SGR Express: Nairobi-Mombasa',
        'description': 'Modern rail transport',
        'image': 'assets/images/nairoboi railways.jpeg',
        'price': 'KSh 3,000/ticket',
        'rating': 4.5,
        'reviews': 312,
        'address': 'Nairobi Terminus',
        'amenities': ['First class option', 'Restaurant', 'Scenic views'],
        'tags': ['Comfortable', 'Scenic', 'Affordable'],
        'type': 'Trains',
        'id': 'train-nairobi-mombasa',
      },
      {
        'title': 'Nairobi-Kisumu Train',
        'description': 'Western Kenya connection',
        'image': 'assets/images/nairoboi railways.jpeg',
        'price': 'KSh 2,500/ticket',
        'rating': 4.0,
        'reviews': 145,
        'address': 'Nairobi Central Station',
        'amenities': ['Sleeper cabins', 'Dining car', 'Overnight journey'],
        'tags': ['Overnight', 'Historical', 'Western Kenya'],
        'type': 'Trains',
        'id': 'train-nairobi-kisumu',
      },
      
      // Boats
      {
        'title': 'Traditional Dhow Experience',
        'description': 'Sail along the Kenyan coast',
        'image': 'assets/images/traditional dhow.png',
        'price': 'KSh 6,000/trip',
        'rating': 4.8,
        'reviews': 98,
        'address': 'Lamu Old Town',
        'amenities': ['Sunset cruises', 'Snorkeling', 'Cultural experience'],
        'tags': ['Cultural', 'Coastal', 'Relaxing'],
        'type': 'Boats',
        'id': 'boat-dhow-lamu',
      },
      {
        'title': 'Lake Victoria Cruise',
        'description': 'Explore Africa\'s largest lake',
        'image': 'assets/images/traditional dhow.png',
        'price': 'KSh 4,500/person',
        'rating': 4.1,
        'reviews': 64,
        'address': 'Kisumu Port',
        'amenities': ['Day trips', 'Lunch included', 'Birdwatching'],
        'tags': ['Lake', 'Nature', 'Day trip'],
        'type': 'Boats',
        'id': 'boat-lake-victoria',
      },
      
      // Safari
      {
        'title': 'Masai Mara Game Drive',
        'description': 'Open-top safari vehicles',
        'image': 'assets/images/safari vehicel.jpeg',
        'price': 'KSh 10,000/person',
        'rating': 4.9,
        'reviews': 213,
        'address': 'Masai Mara Reserve',
        'amenities': ['Experienced guides', 'Full-day tours', 'Wildlife spotting'],
        'tags': ['Big Five', 'Wildlife', 'Photography'],
        'type': 'Safari',
        'id': 'safari-masai-mara',
      },
      {
        'title': 'Amboseli Safari Transfer',
        'description': 'Transport with game viewing',
        'image': 'assets/images/safari vehicel.jpeg',
        'price': 'KSh 8,000/person',
        'rating': 4.7,
        'reviews': 87,
        'address': 'Amboseli National Park',
        'amenities': ['Full-day experience', 'Kilimanjaro views', 'Picnic lunch'],
        'tags': ['Elephants', 'Scenic', 'Day trip'],
        'type': 'Safari',
        'id': 'safari-amboseli',
      },
    ];
  }

  // Featured transport options for the carousel
  static List<Map<String, dynamic>> getFeaturedTransport() {
    return [
      {
        'title': 'Safari Vehicles',
        'description': 'Perfect for game drives and wildlife viewing',
        'image': 'assets/images/safari vehicel.jpeg',
        'price': 'From KSh 8,000/day',
        'type': 'Safari',
        'id': 'featured-safari',
      },
      {
        'title': 'Charter Flights',
        'description': 'Quick transfers to remote destinations',
        'image': 'assets/images/small aircraft landing.png',
        'price': 'From KSh 25,000/person',
        'type': 'Flights',
        'id': 'featured-flights',
      },
      {
        'title': 'Traditional Dhows',
        'description': 'Sail along the Kenyan coast in style',
        'image': 'assets/images/traditional dhow.png',
        'price': 'From KSh 6,000/trip',
        'type': 'Boats',
        'id': 'featured-dhows',
      },
    ];
  }

  // Popular transport options
  static List<Map<String, dynamic>> getPopularTransport() {
    return [
      {
        'title': 'Nairobi - Mombasa',
        'description': 'SGR Train',
        'image': 'assets/images/nairoboi railways.jpeg',
        'price': 'From KSh 3,000',
        'rating': 4.7,
        'type': 'Trains',
        'id': 'popular-train-sgr',
      },
      {
        'title': 'Nairobi - Masai Mara',
        'description': 'Small Aircraft',
        'image': 'assets/images/small aircraft landing.png',
        'price': 'From KSh 12,000',
        'rating': 4.9,
        'type': 'Flights',
        'id': 'popular-flight-mara',
      },
      {
        'title': 'Airport - Hotel Transfer',
        'description': 'Private Car',
        'image': 'assets/images/city.jpeg',
        'price': 'From KSh 2,000',
        'rating': 4.5,
        'type': 'Cars',
        'id': 'popular-car-transfer',
      },
    ];
  }

  // Recommended transport options
  static List<Map<String, dynamic>> getRecommendedTransport() {
    return [
      {
        'title': 'Safari Vehicles',
        'description': 'Perfect for game drives',
        'image': 'assets/images/safari vehicel.jpeg',
        'price': 'From KSh 8,000/day',
        'type': 'Safari',
        'id': 'recommended-safari',
      },
      {
        'title': 'Traditional Dhows',
        'description': 'Coastal excursions',
        'image': 'assets/images/traditional dhow.png',
        'price': 'From KSh 6,000/trip',
        'type': 'Boats',
        'id': 'recommended-dhows',
      },
      {
        'title': 'Luxury Cars',
        'description': 'City exploration in comfort',
        'image': 'assets/images/city.jpeg',
        'price': 'From KSh 10,000/day',
        'type': 'Cars',
        'id': 'recommended-luxury-car',
      },
      {
        'title': 'Railway Journeys',
        'description': 'Scenic routes across Kenya',
        'image': 'assets/images/nairoboi railways.jpeg',
        'price': 'From KSh 4,000/ticket',
        'type': 'Trains',
        'id': 'recommended-train',
      },
      {
        'title': 'Private Helicopters',
        'description': 'Ultimate luxury travel',
        'image': 'assets/images/small aircraft landing.png',
        'price': 'From KSh 50,000/hour',
        'type': 'Flights',
        'id': 'recommended-helicopter',
      },
    ];
  }

  // Get transport by type/category
  static List<Map<String, dynamic>> getTransportByType(String transportType) {
    if (transportType == 'All') {
      return getAllTransport();
    }
    
    return getAllTransport().where((transport) => transport['type'] == transportType).toList();
  }

  // Get transport by ID
  static Map<String, dynamic>? getTransportById(String id) {
    try {
      return getAllTransport().firstWhere((transport) => transport['id'] == id);
    } catch (e) {
      return null;
    }
  }
}
