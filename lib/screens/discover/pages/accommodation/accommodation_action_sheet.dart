import 'package:flutter/material.dart';
import 'package:triperry/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'accommodation_detail_screen.dart';

class AccommodationActionSheet extends StatelessWidget {
  final Map<String, dynamic> item;
  
  const AccommodationActionSheet({
    Key? key, 
    required this.item
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use fallback values for all fields
    final String image = (item['image'] as String?) ?? 'assets/images/placeholder.jpeg';
    final String title = (item['title'] as String?) ?? 'No Title';
    final String description = (item['description'] as String?) ?? 'No description available';
    final String price = (item['price'] as String?) ?? 'Contact for price';
    // Defensive: coordinates
    final Map<String, dynamic> coordinates = (item['coordinates'] as Map<String, dynamic>?) ?? {'lat': -1.286389, 'lng': 36.817223};

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            height: 5,
            width: 40,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          
          // Title and type
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      price,
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Location map preview
          _buildMapPreview(coordinates),
          const SizedBox(height: 20),
          
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ActionButton(
                icon: Icons.info_outline,
                text: 'Details',
                onTap: () {
                  Navigator.pop(context);
                    // Create a null-safe version of the item
                  final safeItem = <String, dynamic>{
                    'image': item['image'] ?? 'assets/images/placeholder.jpeg',
                    'title': item['title'] ?? 'Accommodation',
                    'description': item['description'] ?? 'No description available',
                    'address': item['address'] ?? 'Kenya',
                    'price': item['price'] ?? 'KSh 5,000/night',
                    'priceRange': item['price'] ?? 'KSh 5,000/night', // Add priceRange with same data as price
                    'rating': item['rating'] ?? 4.0,
                    'reviews': item['reviews'] ?? 0,
                    'amenities': item['amenities'] ?? <String>[],
                    'tags': (item['tags'] as List<dynamic>?) ?? <String>[],
                    'coordinates': item['coordinates'] ?? {'lat': -1.286389, 'lng': 36.817223},
                  };
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccommodationDetailScreen(
                        accommodation: safeItem,
                      ),
                    ),
                  );
                },
              ),
              _ActionButton(
                icon: Icons.share_outlined,
                text: 'Share',
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Share Accommodation'),
                      content: Text('Share the details of "${title}" with your friends!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Simulate share action
                          },
                          child: const Text('Share'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              _ActionButton(
                icon: Icons.favorite_border,
                text: 'Save',
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Saved to Favorites'),
                      content: Text('"${title}" has been added to your favorites.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              _ActionButton(
                icon: Icons.phone_outlined,
                text: 'Call',
                onTap: () async {
                  Navigator.pop(context);
                  final Uri phoneLaunchUri = Uri(
                    scheme: 'tel',
                    path: '+254712345678',
                  );
                  if (await canLaunchUrl(phoneLaunchUri)) {
                    await launchUrl(phoneLaunchUri);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cannot make a call at this time')),
                      );
                    }
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Book now button
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccommodationDetailScreen(
                    accommodation: item,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Book Now',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPreview(Map<String, dynamic> coordinates) {
    final lat = coordinates['lat'] as double? ?? -1.286389;
    final lng = coordinates['lng'] as double? ?? 36.817223;
    
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(lat, lng),
            initialZoom: 13,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.triperry.app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 40,
                  height: 40,
                  point: LatLng(lat, lng),
                  child: const Icon(
                    Icons.location_pin,
                    color: AppTheme.primaryColor,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              text,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
