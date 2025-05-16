import 'package:flutter/material.dart';
import 'package:triperry/theme/app_theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../services/kenya_places_data.dart';
import 'accommodation_detail_screen.dart';
import 'accommodation_type_sheet.dart';
import 'accommodation_action_sheet.dart';

void showAccommodationActionSheet(BuildContext context, Map<String, dynamic> item) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => AccommodationActionSheet(item: item),
  );
}

class Accommodation extends StatefulWidget {
  const Accommodation({super.key});

  @override
  State<Accommodation> createState() => _AccommodationPageState();
}

class _AccommodationPageState extends State<Accommodation> with SingleTickerProviderStateMixin {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Hotels', 'Lodges', 'Resorts', 'AirBnB', 'Campsites', 'Hostels'];
  
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    // Auto-rotate animation to draw attention to the category selector
    Future.delayed(const Duration(seconds: 1), () {
      _animationController.repeat(reverse: true);
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildAccommodationContent();
  }

  Widget buildAccommodationContent() {
    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 80),
      children: [
        _buildCategorySelector(),
        const SizedBox(height: 16),
        _buildCarouselSection(),
        const SizedBox(height: 24),
        _buildSectionTitle('Popular Accommodation Types'),
        const SizedBox(height: 16),
        _buildTrendingSection(),
        const SizedBox(height: 24),
        _buildSectionTitle('Recommended Places to Stay'),
        const SizedBox(height: 16),
        _buildRecommendedSection(),
        const SizedBox(height: 24),
        _buildSectionTitleWithViewAll('Spotlight Stays'),
        const SizedBox(height: 16),
        _buildTrendingVideosSection(),
        const SizedBox(height: 24),
        _buildSectionTitleWithViewAll('Special Deals'),
        const SizedBox(height: 16),
        _buildTrendingPackagesList(),
        const SizedBox(height: 32), // Extra padding at the bottom
      ],
    );
  }  Widget _buildCategorySelector() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
              // Show filtered accommodations in a bottom sheet
              showAccommodationTypeSheet(context, category);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                  width: 1.5,
                ),
                boxShadow: isSelected 
                  ? [BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )]
                  : null,
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.primaryColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCarouselSection() {
    final carouselItems = kenyaDestinations
        .take(5)
        .map((place) => {
              'image': place['image'],
              'title': '${_getAccommodationName(place['name'])}',
              'subtitle': '${_getAccommodationType(place['name'])}',
              'isAd': true,
            })
        .toList();
    return _AutoRotatingCarousel(carouselItems: carouselItems);
  }

  Widget _buildTrendingSection() {
    final allCategories = kenyaDestinations
        .take(5)
        .map((place) => {
              'title': _getAccommodationType(place['name']),
              'description': 'Top ${_getAccommodationType(place['name'])} options',
              'image': place['image'],
              'activities': _getAccommodationAmenities(place['name']),
            })
        .toList();
    return _AnimatedTrendingList(allCategories: allCategories);
  }

  Widget _buildRecommendedSection() {
    final recommendedItems = kenyaDestinations
        .take(5)
        .map((place) => {
              'title': _getAccommodationName(place['name']),
              'description': '${_getAccommodationType(place['name'])}',
              'image': place['image'],
              'price': 'From ${_getPriceRange(place['name'])}',
              'tags': _getAccommodationTags(place['name']),
              'rating': place['rating'],
              'location': place['address'] ?? 'Kenya',
              'coordinates': _getAccommodationCoordinates(
                  _getAccommodationName(place['name']), place['name']),
            })
        .toList();
    return SizedBox(
      height: 320,
      child: _RecommendedCarouselList(items: recommendedItems),
    );
  }
  Widget _buildSectionTitleWithViewAll(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              // Show all items related to the section title
              String categoryType = 'All';
              if (title == 'Spotlight Stays') {
                categoryType = 'Luxury';
              } else if (title == 'Special Deals') {
                categoryType = 'Deals';
              }
              showAccommodationTypeSheet(context, categoryType);
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View All',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppTheme.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingVideosSection() {
    final trendingVideos = kenyaDestinations
        .take(5)
        .map((place) => {
              'title': place['name'] + ' Stay',
              'duration': '3:30',
              'views': '${place['reviews']}+',
              'image': place['image'],
              'creator': 'Kenya Travel',
              'verified': true,
            })
        .toList();
    return SizedBox(
      height: 233,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: trendingVideos.length,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          final video = trendingVideos[index];
          return _VideoCard(video: video);
        },
      ),
    );
  }

  Widget _buildTrendingPackagesList() {
    final trendingPackages = kenyaDestinations
        .skip(1)
        .take(4)
        .map((place) => {
              'title': place['name'],
              'description': place['description'],
              'price': place['price'],
              'rating': place['rating'],
              'reviews': place['reviews'],
              'image': place['image'],
              'discount': null,
              'badge': place['reviews'] > 1500
                  ? 'Best Value'
                  : (place['rating'] >= 4.7 ? 'Top Rated' : ''),
              'location': place['address'] ?? 'Kenya',
              'coordinates': _getLocationCoordinates(place['name']),
            })
        .toList();
    return Column(
      children: [
        for (final package in trendingPackages)
          Padding(
            padding:
                const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
            child: _PackageCard(package: package),
          ),
      ],
    );
  }

  // Helper methods for accommodation data
  Map<String, double> _getAccommodationCoordinates(
      String accommodationName, String locationName) {
    // Map accommodation names to coordinates
    final coordinates = {
      'Savannah Lodge': {'lat': -1.5, 'lng': 35.1}, // Maasai Mara
      'Beach Resort': {'lat': -4.277, 'lng': 39.591}, // Diani Beach
      'Mountain View Hotel': {'lat': -0.152, 'lng': 37.3}, // Mt Kenya
      'City Hotel': {'lat': -1.312, 'lng': 36.817}, // Nairobi
      'Coastal Retreat': {'lat': -2.269, 'lng': 40.902}, // Lamu
    };

    if (coordinates.containsKey(accommodationName)) {
      return {
        'lat': coordinates[accommodationName]!['lat']!,
        'lng': coordinates[accommodationName]!['lng']!,
      };
    }

    // Default to Nairobi
    return {'lat': -1.286389, 'lng': 36.817223};
  }

  Map<String, double> _getLocationCoordinates(String placeName) {
    // Map place names to coordinates
    final coordinates = {
      'Maasai Mara National Reserve': {'lat': -1.5, 'lng': 35.1},
      'Diani Beach': {'lat': -4.277, 'lng': 39.591},
      'Mount Kenya': {'lat': -0.152, 'lng': 37.3},
      'Nairobi National Park': {'lat': -1.312, 'lng': 36.817},
      'Lamu Old Town': {'lat': -2.269, 'lng': 40.902},
    };

    if (coordinates.containsKey(placeName)) {
      return {
        'lat': coordinates[placeName]!['lat']!,
        'lng': coordinates[placeName]!['lng']!,
      };
    }

    // Default to Nairobi coordinates
    return {'lat': -1.286389, 'lng': 36.817223};
  }

  String _getAccommodationName(String placeName) {
    final names = {
      'Maasai Mara': 'Savannah Lodge',
      'Diani Beach': 'Beach Resort',
      'Mount Kenya': 'Mountain View Hotel',
      'Nairobi': 'City Hotel',
      'Lamu': 'Coastal Retreat'
    };
    return names[placeName] ?? '$placeName Accommodation';
  }

  String _getAccommodationType(String placeName) {
    final types = {
      'Maasai Mara': 'Safari Lodge',
      'Diani Beach': 'Beach Resort',
      'Mount Kenya': 'Mountain Hotel',
      'Nairobi': 'City Hotel',
      'Lamu': 'Boutique Stay'
    };
    return types[placeName] ?? 'Hotel';
  }

  List<String> _getAccommodationAmenities(String placeName) {
    final amenities = {
      'Maasai Mara': ['Pool', 'Restaurant', 'Game drives', 'Spa'],
      'Diani Beach': ['Beachfront', 'Pool', 'Water sports', 'Restaurant'],
      'Mount Kenya': ['Mountain views', 'Hiking trails', 'Restaurant', 'Free WiFi'],
      'Nairobi': ['Business center', 'Restaurant', 'Gym', 'Airport shuttle'],
      'Lamu': ['Sea view', 'Traditional design', 'Restaurant', 'Cultural tours']
    };
    return amenities[placeName] ?? ['Free WiFi', 'Restaurant', 'Air conditioning', 'Parking'];
  }

  String _getPriceRange(String placeName) {
    final prices = {
      'Maasai Mara': 'KSh 12,000/night',
      'Diani Beach': 'KSh 15,000/night',
      'Mount Kenya': 'KSh 8,000/night',
      'Nairobi': 'KSh 7,500/night',
      'Lamu': 'KSh 9,000/night'
    };
    return prices[placeName] ?? 'KSh 5,000/night';
  }

  List<String> _getAccommodationTags(String placeName) {
    final tags = {
      'Maasai Mara': ['Safari', 'Wildlife', 'Luxury'],
      'Diani Beach': ['Beachfront', 'Family-friendly', 'All-inclusive'],
      'Mount Kenya': ['Mountain view', 'Nature', 'Hiking'],
      'Nairobi': ['Business', 'City center', 'Airport transfer'],
      'Lamu': ['Historic', 'Cultural', 'Romantic']
    };
    return tags[placeName] ?? ['Comfortable', 'Clean', 'Convenient'];
  }
}

