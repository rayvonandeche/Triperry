import 'package:flutter/material.dart';
import '../screens/ai/models/destination_data.dart';
import '../screens/ai/widgets/map_preview.dart';
import 'travel_data_service.dart';

class DestinationService {
  // Demo data map
  static final Map<String, Map<String, dynamic>> _demoDestinations = {
    'paris': {
      'name': 'Paris, France',
      'description': 'Known as the "City of Light," Paris is famous for its iconic landmarks, world-class museums, and romantic ambiance.',
      'attractions': ['Eiffel Tower', 'Louvre Museum', 'Notre-Dame Cathedral', 'Montmartre', 'Champs-Élysées'],
      'landmarks': ['Arc de Triomphe', 'Palace of Versailles', 'Sacre Coeur'],
    },
    'tokyo': {
      'name': 'Tokyo, Japan',
      'description': 'A dynamic metropolis that blends ultramodern and traditional elements.',
      'attractions': ['Tokyo Skytree', 'Shibuya Crossing', 'Senso-ji Temple', 'Meiji Shrine', 'Tsukiji Market'],
      'landmarks': ['Tokyo Tower', 'Imperial Palace', 'Tokyo Station'],
    },
    'new york': {
      'name': 'New York City, USA',
      'description': 'A global hub for culture, finance, media, and entertainment.',
      'attractions': ['Empire State Building', 'Central Park', 'Statue of Liberty', 'Times Square', 'Metropolitan Museum'],
      'landmarks': ['Brooklyn Bridge', 'Rockefeller Center', 'Grand Central Terminal'],
    },
    'bali': {
      'name': 'Bali, Indonesia',
      'description': 'A tropical paradise known for its lush landscapes, beautiful beaches, and rich cultural heritage.',
      'attractions': ['Tanah Lot Temple', 'Ubud Monkey Forest', 'Tegallalang Rice Terraces', 'Uluwatu Temple', 'Seminyak Beach'],
      'landmarks': ['Mount Batur', 'Sacred Monkey Forest', 'Tirta Empul Temple'],
    },
    'sydney': {
      'name': 'Sydney, Australia',
      'description': 'A stunning harbor city with iconic architecture and beautiful beaches.',
      'attractions': ['Sydney Opera House', 'Harbour Bridge', 'Bondi Beach', 'Royal Botanic Garden', 'Darling Harbour'],
      'landmarks': ['The Rocks', 'Taronga Zoo', 'Manly Beach'],
    },
  };

  static List<DestinationData> getDestinationsByInterest(String interest) {
    // Get destinations from both sample data and demo data
    final List<DestinationData> allDestinations = [
      ...destinations,
      ..._convertDemoDestinationsToDestinationData(),
    ];

    switch (interest.toLowerCase()) {
      case 'beach':
        return allDestinations.where((d) => 
          d.pointsOfInterest.any((p) => p.icon == Icons.beach_access) ||
          d.description.toLowerCase().contains('beach')).toList();
      case 'city':
        return allDestinations.where((d) => 
          d.pointsOfInterest.any((p) => p.icon == Icons.location_city) ||
          d.description.toLowerCase().contains('city')).toList();
      case 'mountain':
        return allDestinations.where((d) => 
          d.pointsOfInterest.any((p) => p.icon == Icons.landscape) ||
          d.description.toLowerCase().contains('mountain')).toList();
      case 'food':
        return allDestinations.where((d) => 
          d.pointsOfInterest.any((p) => p.icon == Icons.restaurant) ||
          d.description.toLowerCase().contains('food') ||
          d.description.toLowerCase().contains('cuisine')).toList();
      case 'adventure':
        return allDestinations.where((d) => 
          d.description.toLowerCase().contains('adventure') ||
          d.description.toLowerCase().contains('explore')).toList();
      case 'culture':
        return allDestinations.where((d) => 
          d.description.toLowerCase().contains('culture') ||
          d.description.toLowerCase().contains('historical')).toList();
      default:
        return allDestinations;
    }
  }

