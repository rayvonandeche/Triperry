import 'package:flutter/material.dart';
import '../../components/detail_modal.dart';
import '../../components/expandable_card.dart';

class Trips extends StatelessWidget {
  const Trips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar can be added here if needed, but it's managed globally in HomeScreen
      body: Container(
        // Add unified gradient background for consistency with other screens
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.97),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.90),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.80),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.only(top: kToolbarHeight + 60, left: 16.0, right: 16.0, bottom: 16.0), // Adjust top padding to account for global AppBar
          children: [
            Text(
              'Your Trips',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildTripCard(
              context,
              imageUrl: 'https://images.pexels.com/photos/210186/pexels-photo-210186.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260', // Example image
              title: 'Mountain Adventure',
              date: 'July 2024',
              description: 'An unforgettable journey through the Alps.',
            ),
            const SizedBox(height: 16),
            _buildTripCard(
              context,
              imageUrl: 'https://images.pexels.com/photos/1658967/pexels-photo-1658967.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260', // Example image
              title: 'Beach Getaway',
              date: 'August 2024',
              description: 'Relaxing by the turquoise waters.',
            ),
            const SizedBox(height: 16),
            _buildTripCard(
              context,
              imageUrl: 'https://images.pexels.com/photos/2363/france-landmark-lights-night.jpg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260', // Example image
              title: 'City Exploration',
              date: 'September 2024',
              description: 'Discovering the charm of Paris.',
            ),
            // Add more trip cards here
          ],
        ),
      ),
    );
  }

  Widget _buildTripCard(BuildContext context, {required String imageUrl, required String title, required String date, required String description}) {
    return Card(
      elevation: 0, // Remove default elevation for custom shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).cardColor.withOpacity(0.97),
              Theme.of(context).cardColor.withOpacity(0.87),
            ],
            stops: const [0.3, 1.0],
          ),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.08)
                : Colors.black.withOpacity(0.04),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 6),
              spreadRadius: 0.5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 180,
                      width: double.infinity,
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                          Colors.black.withOpacity(0.8),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.titleLarge?.color?.withOpacity(0.95),
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.8),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.85),
                        ),
                  ),
                  const SizedBox(height: 8),
                  // Add trip action buttons with smooth opacity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        icon: Icon(Icons.edit, 
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.9)),
                        label: Text('Edit',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.9))),
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                              width: 0.8,
                            ),
                          ),
                        ),
                        onPressed: () => _showTripEditModal(context, title),
                      ),
                      TextButton.icon(
                        icon: Icon(Icons.share, 
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.9)),
                        label: Text('Share',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.9))),
                        onPressed: () {},
                      ),
                      TextButton.icon(
                        icon: Icon(Icons.view_day, 
                          color: Theme.of(context).colorScheme.tertiary.withOpacity(0.9)),
                        label: Text('Details',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.9))),
                        onPressed: () => _showTripDetails(context, title, description),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Example of using DetailModal to show trip edit form
  void _showTripEditModal(BuildContext context, String tripTitle) {
    DetailModal.show(
      context: context,
      title: 'Edit Trip: $tripTitle',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Trip Name',
              hintText: tripTitle,
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'Destination',
              hintText: 'Where are you going?',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Start Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'End Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Trip updated successfully!')),
            );
          },
          child: Text('Save Changes'),
        ),
      ],
    );
  }

  // Example of using DetailModal to show trip details
  void _showTripDetails(BuildContext context, String title, String description) {
    DetailModal.show(
      context: context,
      title: title,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trip Overview',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8),
          Text(description),
          SizedBox(height: 16),
          
          // Expandable itineraries using ExpandableCard
          ExpandableCard(
            title: 'Day 1 - Arrival',
            subtitle: 'June 15, 2025',
            leading: CircleAvatar(child: Text('1')),
            expandedContent: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(Icons.flight_land),
                  title: Text('Arrival at Airport'),
                  subtitle: Text('10:30 AM - Kenya Airways KQ101'),
                ),
                ListTile(
                  leading: Icon(Icons.hotel),
                  title: Text('Check-in at Hotel'),
                  subtitle: Text('12:30 PM - Grand Safari Hotel'),
                ),
                ListTile(
                  leading: Icon(Icons.restaurant),
                  title: Text('Welcome Lunch'),
                  subtitle: Text('1:30 PM - Hotel Restaurant'),
                ),
              ],
            ),
          ),
          
          ExpandableCard(
            title: 'Day 2 - Safari Tour',
            subtitle: 'June 16, 2025',
            leading: CircleAvatar(child: Text('2')),
            expandedContent: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(Icons.wb_sunny),
                  title: Text('Breakfast'),
                  subtitle: Text('7:00 AM - Hotel Restaurant'),
                ),
                ListTile(
                  leading: Icon(Icons.directions_car),
                  title: Text('Depart for Safari'),
                  subtitle: Text('8:30 AM - Masai Mara National Park'),
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Wildlife Photography'),
                  subtitle: Text('10:30 AM - Big Five Viewing'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
