import 'package:flutter/material.dart';
import 'package:triperry/theme/app_theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../services/kenya_places_data.dart';
import '../../../../services/kenya_restaurants_data.dart';
import 'restaurant_detail_screen.dart';
import 'cuisine_restaurants_sheet.dart';

void showCuisineRestaurants(BuildContext context, String cuisineType) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CuisineRestaurantsSheet(cuisineType: cuisineType),
  );
}

class Restaurant extends StatefulWidget {
  const Restaurant({super.key});

  @override
  State<Restaurant> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<Restaurant> {
  @override
  Widget build(BuildContext context) {
    return buildRestaurantContent();
  }

  Widget buildRestaurantContent() {
    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 80),
      children: [
        _buildCarouselSection(),
        const SizedBox(height: 24),
        _buildSectionTitle('Popular Cuisines'),
        const SizedBox(height: 16),
        _buildTrendingSection(),
        const SizedBox(height: 24),
        _buildSectionTitle('Recommended Restaurants'),
        const SizedBox(height: 16),
        _buildRecommendedSection(),
        const SizedBox(height: 24),
        _buildSectionTitleWithViewAll('Food Spotlights'),
        const SizedBox(height: 16),
        _buildTrendingVideosSection(),
        const SizedBox(height: 24),
        _buildSectionTitleWithViewAll('Dining Deals'),
        const SizedBox(height: 16),
        _buildTrendingPackagesList(),
        const SizedBox(height: 32), // Extra padding at the bottom
      ],
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
              'title': '${_getRestaurantName(place['name'])}',
              'subtitle': '${_getCuisineType(place['name'])} cuisine',
              'isAd': false,
            })
        .toList();
    return _AutoRotatingCarousel(carouselItems: carouselItems);
  }

  Widget _buildTrendingSection() {
    final allCategories = kenyaDestinations
        .take(5)
        .map((place) => {
              'title': _getCuisineType(place['name']),
              'description':
                  'Top ${_getCuisineType(place['name'])} restaurants',
              'image': place['image'],
              'activities': _getPopularDishes(place['name']),
            })
        .toList();
    return _AnimatedTrendingList(allCategories: allCategories);
  }

  Widget _buildRestaurantCard(int index) {
    List<Map<String, dynamic>> RestaurantItems = [
      {
        'title': 'Maasai Mara Safari',
        'description': 'Experience the great migration',
        'image': 'assets/images/kenya safari.jpeg',
        'price': 'From \$120/day',
      },
      {
        'title': 'Diani Beach Resort',
        'description': 'Relax on white sandy beaches',
        'image': 'assets/images/diani beach.png',
        'price': 'From \$95/night',
      },
      {
        'title': 'Mt. Kenya Expedition',
        'description': 'Climb Kenya\'s highest peak',
        'image': 'assets/images/mount kenya.png',
        'price': 'From \$200/person',
      },
      {
        'title': 'Nairobi City Tour',
        'description': 'Explore Kenya\'s vibrant capital',
        'image': 'assets/images/nairobi city skyline.png',
        'price': 'From \$45/person',
      },
      {
        'title': 'Lamu Old Town',
        'description': 'Discover historical Swahili culture',
        'image': 'assets/images/lamu old town.png',
        'price': 'From \$75/day',
      },
    ];

    final itemIndex = index % RestaurantItems.length;
    final item = RestaurantItems[itemIndex];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: () {
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: Text(item['title'])),
              body: Center(child: Text('Details for ${item['title']}')),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                item['image'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['price'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.visibility),
                        label: const Text('View'),
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Viewing all $title')),
              );
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
              'title': place['name'] + ' Experience',
              'duration': '4:00',
              'views': '${place['reviews']}+',
              'image': place['image'],
              'creator': 'Kenya Explorer',
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
  Widget _buildRecommendedSection() {
    // Use real restaurant data when available
    List<Map<String, dynamic>> recommendedItems = [];
    
    // First try to get top-rated restaurants from our real data
    if (KenyaRestaurantsData.restaurants.isNotEmpty) {
      // Sort by rating (highest first) and take top 5
      final sortedRestaurants = List.from(KenyaRestaurantsData.restaurants)
        ..sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
      
      for (var restaurant in sortedRestaurants.take(5)) {
        recommendedItems.add({
          'title': restaurant['name'],
          'description': '${restaurant['cuisineType']} dining experience',
          'image': restaurant['image'], // Placeholder image path
          'price': restaurant['priceRange'],
          'tags': List<String>.from(restaurant['tags']),
          'rating': restaurant['rating'],
          'location': restaurant['address'],
          'coordinates': {
            'lat': restaurant['location']['lat'],
            'lng': restaurant['location']['lng'],
          },
        });
      }
    }
    
    // If we don't have enough real restaurants, supplement with our original data
    if (recommendedItems.length < 5) {
      final originalRecommended = kenyaDestinations
          .take(5 - recommendedItems.length)
          .map((place) => {
                'title': _getRestaurantName(place['name']),
                'description': '${_getCuisineType(place['name'])} dining experience',
                'image': place['image'],
                'price': 'From ${_getPriceRange(place['name'])}',
                'tags': _getRestaurantTags(place['name']),
                'rating': place['rating'],
                'location': place['address'] ?? 'Kenya',
                'coordinates': _getRestaurantCoordinates(
                    _getRestaurantName(place['name']), place['name']),
              })
          .toList();
      
      recommendedItems.addAll(originalRecommended);
    }
    
    return SizedBox(
      height: 320,
      child: _RecommendedCarouselList(items: recommendedItems),
    );
  }
  // Helper method to get restaurant coordinates using real restaurant data
  Map<String, double> _getRestaurantCoordinates(
      String restaurantName, String locationName) {
    // Try to find matching restaurant in our real data
    for (var restaurant in KenyaRestaurantsData.restaurants) {
      if (restaurant['name'].toString().toLowerCase().contains(restaurantName.toLowerCase()) ||
          restaurantName.toLowerCase().contains(restaurant['name'].toString().toLowerCase())) {
        return {
          'lat': restaurant['location']['lat'],
          'lng': restaurant['location']['lng'],
        };
      }
    }

    // Fall back to previous dummy data if no match found
    final coordinates = {
      'Savannah Grill': {'lat': -1.286389, 'lng': 36.817223}, // Nairobi
      'Ocean Breeze': {'lat': -4.277, 'lng': 39.591}, // Diani Beach
      'Highland Bistro': {'lat': -0.152, 'lng': 37.3}, // Mt Kenya
      'Urban Eats': {'lat': -1.312, 'lng': 36.817}, // Nairobi
      'Coastal Kitchen': {'lat': -2.269, 'lng': 40.902}, // Lamu
    };

    if (coordinates.containsKey(restaurantName)) {
      return {
        'lat': coordinates[restaurantName]!['lat']!,
        'lng': coordinates[restaurantName]!['lng']!,
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
                  ? 'Best Seller'
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
  // Helper methods for restaurant data - using real restaurant information when available
  String _getRestaurantName(String placeName) {
    // First check if we have a real restaurant with a similar name
    for (var restaurant in KenyaRestaurantsData.restaurants) {
      if (restaurant['name'].toString().toLowerCase().contains(placeName.toLowerCase()) ||
          placeName.toLowerCase().contains(restaurant['name'].toString().toLowerCase())) {
        return restaurant['name'];
      }
    }
    
    // Fall back to our original mapping if no match
    final names = {
      'Maasai Mara': 'Savannah Grill',
      'Diani Beach': 'Ocean Breeze',
      'Mount Kenya': 'Highland Bistro',
      'Nairobi': 'Urban Eats',
      'Lamu': 'Coastal Kitchen'
    };
    return names[placeName] ?? '$placeName Restaurant';
  }

  String _getCuisineType(String placeName) {
    // First check if we have a real restaurant with a similar name
    for (var restaurant in KenyaRestaurantsData.restaurants) {
      if (restaurant['name'].toString().toLowerCase().contains(placeName.toLowerCase()) ||
          placeName.toLowerCase().contains(restaurant['name'].toString().toLowerCase())) {
        return restaurant['cuisineType'];
      }
    }
    
    // Fall back to our original mapping if no match
    final cuisines = {
      'Maasai Mara': 'African',
      'Diani Beach': 'Seafood',
      'Mount Kenya': 'Traditional',
      'Nairobi': 'International',
      'Lamu': 'Swahili'
    };
    return cuisines[placeName] ?? 'Kenyan';
  }

  List<String> _getPopularDishes(String placeName) {
    // First check if we have a real restaurant with a similar name
    for (var restaurant in KenyaRestaurantsData.restaurants) {
      if (restaurant['name'].toString().toLowerCase().contains(placeName.toLowerCase()) ||
          placeName.toLowerCase().contains(restaurant['name'].toString().toLowerCase())) {
        return List<String>.from(restaurant['popularDishes']);
      }
    }
    
    // Fall back to our original mapping if no match
    final dishes = {
      'Maasai Mara': ['Nyama Choma', 'Ugali', 'Sukuma Wiki'],
      'Diani Beach': ['Grilled Fish', 'Coconut Rice', 'Seafood Platter'],
      'Mount Kenya': ['Mukimo', 'Githeri', 'Irio'],
      'Nairobi': ['Fusion Cuisine', 'Modern Kenyan', 'Global Flavors'],
      'Lamu': ['Pilau', 'Biryani', 'Coconut Curry'],
      'Maasai Mara National Reserve': ['Nyama Choma', 'Ugali', 'Sukuma Wiki'],
      'Nairobi National Park': ['Fusion Cuisine', 'Modern Kenyan', 'Global Flavors'],
      'Lamu Old Town': ['Pilau', 'Biryani', 'Coconut Curry']
    };
    return dishes[placeName] ?? ['Chef Special', 'Local Favorite', 'House Dish'];
  }

  String _getPriceRange(String placeName) {
    // First check if we have a real restaurant with a similar name
    for (var restaurant in KenyaRestaurantsData.restaurants) {
      if (restaurant['name'].toString().toLowerCase().contains(placeName.toLowerCase()) ||
          placeName.toLowerCase().contains(restaurant['name'].toString().toLowerCase())) {
        return restaurant['priceRange'];
      }
    }
    
    // Fall back to our original mapping if no match
    final prices = {
      'Maasai Mara': 'KSh 800-1500',
      'Diani Beach': 'KSh 1000-2000',
      'Mount Kenya': 'KSh 600-1200',
      'Nairobi': 'KSh 500-2500',
      'Lamu': 'KSh 700-1800',
      'Maasai Mara National Reserve': 'KSh 800-1500',
      'Nairobi National Park': 'KSh 500-2500',
      'Lamu Old Town': 'KSh 700-1800'
    };
    return prices[placeName] ?? 'KSh 500-2000';
  }

  List<String> _getRestaurantTags(String placeName) {
    // First check if we have a real restaurant with a similar name
    for (var restaurant in KenyaRestaurantsData.restaurants) {
      if (restaurant['name'].toString().toLowerCase().contains(placeName.toLowerCase()) ||
          placeName.toLowerCase().contains(restaurant['name'].toString().toLowerCase())) {
        return List<String>.from(restaurant['tags']);
      }
    }
    
    // Fall back to our original mapping if no match
    final tags = {
      'Maasai Mara': ['Outdoor', 'BBQ', 'Traditional'],
      'Diani Beach': ['Beachfront', 'Seafood', 'Romantic'],
      'Mount Kenya': ['Mountain View', 'Organic', 'Healthy'],
      'Nairobi': ['Fine Dining', 'Trendy', 'Cocktails'],
      'Lamu': ['Historic', 'Spicy', 'Cultural'],
      'Maasai Mara National Reserve': ['Outdoor', 'BBQ', 'Traditional'],
      'Nairobi National Park': ['Fine Dining', 'Trendy', 'Cocktails'],
      'Lamu Old Town': ['Historic', 'Spicy', 'Cultural']
    };
    return tags[placeName] ?? ['Popular', 'Local', 'Authentic'];
  }
}

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
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () {
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: Text(video['title'])),
              body: Center(child: Text('Playing ${video['title']}')),
            ),
          );
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
                  ),
                  child: Image.asset(
                    video['image'],
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
                    ),
                    child: Text(
                      video['duration'],
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
                children: [
                  Text(
                    video['title'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        video['creator'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                      if (video['verified'])
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
                      const SizedBox(width: 4),
                      Text(
                        video['views'],
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
    LatLng coordinates = defaultLocation;    if (place['coordinates'] != null) {
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
    } else {
      // Simulate coordinates based on location name
      // In a real app, these would come from a geocoding service
      switch (place['title']) {
        case 'Maasai Mara National Reserve':
          coordinates = LatLng(-1.5, 35.1);
          break;
        case 'Diani Beach':
          coordinates = LatLng(-4.277, 39.591);
          break;
        case 'Mount Kenya':
          coordinates = LatLng(-0.152, 37.3);
          break;
        case 'Nairobi National Park':
          coordinates = LatLng(-1.312, 36.817);
          break;
        case 'Lamu Old Town':
          coordinates = LatLng(-2.269, 40.902);
          break;
      }
    }    // Generate nearby restaurants for map display using real restaurant data
    final nearbyPlaces = [];
    
    // Find 2-3 restaurants that are relatively close to the chosen coordinates
    for (var restaurant in KenyaRestaurantsData.restaurants.take(10)) {
      // Skip if it's the same restaurant
      if (place['title'].toString().toLowerCase().contains(restaurant['name'].toString().toLowerCase()) ||
          restaurant['name'].toString().toLowerCase().contains(place['title'].toString().toLowerCase())) {
        continue;
      }
      
      // Calculate rough distance (this is just for prototype)
      final restaurantLat = restaurant['location']['lat'];
      final restaurantLng = restaurant['location']['lng'];
      final latDiff = (restaurantLat - coordinates.latitude).abs();
      final lngDiff = (restaurantLng - coordinates.longitude).abs();
      
      // If relatively close (within ~5km), add to nearby places
      if (latDiff < 0.05 && lngDiff < 0.05) {
        nearbyPlaces.add({
          'name': restaurant['name'],
          'coordinates': LatLng(restaurantLat, restaurantLng),
          'type': restaurant['types'].contains('bar') ? 'cafe' : 'restaurant',
        });
      }
      
      // Limit to 3 nearby places
      if (nearbyPlaces.length >= 3) break;
    }
    
    // If no nearby places found, add some generic ones
    if (nearbyPlaces.isEmpty) {
      nearbyPlaces.addAll([
        {
          'name': 'Nearby Restaurant',
          'coordinates': LatLng(coordinates.latitude + 0.005, coordinates.longitude + 0.003),
          'type': 'restaurant',
        },
        {
          'name': 'Coffee Shop',
          'coordinates': LatLng(coordinates.latitude - 0.003, coordinates.longitude + 0.002),
          'type': 'cafe',
        },
        {
          'name': 'Food Court',
          'coordinates': LatLng(coordinates.latitude + 0.002, coordinates.longitude - 0.004),
          'type': 'food_stall',
        },
      ]);
    }
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
                                          Icons.restaurant,
                                          color: AppTheme.primaryColor,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          place['title']
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
                              // Convert to LatLng if needed, with null safety
                              LatLng pointCoords;
                              final coords = place['coordinates'];
                              if (coords is LatLng) {
                                pointCoords = coords;
                              } else if (coords is Map) {
                                final lat = coords['lat'];
                                final lng = coords['lng'];
                                pointCoords = LatLng(
                                  lat is double ? lat : double.tryParse(lat?.toString() ?? '') ?? -1.286389,
                                  lng is double ? lng : double.tryParse(lng?.toString() ?? '') ?? 36.817223,
                                );
                              } else {
                                // fallback to Nairobi
                                pointCoords = LatLng(-1.286389, 36.817223);
                              }
                              return Marker(
                                point: pointCoords,
                                width: 80,
                                height: 60,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        (place['name'] ?? '').toString().split(' ').first,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      place['type'] == 'cafe'
                                          ? Icons.coffee
                                          : place['type'] == 'food_stall'
                                              ? Icons.fastfood
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
      ),
      child: InkWell(        onTap: () {
          final safePackage = {
            'name': package['title'] ?? 'Unknown Restaurant',
            'cuisine': package['description'] ?? 'Cuisine',
            'image': package['image'] ?? 'assets/images/placeholder.jpeg',
            'rating': package['rating'] ?? 4.0,
            'priceRange': package['price'] ?? 'KSh 500-1200',
            'description': package['description'] ?? 'A delightful restaurant.',
            'coordinates': package['coordinates'] ?? {'lat': -1.286389, 'lng': 36.817223},
            'tags': package['tags'] ?? ['Popular', 'Local'],
            'address': package['location'] ?? 'Kenya',
            'location': package['coordinates'] ?? {'lat': -1.286389, 'lng': 36.817223},
            'title': package['title'] ?? 'Unknown Restaurant', // Add title field
          };
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestaurantDetailScreen(restaurant: safePackage),
            ),
          );
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
                  ),
                  child: Image.asset(
                    package['image'],
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
                // Location badge - similar to TripAdvisor's location indicators
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
                // BADGE: Only show if present, and must be in the Stack!
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Show a bottom sheet with restaurants of this cuisine type
        showCuisineRestaurants(context, category['title']);
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
                  _buildActivitiesTicker(category['activities']),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

Widget _buildActivitiesTicker(List<dynamic> activities) {
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
                    activities[((activities.length) * value).floor() %
                        activities.length],
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

  const _AutoRotatingCarousel({super.key, required this.carouselItems});

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
                    final restaurantData = {
                      'name': item['title'] ?? 'Unknown Restaurant',
                      'cuisine': item['subtitle'] ?? 'Cuisine',
                      'image': item['image'] ?? 'assets/images/placeholder.jpeg',
                      'rating': 4.5,
                      'priceRange': 'KSh 800-1500',
                      'description': 'Featuring unique ${item['subtitle'] ?? 'Kenyan'} dishes in a welcoming atmosphere.',
                      'coordinates': {'lat': -1.286389, 'lng': 36.817223},
                      'title': item['title'] ?? 'Unknown Restaurant', // Add title field
                    };
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestaurantDetailScreen(
                          restaurant: restaurantData,
                        ),
                      ),
                    );
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
                                  item['isAd'] ? 'Ad' : 'AI',
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
              return AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.ease,
                margin: EdgeInsets.symmetric(
                    horizontal: 8, vertical: _currentPage == index ? 0 : 2),                child: _RecommendedCard(
                  item: item,
                  onTap: () {
                    final safeItem = {
                      'name': item['title'] ?? 'Unknown Restaurant',
                      'cuisine': item['description'] ?? 'Cuisine',
                      'image': item['image'] ?? 'assets/images/placeholder.jpeg',
                      'rating': item['rating'] ?? 4.0,
                      'priceRange': item['price'] ?? 'KSh 500-1200',
                      'description': item['description'] ?? 'A delightful restaurant.',
                      'coordinates': item['coordinates'] ?? {'lat': -1.286389, 'lng': 36.817223},
                      'tags': item['tags'] ?? ['Popular', 'Local'],
                      'address': item['location'] ?? 'Kenya',
                      'location': item['coordinates'] ?? {'lat': -1.286389, 'lng': 36.817223},
                      'title': item['title'] ?? 'Unknown Restaurant', // Add title field
                    };
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestaurantDetailScreen(
                          restaurant: safeItem,
                        ),
                      ),
                    );
                  },
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

  void _showActionSheet(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _RecommendedActionSheet(item: item),
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
      ),      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          final safeItem = {
            'name': item['title'] ?? 'Unknown Restaurant',
            'cuisine': item['description'] ?? 'Cuisine',
            'image': item['image'] ?? 'assets/images/placeholder.jpeg',
            'rating': item['rating'] ?? 4.0,
            'priceRange': item['price'] ?? 'KSh 500-1200',
            'description': item['description'] ?? 'A delightful restaurant.',
            'coordinates': item['coordinates'] ?? {'lat': -1.286389, 'lng': 36.817223},
            'tags': item['tags'] ?? ['Popular', 'Local'],
            'address': item['location'] ?? 'Kenya',
            'location': item['coordinates'] ?? {'lat': -1.286389, 'lng': 36.817223},
            'title': item['title'] ?? 'Unknown Restaurant', // Add title field
          };
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestaurantDetailScreen(restaurant: safeItem),
            ),
          );
        },
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
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.visibility_outlined,
                                color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text('Explore',
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

class _RecommendedActionSheet extends StatelessWidget {
  final Map<String, dynamic> item;
  const _RecommendedActionSheet({required this.item});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5,
            width: 40,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Text(
            item['title'],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _ActionButton(
            icon: Icons.bookmark_outline,
            text: 'Save to Favorites',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item['title']} saved to favorites')),
              );
            },
          ),
          _ActionButton(
            icon: Icons.chat_outlined,
            text: 'Ask AI About This Place',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('AI answering about ${item['title']}')),
              );
            },
          ),
          _ActionButton(
            icon: Icons.share_outlined,
            text: 'Share with Friends',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Sharing ${item['title']} with friends')),
              );
            },
          ),
          _ActionButton(
            icon: Icons.calendar_today_outlined,
            text: 'Plan a Trip Here',
            onTap: () {
              Navigator.pop(context);
              MaterialPageRoute(builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Plan a Trip'),
                  ),
                  body: Center(
                    child: Text('Planning a trip to ${item['title']}'),
                  ),
                );
              });
            },
          ),
          _ActionButton(
            icon: Icons.map_outlined,
            text: 'View on Map',
            onTap: () {
              Navigator.pop(context);

              // Use actual coordinates if available, otherwise default to Nairobi
              LatLng coordinates;
              if (item['coordinates'] != null &&
                  item['coordinates']['lat'] != null &&
                  item['coordinates']['lng'] != null) {
                coordinates = LatLng(
                  item['coordinates']['lat'],
                  item['coordinates']['lng'],
                );
              } else {
                // Default Nairobi coordinates
                coordinates = LatLng(-1.286389, 36.817223);
              }

              // Define nearby restaurants for enhanced map experience
              final nearbyPlaces = [
                {
                  'name': '${item['title']} - Branch 2',
                  'coordinates': LatLng(coordinates.latitude + 0.005,
                      coordinates.longitude + 0.003),
                  'type': 'restaurant',
                  'rating': (item['rating'] != null)
                      ? (item['rating'] as double) - 0.2
                      : 4.3,
                },
                {
                  'name': 'Café ${item['title'].toString().split(' ').first}',
                  'coordinates': LatLng(coordinates.latitude - 0.002,
                      coordinates.longitude + 0.006),
                  'type': 'cafe',
                  'rating': (item['rating'] != null)
                      ? (item['rating'] as double) - 0.4
                      : 4.1,
                },
                {
                  'name': 'Local Street Food',
                  'coordinates': LatLng(coordinates.latitude + 0.004,
                      coordinates.longitude - 0.004),
                  'type': 'food_stall',
                  'rating': 4.0,
                },
              ];

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  // Controller for map zooming
                  final MapController mapController = MapController();

                  return Container(
                    height: MediaQuery.of(context).size.height *
                        0.8, // Make it larger
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(24)),
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
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Location: ${item['title']}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Address: ${item['location'] ?? 'Kenya'}',
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
                                        // Main restaurant marker
                                        Marker(
                                          point: coordinates,
                                          width: 120,
                                          height: 90,
                                          child: Column(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.2),
                                                      blurRadius: 4,
                                                      offset:
                                                          const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons.restaurant,
                                                      color:
                                                          AppTheme.primaryColor,
                                                      size: 14,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      item['title'],
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppTheme
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Icon(
                                                Icons.location_pin,
                                                color: AppTheme.primaryColor,
                                                size: 42,
                                              ),
                                            ],
                                          ),
                                        ),                                        // Nearby places markers
                                        ...nearbyPlaces.map((place) {                                              // Convert to LatLng if needed
                                              LatLng pointCoords;
                                              if (place['coordinates'] is LatLng) {
                                                pointCoords = place['coordinates'] as LatLng;
                                              } else {
                                                try {
                                                  // Handle Map format with null safety
                                                  var coords = place['coordinates'];
                                                  if (coords is Map) {
                                                    final lat = coords['lat'];
                                                    final lng = coords['lng'];
                                                    
                                                    // Convert to double with safe null handling
                                                    final double latValue = lat is double ? lat : 
                                                        (lat != null ? double.tryParse(lat.toString()) ?? -1.286389 : -1.286389);
                                                    final double lngValue = lng is double ? lng : 
                                                        (lng != null ? double.tryParse(lng.toString()) ?? 36.817223 : 36.817223);
                                                    
                                                    pointCoords = LatLng(latValue, lngValue);
                                                  } else {
                                                    // Default to Nairobi if coordinates structure is unexpected
                                                    pointCoords = LatLng(-1.286389, 36.817223);
                                                    print('Unexpected coordinates format: $coords');
                                                  }
                                                } catch (e) {
                                                  // Handle any unexpected errors gracefully
                                                  pointCoords = LatLng(-1.286389, 36.817223);
                                                  print('Error parsing restaurant coordinates: $e');
                                                }
                                              }
                                              return Marker(
                                                point: pointCoords,
                                                width: 80,
                                                height: 60,
                                                child: Column(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 4,
                                                        vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.9),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Text(
                                                      place['name']
                                                          .toString()
                                                          .split(' ')
                                                          .first,
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.grey[800],
                                                      ),
                                                    ),
                                                  ),
                                                  Icon(
                                                    place['type'] == 'cafe'
                                                        ? Icons.coffee
                                                        : place['type'] ==
                                                                'food_stall'
                                                            ? Icons.fastfood
                                                            : Icons.restaurant,
                                                    color: Colors.amber[700],
                                                    size: 28,
                                                  ),
                                                ],
                                              ),
                                            );},),
                                      ],
                                    ),
                                    // Customize map with additional layers if needed
                                  ],
                                ),
                              ),

                              // Map control buttons
                              Positioned(
                                top: 16,
                                right: 16,
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () {
                                              final currentZoom =
                                                  mapController.camera.zoom;
                                              mapController.move(
                                                  mapController.camera.center,
                                                  currentZoom + 1);
                                            },
                                          ),
                                          Container(
                                            height: 1,
                                            color: Colors.grey[300],
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            onPressed: () {
                                              final currentZoom =
                                                  mapController.camera.zoom;
                                              mapController.move(
                                                  mapController.camera.center,
                                                  currentZoom - 1);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.my_location),
                                        onPressed: () {
                                          mapController.move(coordinates, 15);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Action buttons at bottom
                              Positioned(
                                bottom: 16,
                                right: 16,
                                left: 16,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppTheme.primaryColor,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                        ),
                                        icon: const Icon(Icons.directions),
                                        label: const Text('Get Directions'),
                                        onPressed: () async {
                                          final url = Uri.parse(
                                            'https://www.google.com/maps/search/?api=1&query=${coordinates.latitude},${coordinates.longitude}&query_place_id=${item['title']}',
                                          );

                                          try {
                                            await launchUrl(url,
                                                mode: LaunchMode
                                                    .externalApplication);
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Could not open maps. Error: $e')),
                                              );
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.share_location,
                                          color: AppTheme.primaryColor,
                                        ),
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text('Location shared!')),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.grey, fontSize: 16)),
          ),
        ],
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: AppTheme.primaryColor),
            ),
            const SizedBox(width: 16),
            Text(text,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