  static List<MapPoint> getPointsOfInterestForDestination(String destinationName) {
    final destination = getDestinationByName(destinationName);
    if (destination == null) return [];
    return destination.pointsOfInterest;
  }

  static DestinationData? getDestinationByName(String name) {
    // Search in both sample data and demo data
    final List<DestinationData> allDestinations = [
      ...destinations,
      ..._convertDemoDestinationsToDestinationData(),
    ];

    try {
      return allDestinations.firstWhere(
        (d) => d.name.toLowerCase().contains(name.toLowerCase()),
      );
    } catch (e) {
      return null;
    }
  }

  static List<String> getDestinationNames() {
    final List<DestinationData> allDestinations = [
      ...destinations,
      ..._convertDemoDestinationsToDestinationData(),
    ];
    return allDestinations.map((d) => d.name).toList();
  }

  static List<MapPoint> getPopularAttractions(String destinationName) {
    final destination = getDestinationByName(destinationName);
    if (destination == null) return [];
    return destination.pointsOfInterest;
  }

  static Map<String, dynamic> getDestinationDetails(String destinationName) {
    final destination = getDestinationByName(destinationName);
    if (destination == null) return {};

    // Get additional travel data if available
    final travelData = TravelDataService().getDestinationData(destinationName);
    
    return {
      'name': destination.name,
      'description': destination.description,
      'latitude': destination.latitude,
      'longitude': destination.longitude,
      'imageUrl': destination.imageUrl,
      'pointsOfInterest': destination.pointsOfInterest.map((p) => {
        'name': p.label,
        'icon': p.icon.codePoint,
        'x': p.x,
        'y': p.y,
      }).toList(),
      'travelData': travelData,
    };
  }

  // Helper method to convert demo destinations to DestinationData
  static List<DestinationData> _convertDemoDestinationsToDestinationData() {
    return _demoDestinations.entries.map((entry) {
      final data = entry.value;
      return DestinationData(
        name: data['name'],
        latitude: 0.0, // Default values since demo data doesn't include coordinates
        longitude: 0.0,
        description: data['description'],
        imageUrl: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34',
        pointsOfInterest: _generatePointsOfInterest(data),
      );
    }).toList();
  }

  // Helper method to generate points of interest based on demo destination data
  static List<MapPoint> _generatePointsOfInterest(Map<String, dynamic> data) {
    final List<MapPoint> points = [];
    
    // Add main attractions
    if (data['attractions'] != null) {
      for (var i = 0; i < data['attractions'].length; i++) {
        final attraction = data['attractions'][i];
        points.add(MapPoint(
          x: 0.3 + (i * 0.2),
          y: 0.4 + (i * 0.1),
          icon: _getIconForAttraction(attraction),
          label: attraction,
        ));
      }
    }

    // Add landmarks
    if (data['landmarks'] != null) {
      for (var i = 0; i < data['landmarks'].length; i++) {
        final landmark = data['landmarks'][i];
        points.add(MapPoint(
          x: 0.5 + (i * 0.15),
          y: 0.6 + (i * 0.1),
          icon: Icons.location_city,
          label: landmark,
        ));
      }
    }

    return points;
  }

  // Helper method to get appropriate icon for attraction
  static IconData _getIconForAttraction(String attraction) {
    final lowerAttraction = attraction.toLowerCase();
    if (lowerAttraction.contains('beach')) return Icons.beach_access;
    if (lowerAttraction.contains('museum')) return Icons.museum;
    if (lowerAttraction.contains('park')) return Icons.park;
    if (lowerAttraction.contains('temple')) return Icons.temple_buddhist;
    if (lowerAttraction.contains('restaurant')) return Icons.restaurant;
    if (lowerAttraction.contains('shopping')) return Icons.shopping_bag;
    return Icons.place; // Default icon
  }
} 