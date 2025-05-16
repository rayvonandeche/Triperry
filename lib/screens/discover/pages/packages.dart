import 'package:flutter/material.dart';
import 'package:triperry/theme/app_theme.dart';

Widget buildPackagesContent() {
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: 5,
    itemBuilder: (context, index) {
      List<Map<String, dynamic>> packages = [
        {
          'title': '7-Day Kenya Safari Experience',
          'description': 'Visit Maasai Mara, Amboseli, and Lake Nakuru',
          'price': '\$1,200',
          'days': '7 days',
          'image': 'assets/images/kenya safari.jpeg',
        },
        {
          'title': 'Beach and Wildlife Combo',
          'description': 'Safari adventure followed by coastal relaxation',
          'price': '\$1,500',
          'days': '10 days',
          'image': 'assets/images/tropical beach.jpeg',
        },
        {
          'title': 'Kenya Family Adventure',
          'description': 'Kid-friendly activities across Kenya',
          'price': '\$2,400',
          'days': '8 days',
          'image': 'assets/images/girraffe.png',
        },
        {
          'title': 'Cultural Heritage Tour',
          'description': 'Explore Kenya\'s rich cultural diversity',
          'price': '\$950',
          'days': '6 days',
          'image': 'assets/images/masaai village.png',
        },
        {
          'title': 'Mt. Kenya and Savannah',
          'description': 'Hiking and wildlife in one amazing package',
          'price': '\$1,350',
          'days': '9 days',
          'image': 'assets/images/mount kenya.png',
        },
      ];

      final package = packages[index];

      return Card(
        margin: const EdgeInsets.only(bottom: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    package['image'],
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: AppTheme.primaryColor),
                        const SizedBox(width: 4),
                        Text(
                          package['days'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    package['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        package['price'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'View Details',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
