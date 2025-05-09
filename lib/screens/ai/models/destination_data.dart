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
    name: 'Nairobi, Kenya',
    latitude: -1.2921,
    longitude: 36.8219,
    description: 'The vibrant capital city of Kenya, known for its national park, bustling markets, and rich history.',
    imageUrl: 'https://images.unsplash.com/photo-1580416358097-75f397275102', // Replace with a relevant Nairobi image
    pointsOfInterest: [
      MapPoint(x: 0.4, y: 0.5, icon: Icons.park, label: 'Nairobi National Park'),
      MapPoint(x: 0.6, y: 0.6, icon: Icons.museum, label: 'Karen Blixen Museum'),
      MapPoint(x: 0.5, y: 0.7, icon: Icons.shopping_cart, label: 'Maasai Market'),
    ],
  ),
  DestinationData(
    name: 'Mombasa, Kenya',
    latitude: -4.0435,
    longitude: 39.6682,
    description: 'A coastal city with beautiful beaches, historic Old Town, and vibrant Swahili culture.',
    imageUrl: 'https://images.unsplash.com/photo-1580654712603-eb43273aff33', // Replace with a relevant Mombasa image
    pointsOfInterest: [
      MapPoint(x: 0.5, y: 0.5, icon: Icons.beach_access, label: 'Diani Beach'),
      MapPoint(x: 0.3, y: 0.4, icon: Icons.fort, label: 'Fort Jesus'),
      MapPoint(x: 0.7, y: 0.6, icon: Icons.history_edu, label: 'Old Town'),
    ],
  ),
  DestinationData(
    name: 'Maasai Mara, Kenya',
    latitude: -1.6500,
    longitude: 35.0000,
    description: 'World-renowned wildlife reserve, famous for the Great Migration and abundant wildlife.',
    imageUrl: 'https://images.unsplash.com/photo-1534607287018-b9c1d1a00846', // Replace with a relevant Maasai Mara image
    pointsOfInterest: [
      MapPoint(x: 0.5, y: 0.5, icon: Icons.landscape, label: 'Mara River'),
      MapPoint(x: 0.3, y: 0.4, icon: Icons.visibility, label: 'Wildlife Safari'),
      MapPoint(x: 0.7, y: 0.6, icon: Icons.people_alt, label: 'Maasai Village'),
    ],
  ),
  DestinationData(
    name: 'Kisumu, Kenya',
    latitude: -0.0917,
    longitude: 34.7680,
    description: 'A port city on Lake Victoria, known for its hippos, birdlife, and vibrant fishing industry.',
    imageUrl: 'https://images.unsplash.com/photo-1609910696986-7869c7a15a34', // Replace with a relevant Kisumu image
    pointsOfInterest: [
      MapPoint(x: 0.5, y: 0.5, icon: Icons.sailing, label: 'Lake Victoria'),
      MapPoint(x: 0.3, y: 0.4, icon: Icons.museum, label: 'Kisumu Museum'),
      MapPoint(x: 0.7, y: 0.6, icon: Icons.park, label: 'Impala Sanctuary'),
    ],
  ),
];