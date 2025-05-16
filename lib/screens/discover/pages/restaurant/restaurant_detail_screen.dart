import 'package:flutter/material.dart';
import 'package:triperry/theme/app_theme.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurant,
  });

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MapController _mapController = MapController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {    
    // Add null safety to ensure all required fields have values
    final Map<String, dynamic> restaurantData = Map<String, dynamic>.from(widget.restaurant);
    
    // Extract restaurant coordinates
    LatLng coordinates = LatLng(-1.286389, 36.817223); // Default to Nairobi
    if (restaurantData['coordinates'] != null) {
      try {
        // Check if the coordinates are in the expected format
        final lat = restaurantData['coordinates']['lat'];
        final lng = restaurantData['coordinates']['lng'];
        
        // Convert to double if needed
        final double latValue = lat is double ? lat : double.tryParse(lat.toString()) ?? -1.286389;
        final double lngValue = lng is double ? lng : double.tryParse(lng.toString()) ?? 36.817223;
        
        coordinates = LatLng(latValue, lngValue);
      } catch (e) {
        // Handle unexpected formats gracefully
        print('Error parsing coordinates: $e');
        // Keep using the default coordinates
      }
    }
    
    // Use title if available, otherwise fall back to name or a default value
    final restaurantTitle = restaurantData['title'] ?? restaurantData['name'] ?? 'Restaurant';
    final nearbyRestaurants = _generateNearbyRestaurants(coordinates, restaurantTitle);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRestaurantInfo(),
                _buildActionButtons(),
                _buildTabBar(),
                _buildTabViews(coordinates, nearbyRestaurants),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBookingBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              widget.restaurant['image'] ?? 'assets/images/placeholder.jpeg',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
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
          ],
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to favorites')),
              );
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share functionality')),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRestaurantInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [              Expanded(
                child: Text(
                  widget.restaurant['title'] ?? widget.restaurant['name'] ?? 'Restaurant',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.white, size: 16),
                    const SizedBox(width: 4),                    Text(
                      '${widget.restaurant['rating'] ?? 4.0}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),          const SizedBox(height: 8),
          Text(
            widget.restaurant['description'] ?? '${widget.restaurant['title'] ?? widget.restaurant['name'] ?? 'This restaurant'} offers a unique dining experience',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  // Handle location which might be a Map or a String
                  widget.restaurant['address'] as String? ?? 
                  (widget.restaurant['location'] is Map 
                    ? 'Kenya' // If it's a Map with coordinates, use a default string
                    : (widget.restaurant['location'] as String? ?? 'Kenya')),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Text(
                'Open: 9:00 AM - 10:00 PM',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: (widget.restaurant['tags'] as List<String>? ?? ['Restaurant'])
                .map((tag) => Chip(
                      label: Text(tag),
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      labelStyle: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 12,
                      ),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(Icons.call, 'Call', () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Calling restaurant')),
            );
          }),
          _buildActionButton(Icons.restaurant_menu, 'Menu', () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Opening menu')),
            );
          }),
          _buildActionButton(Icons.directions, 'Directions', () {
            _openInGoogleMaps();
          }),
          _buildActionButton(Icons.bookmark, 'Reserve', () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Make reservation')),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: AppTheme.primaryColor,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Reviews'),
          Tab(text: 'Photos'),
        ],
      ),
    );
  }

  Widget _buildTabViews(LatLng coordinates, List<Map<String, dynamic>> nearbyRestaurants) {
    return SizedBox(
      height: 1500, // Adjust as needed, or make dynamic based on content
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(coordinates, nearbyRestaurants),
          _buildReviewsTab(),
          _buildPhotosTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(LatLng coordinates, List<Map<String, dynamic>> nearbyRestaurants) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 250,
              width: double.infinity,
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: coordinates,
                      initialZoom: 14,
                      onTap: (_, point) {
                        _openInGoogleMaps();
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
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
                                      Text(                                        widget.restaurant['title'] ?? widget.restaurant['name'] ?? 'Restaurant',
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
                                  size: 42,
                                ),
                              ],
                            ),
                          ),                            // Nearby restaurants markers
                          ...nearbyRestaurants.map((place) {
                            // Extract coordinates properly with improved error handling
                            LatLng placeCoordinates;
                            if (place['coordinates'] is LatLng) {
                              placeCoordinates = place['coordinates'] as LatLng;
                            } else {
                              try {
                                var coords = place['coordinates'];
                                if (coords is Map) {
                                  final lat = coords['lat'];
                                  final lng = coords['lng'];
                                  
                                  // Convert to double with safe null handling
                                  final double latValue = lat is double ? lat : 
                                      (lat != null ? double.tryParse(lat.toString()) ?? -1.286389 : -1.286389);
                                  final double lngValue = lng is double ? lng : 
                                      (lng != null ? double.tryParse(lng.toString()) ?? 36.817223 : 36.817223);
                                      
                                  placeCoordinates = LatLng(latValue, lngValue);
                                } else {
                                  // Default to Nairobi if coordinates structure is unexpected
                                  placeCoordinates = LatLng(-1.286389, 36.817223);
                                  print('Unexpected coordinates format in nearby restaurant: $coords');
                                }
                              } catch (e) {
                                // Handle any unexpected errors gracefully
                                placeCoordinates = LatLng(-1.286389, 36.817223);
                                print('Error parsing restaurant coordinates in nearby restaurant: $e');
                              }
                            }
                            return Marker(
                              point: placeCoordinates,
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
                                    place['name'],
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                                Icon(
                                  place['type'] == 'cafe' ? Icons.coffee : 
                                  place['type'] == 'food_stall' ? Icons.fastfood : 
                                  Icons.restaurant,
                                  color: Colors.amber[700],
                                  size: 28,
                                ),
                              ],
                            ),
                          );}),
                        ],
                      ),
                    ],
                  ),
                  
                  // Map controls
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
                                color: Colors.black.withOpacity(0.1),
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
                                  final currentZoom = _mapController.camera.zoom;
                                  _mapController.move(_mapController.camera.center, currentZoom + 1);
                                },
                              ),
                              Container(
                                height: 1,
                                color: Colors.grey[300],
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  final currentZoom = _mapController.camera.zoom;
                                  _mapController.move(_mapController.camera.center, currentZoom - 1);
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
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.my_location),
                            onPressed: () {
                              _mapController.move(coordinates, 15);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: TextButton.icon(
              onPressed: () {
                _openInGoogleMaps();
              },
              icon: const Icon(Icons.directions),
              label: const Text('Get Directions'),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
              ),
            ),
          ),
          const Divider(height: 32),
          const Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Discover ${widget.restaurant['title'] ?? widget.restaurant['name'] ?? 'our restaurant'}, an authentic ${_getCuisineFromRestaurant()} dining destination. '
            'Our menu features fresh, locally sourced ingredients and traditional recipes that '
            'have been perfected over generations. We pride ourselves on our welcoming atmosphere '
            'and exceptional service.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Popular Dishes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildPopularDishes(),
          const SizedBox(height: 24),
          const Text(
            'Nearby Restaurants',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildNearbyRestaurantsList(nearbyRestaurants),
        ],
      ),
    );
  }
  String _getCuisineFromRestaurant() {
    final title = widget.restaurant['title'] ?? widget.restaurant['name'] ?? '';
    if (title == 'Savannah Grill') return 'African';
    if (title == 'Ocean Breeze') return 'Seafood';
    if (title == 'Highland Bistro') return 'Traditional';
    if (title == 'Urban Eats') return 'International';
    if (title == 'Coastal Kitchen') return 'Swahili';
    return widget.restaurant['cuisineType'] ?? 'Kenyan';
  }

  Widget _buildPopularDishes() {
    final dishes = [      {'name': 'Signature Dish', 'price': 'KSh 950', 'image': widget.restaurant['image'] ?? 'assets/images/placeholder.jpeg'},
      {'name': 'Chef Special', 'price': 'KSh 1200', 'image': widget.restaurant['image'] ?? 'assets/images/placeholder.jpeg'},
      {'name': 'Local Favorite', 'price': 'KSh 850', 'image': widget.restaurant['image']},
    ];

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dishes.length,
        itemBuilder: (context, index) {
          final dish = dishes[index];
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  dish['image'] as String? ?? 'assets/images/placeholder.jpeg',
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dish['name'] as String? ?? 'Dish',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dish['price'] as String? ?? 'Price unavailable',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNearbyRestaurantsList(List<Map<String, dynamic>> nearbyRestaurants) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: nearbyRestaurants.length,
      itemBuilder: (context, index) {
        final restaurant = nearbyRestaurants[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 50,
              height: 50,
              child: Center(
                child: Icon(
                  restaurant['type'] == 'cafe' ? Icons.coffee : 
                  restaurant['type'] == 'food_stall' ? Icons.fastfood : 
                  Icons.restaurant,
                  color: Colors.amber[700],
                  size: 28,
                ),
              ),
            ),
          ),
          title: Text(restaurant['name']),
          subtitle: Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 14),
              Text(' ${restaurant['rating']} · ${restaurant['type']} · ${restaurant['distance']} away'),
            ],
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opening ${restaurant['name']}')),
            );
          },
        );
      },
    );
  }

  Widget _buildReviewsTab() {
    // Dummy reviews data
    final reviews = [
      {
        'name': 'Jane Smith',
        'rating': 5.0,
        'date': '2 days ago',
        'comment': 'Absolutely amazing experience! The food was delicious and the service was impeccable.',
        'helpful': 12,
      },
      {
        'name': 'John Doe',
        'rating': 4.0,
        'date': '1 week ago',
        'comment': 'Great food and atmosphere. Would definitely recommend the chef\'s special.',
        'helpful': 8,
      },
      {
        'name': 'Mary Johnson',
        'rating': 4.5,
        'date': '2 weeks ago',
        'comment': 'Lovely place with authentic cuisine. A bit pricey but worth it for the quality.',
        'helpful': 5,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReviewSummary(),
          const Divider(height: 32),
          ...reviews.map((review) => _buildReviewItem(review)),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Write a review')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Write a Review'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSummary() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${widget.restaurant['rating']}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'out of 5',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Row(
              children: List.generate(
                5,
                (index) {
                  // Safely get rating with default fallback
                  final double rating = (widget.restaurant['rating'] is double) 
                      ? (widget.restaurant['rating'] as double) 
                      : double.tryParse('${widget.restaurant['rating']}') ?? 4.0;
                      
                  return Icon(
                    index < rating.floor()
                        ? Icons.star
                        : index < rating.ceil() && 
                          rating % 1 > 0
                            ? Icons.star_half
                            : Icons.star_border,
                    size: 24,
                    color: Colors.amber,
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Based on ${widget.restaurant['reviews'] ?? 42} reviews',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildRatingBar(5, 0.7),
            _buildRatingBar(4, 0.2),
            _buildRatingBar(3, 0.05),
            _buildRatingBar(2, 0.03),
            _buildRatingBar(1, 0.02),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingBar(int rating, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$rating',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 100,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                child: Text(
                  review['name'].toString().substring(0, 1),
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (index) => Icon(
                            index < (review['rating'] as double).floor()
                                ? Icons.star
                                : Icons.star_border,
                            size: 14,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          review['date'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review['comment'] as String,
            style: const TextStyle(height: 1.5),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.thumb_up_outlined, size: 16),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Marked as helpful')),
                  );
                },
              ),
              Text(
                '${review['helpful']} people found this helpful',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildPhotosTab() {
    // Use same image for multiple items in demo
    final images = List.generate(9, (index) => widget.restaurant['image']);

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Opening photo gallery')),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              images[index],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookingBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price Range',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.restaurant['price'] ?? 'From Ksh 500',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Book a table')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Book a Table'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  List<Map<String, dynamic>> _generateNearbyRestaurants(LatLng coordinates, dynamic mainRestaurantName) {
    // Convert mainRestaurantName to string if it's not already
    final String restaurantName = mainRestaurantName is String 
        ? mainRestaurantName 
        : (mainRestaurantName != null ? mainRestaurantName.toString() : 'Unknown Restaurant');
    
    // Generate 5 nearby restaurants with slight coordinate variations
    return [
      {
        'name': '$restaurantName - Branch 2',
        'coordinates': LatLng(coordinates.latitude + 0.005, coordinates.longitude + 0.003),
        'type': 'restaurant',
        'rating': 4.1,
        'distance': '0.8 km',
      },
      {
        'name': 'Coffee Hub',
        'coordinates': LatLng(coordinates.latitude - 0.003, coordinates.longitude + 0.002),
        'type': 'cafe',
        'rating': 4.3,
        'distance': '0.5 km',
      },
      {
        'name': 'Street Food Corner',
        'coordinates': LatLng(coordinates.latitude + 0.002, coordinates.longitude - 0.004),
        'type': 'food_stall',
        'rating': 4.0,
        'distance': '0.6 km',
      },
      {
        'name': 'Fine Dining Experience',
        'coordinates': LatLng(coordinates.latitude - 0.004, coordinates.longitude - 0.006),
        'type': 'restaurant',
        'rating': 4.7,
        'distance': '0.9 km',
      },
      {
        'name': 'Bakery & Pastries',
        'coordinates': LatLng(coordinates.latitude + 0.006, coordinates.longitude - 0.002),
        'type': 'cafe',
        'rating': 4.4,
        'distance': '1.1 km',
      },
    ];
  }
  void _openInGoogleMaps() async {
    LatLng coordinates = LatLng(-1.286389, 36.817223); // Default
    if (widget.restaurant['coordinates'] != null) {
      try {
        // Check if the coordinates are in the expected format
        final lat = widget.restaurant['coordinates']['lat'];
        final lng = widget.restaurant['coordinates']['lng'];
        
        // Convert to double if needed
        final double latValue = lat is double ? lat : double.tryParse(lat.toString()) ?? -1.286389;
        final double lngValue = lng is double ? lng : double.tryParse(lng.toString()) ?? 36.817223;
        
        coordinates = LatLng(latValue, lngValue);
      } catch (e) {
        // Handle unexpected formats gracefully
        print('Error parsing coordinates in _openInGoogleMaps: $e');
        // Keep using the default coordinates
      }
    }
    
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${coordinates.latitude},${coordinates.longitude}',
    );
    
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open maps. Error: $e')),
        );
      }
    }
  }
}
