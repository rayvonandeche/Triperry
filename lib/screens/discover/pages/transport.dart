import 'package:flutter/material.dart';
import 'package:triperry/theme/app_theme.dart';

Widget buildTransportContent() {
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: 5,
    itemBuilder: (context, index) {
      List<Map<String, dynamic>> transportOptions = [
        {
          'title': 'Safari Vehicles',
          'description': 'Perfect for game drives and wildlife viewing',
          'image': 'assets/images/safari vehicel.jpeg',
          'price': 'From \$80/day',
        },
        {
          'title': 'Charter Flights',
          'description': 'Quick transfers to remote destinations',
          'image': 'assets/images/small aircraft landing.png',
          'price': 'From \$250/person',
        },
        {
          'title': 'Traditional Dhows',
          'description': 'Sail along the Kenyan coast in style',
          'image': 'assets/images/traditional dhow.png',
          'price': 'From \$60/trip',
        },
        {
          'title': 'Railway Journeys',
          'description': 'Scenic rail travel across Kenya',
          'image': 'assets/images/nairoboi railways.jpeg',
          'price': 'From \$40/ticket',
        },
        {
          'title': 'Private Transfers',
          'description': 'Comfortable travel between destinations',
          'image': 'assets/images/city.jpeg',
          'price': 'From \$25/trip',
        },
      ];

      final transport = transportOptions[index];

      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              child: Image.asset(
                transport['image'],
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transport['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      transport['description'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      transport['price'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: AppTheme.primaryColor),
              onPressed: () {},
            ),
          ],
        ),
      );
    },
  );
}
