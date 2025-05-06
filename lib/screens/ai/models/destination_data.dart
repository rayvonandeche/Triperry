import 'package:flutter/material.dart';
import '../widgets/map_preview.dart';

class DestinationData {
  final String name;
  final double latitude;
  final double longitude;
  final List<MapPoint> pointsOfInterest;
  final String description;
  final String imageUrl;

  const DestinationData({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.pointsOfInterest,
    required this.description,
    required this.imageUrl,
  });
}

// Sample destination data
final List<DestinationData> destinations = [
  DestinationData(
    name: 'Paris, France',
    latitude: 48.8566,
    longitude: 2.3522,
    description: 'The City of Light, known for its iconic Eiffel Tower, world-class museums, and romantic atmosphere.',
    imageUrl: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34',
    pointsOfInterest: [
      MapPoint(x: 0.5, y: 0.5, icon: Icons.location_city, label: 'Eiffel Tower'),
      MapPoint(x: 0.3, y: 0.4, icon: Icons.museum, label: 'Louvre Museum'),
      MapPoint(x: 0.7, y: 0.6, icon: Icons.church, label: 'Notre-Dame'),
      MapPoint(x: 0.4, y: 0.7, icon: Icons.restaurant, label: 'Le Marais'),
    ],
  ),
  DestinationData(
    name: 'Tokyo, Japan',
    latitude: 35.6762,
    longitude: 139.6503,
    description: 'A vibrant metropolis where traditional culture meets cutting-edge technology.',
    imageUrl: 'https://images.unsplash.com/photo-1503899036084-c55cdd92da26',
    pointsOfInterest: [
      MapPoint(x: 0.6, y: 0.4, icon: Icons.location_city, label: 'Tokyo Tower'),
      MapPoint(x: 0.3, y: 0.5, icon: Icons.temple_buddhist, label: 'Senso-ji Temple'),
      MapPoint(x: 0.7, y: 0.6, icon: Icons.shopping_bag, label: 'Shibuya Crossing'),
      MapPoint(x: 0.5, y: 0.7, icon: Icons.park, label: 'Yoyogi Park'),
    ],
  ),
  DestinationData(
    name: 'New York, USA',
    latitude: 40.7128,
    longitude: -74.0060,
    description: 'The city that never sleeps, featuring iconic landmarks and endless entertainment.',
    imageUrl: 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9',
    pointsOfInterest: [
      MapPoint(x: 0.5, y: 0.5, icon: Icons.location_city, label: 'Empire State Building'),
      MapPoint(x: 0.3, y: 0.4, icon: Icons.park, label: 'Central Park'),
      MapPoint(x: 0.7, y: 0.6, icon: Icons.museum, label: 'Metropolitan Museum'),
      MapPoint(x: 0.4, y: 0.7, icon: Icons.theater_comedy, label: 'Broadway'),
    ],
  ),
  DestinationData(
    name: 'Bali, Indonesia',
    latitude: -8.3405,
    longitude: 115.0920,
    description: 'A tropical paradise known for its lush landscapes, beautiful beaches, and rich culture.',
    imageUrl: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4',
    pointsOfInterest: [
      MapPoint(x: 0.5, y: 0.5, icon: Icons.beach_access, label: 'Kuta Beach'),
      MapPoint(x: 0.3, y: 0.4, icon: Icons.temple_buddhist, label: 'Uluwatu Temple'),
      MapPoint(x: 0.7, y: 0.6, icon: Icons.landscape, label: 'Tegallalang Rice Terraces'),
      MapPoint(x: 0.4, y: 0.7, icon: Icons.water, label: 'Sacred Monkey Forest'),
    ],
  ),
  DestinationData(
    name: 'Sydney, Australia',
    latitude: -33.8688,
    longitude: 151.2093,
    description: 'A stunning harbor city with iconic architecture and beautiful beaches.',
    imageUrl: 'https://images.unsplash.com/photo-1506973035872-a4ec16b8e8d9',
    pointsOfInterest: [
      MapPoint(x: 0.5, y: 0.5, icon: Icons.location_city, label: 'Sydney Opera House'),
      MapPoint(x: 0.3, y: 0.4, icon: Icons.architecture, label: 'Harbour Bridge'),
      MapPoint(x: 0.7, y: 0.6, icon: Icons.beach_access, label: 'Bondi Beach'),
      MapPoint(x: 0.4, y: 0.7, icon: Icons.park, label: 'Royal Botanic Garden'),
    ],
  ),
]; 