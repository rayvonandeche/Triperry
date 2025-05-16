import 'package:flutter/material.dart';
import 'package:triperry/theme/app_theme.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AccommodationDetailScreen extends StatefulWidget {
  final Map<String, dynamic> accommodation;

  const AccommodationDetailScreen({
    Key? key,
    required this.accommodation,
  }) : super(key: key);

  @override
  State<AccommodationDetailScreen> createState() => _AccommodationDetailScreenState();
}

class _AccommodationDetailScreenState extends State<AccommodationDetailScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _photoPageController;
  int _currentPhotoPage = 0;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _photoPageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _photoPageController.dispose();
    super.dispose();
  }
  // Create additional dummy photos for the gallery
  List<String> get _photos {
    final String defaultImage = 'assets/images/placeholder.jpeg';
    final String mainImage = (widget.accommodation['image'] as String?) ?? defaultImage;
    
    return [
      mainImage,
      mainImage, // Duplicate for demo purposes
      mainImage, // Duplicate for demo purposes
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAccommodationHeader(),
                const Divider(),
                _buildTabBar(),
                _buildTabContent(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            PageView.builder(
              controller: _photoPageController,
              onPageChanged: (index) => setState(() => _currentPhotoPage = index),
              itemCount: _photos.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  _photos[index],
                  fit: BoxFit.cover,
                );
              },
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _photoPageController,
                  count: _photos.length,
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    type: WormType.thin,
                    activeDotColor: AppTheme.primaryColor,
                    dotColor: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : Colors.white,
          ),
          onPressed: () {
            setState(() {
              _isFavorite = !_isFavorite;
            });            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isFavorite
                      ? '${widget.accommodation['title'] ?? widget.accommodation['name'] ?? 'Accommodation'} added to favorites'
                      : '${widget.accommodation['title'] ?? widget.accommodation['name'] ?? 'Accommodation'} removed from favorites',
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sharing accommodation...'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAccommodationHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [          Row(
            children: [
              Expanded(
                child: Text(
                  widget.accommodation['title'] ?? widget.accommodation['name'] ?? 'Accommodation',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppTheme.primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 4),                    Text(
                      ((widget.accommodation['rating'] as num?) ?? 4.0).toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                widget.accommodation['address'] ?? 'Kenya',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tag in (widget.accommodation['tags'] as List<dynamic>))
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    tag.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [              Text(
                widget.accommodation['price'] ?? widget.accommodation['priceRange'] ?? 'KSh 5,000',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              Text(
                ' / night',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: AppTheme.primaryColor,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Rooms'),
          Tab(text: 'Location'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return SizedBox(
      height: 600, // Fixed height as an example, you might want to adjust based on content
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildRoomsTab(),
          _buildLocationTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    final List<String> amenities = widget.accommodation['amenities'] ?? [
      'Free WiFi',
      'Parking',
      'Restaurant',
      'Swimming Pool',
      'Air Conditioning',
      'Fitness Center',
      'Spa',
      '24/7 Reception'
    ];
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.accommodation['description'] ?? 
            'Experience luxury accommodations with stunning views and exceptional service. Our establishment offers a perfect blend of comfort and convenience, making it an ideal choice for both business travelers and vacationers.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Amenities',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final amenity in amenities)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getAmenityIcon(amenity),
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      amenity,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Policies',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildPolicyItem('Check-in', '14:00 - 22:00'),
          _buildPolicyItem('Check-out', 'Until 12:00'),
          _buildPolicyItem('Cancellation', 'Free cancellation up to 24 hours before check-in'),
          _buildPolicyItem('Children', 'All children are welcome'),
          _buildPolicyItem('Pets', 'Pets are not allowed'),
        ],
      ),
    );
  }

  Widget _buildPolicyItem(String title, String details) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              details,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomsTab() {
    final List<dynamic> rooms = widget.accommodation['rooms'] ?? [
      {
        'name': 'Standard Room',
        'price': 'KSh 5,000',
        'capacity': '2 guests',
        'description': 'Comfortable room with all essential amenities for a pleasant stay.',
        'image': widget.accommodation['image']
      },
      {
        'name': 'Deluxe Room',
        'price': 'KSh 8,000',
        'capacity': '2 guests',
        'description': 'Spacious room with premium amenities and extra comfort.',
        'image': widget.accommodation['image']
      },
      {
        'name': 'Suite',
        'price': 'KSh 12,000',
        'capacity': '4 guests',
        'description': 'Luxurious suite with separate living area and premium amenities.',
        'image': widget.accommodation['image']
      }
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rooms.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final room = rooms[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  room['image'],
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          room['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          room['price'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      room['capacity'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      room['description'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Booking ${room['name']}...'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Book Now'),
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

  Widget _buildLocationTab() {
    // Define default coordinates for Kenya if not available
    final LatLng defaultLocation = LatLng(-1.286389, 36.817223); // Nairobi
    LatLng coordinates = defaultLocation;

    if (widget.accommodation['coordinates'] != null) {
      try {
        // Handle different coordinate formats (Map or String)
        var lat = widget.accommodation['coordinates'] is Map 
          ? widget.accommodation['coordinates']['lat'] 
          : 0.0;
        var lng = widget.accommodation['coordinates'] is Map 
          ? widget.accommodation['coordinates']['lng'] 
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

    // Generate nearby amenities
    final nearbyPlaces = [
      {
        'name': 'Restaurant',
        'distance': '200m',
        'type': 'food',
        'coordinates': LatLng(coordinates.latitude + 0.002, coordinates.longitude + 0.002),
      },
      {
        'name': 'Supermarket',
        'distance': '350m',
        'type': 'shopping',
        'coordinates': LatLng(coordinates.latitude - 0.001, coordinates.longitude + 0.003),
      },
      {
        'name': 'Bus Stop',
        'distance': '150m',
        'type': 'transport',
        'coordinates': LatLng(coordinates.latitude + 0.001, coordinates.longitude - 0.002),
      },
    ];

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
          const SizedBox(height: 16),
          Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: coordinates,
                  initialZoom: 14,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.triperry.app',
                  ),
                  MarkerLayer(
                    markers: [
                      // Main accommodation marker
                      Marker(
                        point: coordinates,
                        width: 100,
                        height: 60,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
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
                              ),                              child: Text(
                                (widget.accommodation['title'] ?? widget.accommodation['name'] ?? 'Accommodation').toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  place['name'].toString(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              Icon(
                                _getNearbyIcon(place['type'].toString()),
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
          ),
          const SizedBox(height: 24),
          const Text(
            'Nearby Places',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: nearbyPlaces.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final place = nearbyPlaces[index];
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getNearbyIcon(place['type'].toString()),
                    color: Colors.amber[700],
                  ),
                ),
                title: Text(place['name'].toString()),
                subtitle: Text('Distance: ${place['distance']}'),
                trailing: const Icon(Icons.directions, color: AppTheme.primaryColor),
                onTap: () async {
                  final placeCoords = place['coordinates'] as LatLng;
                  final url = Uri.parse(
                    'https://www.google.com/maps/dir/?api=1&destination=${placeCoords.latitude},${placeCoords.longitude}',
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
                },
              );
            },
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {              final url = Uri.parse(
                'https://www.google.com/maps/search/?api=1&query=${coordinates.latitude},${coordinates.longitude}&query_place_id=${Uri.encodeComponent(widget.accommodation['title'] ?? widget.accommodation['name'] ?? 'Accommodation')}',
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
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              side: const BorderSide(color: AppTheme.primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size(double.infinity, 48),
            ),
            icon: const Icon(Icons.map_outlined),
            label: const Text('View on Google Maps'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
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
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [                  Text(
                    widget.accommodation['price'] ?? widget.accommodation['priceRange'] ?? 'KSh 5,000',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  Text(
                    ' / night',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Booking ${widget.accommodation['title'] ?? widget.accommodation['name'] ?? 'Accommodation'}...'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Book Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getAmenityIcon(String amenity) {
    final amenityMap = {
      'Free WiFi': Icons.wifi,
      'Parking': Icons.local_parking,
      'Restaurant': Icons.restaurant,
      'Swimming Pool': Icons.pool,
      'Air Conditioning': Icons.ac_unit,
      'Fitness Center': Icons.fitness_center,
      'Spa': Icons.spa,
      '24/7 Reception': Icons.access_time_filled,
      'Free Breakfast': Icons.free_breakfast,
      'Bar': Icons.local_bar,
      'Room Service': Icons.room_service,
      'Conference Room': Icons.business_center,
    };
    return amenityMap[amenity] ?? Icons.check_circle;
  }

  IconData _getNearbyIcon(String type) {
    final typeMap = {
      'food': Icons.restaurant,
      'shopping': Icons.shopping_bag,
      'transport': Icons.directions_bus,
      'attraction': Icons.photo_camera,
      'bank': Icons.account_balance,
    };
    return typeMap[type] ?? Icons.location_on;
  }
}