// Reusing components from restaurant.dart with slight modifications

class _VideoCard extends StatelessWidget {
  final Map<String, dynamic> video;

  const _VideoCard({
    super.key,
    required this.video,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      width: 270,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),      child: InkWell(
        onTap: () {
          // Create a detailed item for the action sheet
          final item = {
            'title': video['title'],
            'description': 'Video Tour',
            'image': video['image'],
            'price': 'From KSh 5,000/night',
            'coordinates': {'lat': -1.286389, 'lng': 36.817223},
            'tags': ['Video Tour', 'Accommodation'],
            'address': 'Kenya',
            'amenities': ['Virtual Tour Available'],
          };
          showAccommodationActionSheet(context, item);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),                  child: Image.asset(
                    video['image'] ?? 'assets/images/placeholder.jpeg',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.6, 1.0],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: AppTheme.primaryColor,
                        size: 36,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),                    child: Text(
                      video['duration'] ?? '0:00',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [                  Text(
                    video['title'] ?? 'Video',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [                      Text(
                        video['creator'] ?? 'Creator',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                      if ((video['verified'] as bool?) ?? false)
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.verified,
                            size: 14,
                            color: Colors.blue[700],
                          ),
                        ),
                      const Spacer(),
                      Icon(
                        Icons.visibility_outlined,
                        size: 14,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 4),                      Text(
                        video['views'] ?? '0',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
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
}

class _PackageCard extends StatelessWidget {
  final Map<String, dynamic> package;

  const _PackageCard({
    super.key,
    required this.package,
  });

  void _showMapPreview(BuildContext context, Map<String, dynamic> place) {
    // Define default coordinates for Kenya if not available
    final LatLng defaultLocation = LatLng(-1.286389, 36.817223); // Nairobi
    final MapController mapController = MapController();

    // Convert place coordinates or use default
    LatLng coordinates = defaultLocation;
    if (place['coordinates'] != null) {
      try {
        // Handle different coordinate formats (Map or String)
        var lat = place['coordinates'] is Map 
          ? place['coordinates']['lat'] 
          : 0.0;
        var lng = place['coordinates'] is Map 
          ? place['coordinates']['lng'] 
          : 0.0;
          
        // Convert to double if needed
        final double latValue = lat is double ? lat : double.tryParse(lat.toString()) ?? -1.286389;
        final double lngValue = lng is double ? lng : double.tryParse(lng.toString()) ?? 36.817223;
        
        if (latValue != 0.0 && lngValue != 0.0) {
          coordinates = LatLng(latValue, lngValue);
        }
      } catch (e) {
        print('Error parsing coordinates: $e');
        // Keep using default coordinates
      }
    }

    // Generate nearby amenities for map display
    final nearbyPlaces = [
      {
        'name': 'Restaurant',
        'coordinates': LatLng(coordinates.latitude + 0.005, coordinates.longitude + 0.003),
        'type': 'restaurant',
      },
      {
        'name': 'Café',
        'coordinates': LatLng(coordinates.latitude - 0.003, coordinates.longitude + 0.002),
        'type': 'cafe',
      },
      {
        'name': 'Shops',
        'coordinates': LatLng(coordinates.latitude + 0.002, coordinates.longitude - 0.004),
        'type': 'shop',
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 5,
              width: 40,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location: ${place['title']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          place['location'] ?? 'Kenya',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        initialCenter: coordinates,
                        initialZoom: 14,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.triperry.app',
                        ),
                        MarkerLayer(
                          markers: [
                            // Main location marker
                            Marker(
                              point: coordinates,
                              width: 100,
                              height: 80,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.hotel,
                                          color: AppTheme.primaryColor,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),                                        Text(
                                          (place['title'] ?? 'Location')
                                              .toString()
                                              .split(' ')
                                              .first,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.location_pin,
                                    color: AppTheme.primaryColor,
                                    size: 36,
                                  ),
                                ],
                              ),
                            ),

                            // Nearby places markers
                            ...nearbyPlaces.map((place) {
                              return Marker(
                                point: place['coordinates'] as LatLng,
                                width: 80,
                                height: 60,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(8),
                                      ),                                      child: Text(
                                        (place['name'] ?? 'Place').toString(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ),                                    Icon(
                                      (place['type'] ?? '') == 'cafe'
                                          ? Icons.coffee
                                          : (place['type'] ?? '') == 'shop'
                                              ? Icons.shopping_bag
                                              : Icons.restaurant,
                                      color: Colors.amber[700],
                                      size: 28,
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      icon: const Icon(Icons.directions),
                      label: const Text('Open in Google Maps'),
                      onPressed: () async {
                        final url = Uri.parse(
                          'https://www.google.com/maps/search/?api=1&query=${coordinates.latitude},${coordinates.longitude}',
                        );

                        try {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not open maps. Error: $e')),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230, // Fixed height to prevent layout issues
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),      child: InkWell(
        onTap: () {
          // Create a detailed package item for the action sheet
          final itemDetails = {
            'title': package['title'],
            'description': package['description'] ?? 'Special accommodation package',
            'image': package['image'],
            'price': package['price'] ?? 'Contact for pricing',
            'coordinates': package['coordinates'] ?? {'lat': -1.286389, 'lng': 36.817223},
            'tags': ['Special Offer', 'Package Deal', package['badge'] ?? ''],
            'address': package['location'] ?? 'Kenya',
            'amenities': ['All-inclusive package', 'Special offers', 'Premium services'],
            'rating': package['rating'] ?? 4.5,
          };
          showAccommodationActionSheet(context, itemDetails);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),                  child: Image.asset(
                    package['image'] ?? 'assets/images/placeholder.jpeg',
                    height: 115,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Gradient overlay for visual depth
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                        stops: const [0.7, 1.0],
                      ),
                    ),
                  ),
                ),
                if (package['discount'] != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red[700],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        package['discount'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Location badge
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          package['location'] ?? 'Kenya',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Badge
                if ((package['badge'] ?? '').isNotEmpty)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryColor.withOpacity(0.8),
                            Colors.amber.withOpacity(0.7)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        package['badge'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package['title'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      package['description'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber[700],
                            ),
                            const SizedBox(width: 2),
                            Text(
                              package['rating'].toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (package['reviews'] != null) ...[
                              const SizedBox(width: 4),
                              Text(
                                '(${package['reviews']})',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              package['price'],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 6),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.map, size: 14),
                              label: const Text(
                                'Map',
                                style: TextStyle(fontSize: 12),
                              ),
                              onPressed: () {
                                _showMapPreview(context, package);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Add other components needed (_AnimatedTrendingList, _AutoRotatingCarousel, etc.) with appropriate modifications for Accommodation page
// I'll include just a few key ones here but you can repurpose the rest from restaurant.dart as needed

class _AnimatedTrendingList extends StatefulWidget {
  final List<Map<String, dynamic>> allCategories;
  const _AnimatedTrendingList({super.key, required this.allCategories});

  @override
  State<_AnimatedTrendingList> createState() => _AnimatedTrendingListState();
}

class _AnimatedTrendingListState extends State<_AnimatedTrendingList> {
  late List<int> visibleIndices;
  int rotatingSlot = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    visibleIndices = List.generate(3, (i) => i % widget.allCategories.length);
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) return;
      setState(() {
        visibleIndices[rotatingSlot] =
            (visibleIndices[rotatingSlot] + 3) % widget.allCategories.length;
        rotatingSlot = (rotatingSlot + 1) % 3;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final category = widget.allCategories[visibleIndices[index]];
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: _TrendingCategoryCard(
              key: ValueKey(visibleIndices[index]),
              category: category,
            ),
          );
        },
      ),
    );
  }
}

class _TrendingCategoryCard extends StatelessWidget {
  final Map<String, dynamic> category;
  const _TrendingCategoryCard({super.key, required this.category});
  @override
  Widget build(BuildContext context) {    return GestureDetector(
      onTap: () {
        // Show category options using the type sheet
        showAccommodationTypeSheet(context, category['title']);
      },
      child: Container(
        height: 104,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(11)),
            child: Image.asset(
              category['image'],
              width: 120,
              height: 104,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          category['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.trending_up,
                              size: 14,
                              color: AppTheme.primaryColor,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Popular',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    category['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  _buildAmenitiesTicker(category['activities']),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

Widget _buildAmenitiesTicker(List<dynamic> amenities) {
  return SizedBox(
    height: 24,
    child: LayoutBuilder(builder: (context, constraints) {
      final double availableWidth = constraints.maxWidth;
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(seconds: 10),
        curve: Curves.linear,
        builder: (context, value, child) {
          if (value == 1) {
            Future.microtask(() {
              if (context.mounted) {
                (context as Element).markNeedsBuild();
              }
            });
          }
          return Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRect(
                child: SizedBox(
                  width: availableWidth,
                  child: Text(
                    amenities[((amenities.length) * value).floor() %
                        amenities.length],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }),
  );
}

class _AutoRotatingCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> carouselItems;

  const _AutoRotatingCarousel({required this.carouselItems});

  @override
  State<_AutoRotatingCarousel> createState() => __AutoRotatingCarouselState();
}

class __AutoRotatingCarouselState extends State<_AutoRotatingCarousel> {
  late PageController _controller;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_controller.hasClients) {
        final nextPage =
            (_controller.page!.toInt() + 1) % widget.carouselItems.length;
        _controller.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.carouselItems.length,
              itemBuilder: (context, index) {
                final item = widget.carouselItems[index];                return GestureDetector(
                  onTap: () {
                    // Create detailed item for action sheet
                    final detailedItem = {
                      'title': item['title'],
                      'description': item['subtitle'],
                      'image': item['image'],
                      'price': 'From KSh 5,000/night',
                      'rating': 4.5,
                      'coordinates': {'lat': -1.286389, 'lng': 36.817223},
                      'tags': ['Featured', 'Recommended'],
                      'address': 'Kenya',
                      'amenities': ['Premium Service', 'Luxury Accommodation'],
                    };
                    showAccommodationActionSheet(context, detailedItem);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            item['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 24,
                          left: 16,
                          right: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Text(
                                item['subtitle'],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: item['isAd']
                                  ? Colors.black54
                                  : AppTheme.primaryColor.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!item['isAd'])
                                  const Icon(
                                    Icons.auto_awesome,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                if (!item['isAd']) const SizedBox(width: 4),
                                Text(
                                  item['isAd'] ? 'Ad' : 'AI Recommended',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: SmoothPageIndicator(
              controller: _controller,
              count: widget.carouselItems.length,
              effect: WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                type: WormType.thin,
                activeDotColor: AppTheme.primaryColor,
                dotColor: Colors.grey.shade300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendedCarouselList extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  const _RecommendedCarouselList({required this.items});

  @override
  State<_RecommendedCarouselList> createState() =>
      _RecommendedCarouselListState();
}

class _RecommendedCarouselListState extends State<_RecommendedCarouselList> {
  int _currentPage = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  void _showActionSheet(BuildContext context, Map<String, dynamic> item) {
    showAccommodationActionSheet(context, item);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final item = widget.items[index];
              // Prepare safe item with all necessary data
              final safeItem = {
                'name': item['title'] ?? 'Unknown Accommodation',
                'type': item['description'] ?? 'Accommodation',
                'image': item['image'] ?? 'assets/images/placeholder.jpeg',
                'rating': item['rating'] ?? 4.0,
                'priceRange': item['price'] ?? 'KSh 5,000/night',
                'price': item['price'] ?? 'KSh 5,000/night',
                'description': item['description'] ?? 'A comfortable place to stay.',
                'coordinates': item['coordinates'] ?? {'lat': -1.286389, 'lng': 36.817223},
                'tags': item['tags'] ?? ['Comfortable', 'Clean'],
                'address': item['location'] ?? 'Kenya',
                'location': item['coordinates'] ?? {'lat': -1.286389, 'lng': 36.817223},
                'title': item['title'] ?? 'Unknown Accommodation',
                'amenities': ['Free WiFi', 'Parking', 'Restaurant', 'Swimming Pool'],
                'rooms': [
                  {
                    'name': 'Standard Room',
                    'price': 'KSh 5,000/night',
                    'capacity': '2 guests',
                    'description': 'Comfortable room with essential amenities',
                    'image': item['image']
                  },
                  {
                    'name': 'Deluxe Room',
                    'price': 'KSh 8,000/night',
                    'capacity': '2 guests',
                    'description': 'Spacious room with premium amenities',
                    'image': item['image']
                  },
                ]
              };
              
              return AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.ease,
                margin: EdgeInsets.symmetric(
                    horizontal: 8, vertical: _currentPage == index ? 0 : 2),
                child: _RecommendedCard(
                  item: safeItem,
                  onTap: () => _showActionSheet(context, safeItem),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < widget.items.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: _currentPage == i ? 24 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == i
                      ? AppTheme.primaryColor
                      : Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;
  const _RecommendedCard({required this.item, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Image.asset(
                    item['image'],
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            item['rating'].toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['description'],
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final tag in item['tags'])
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 11,
                                color: AppTheme.primaryColor.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['price'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.bed_outlined,
                                color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text('Book Now',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                          ],
                        ),
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
}