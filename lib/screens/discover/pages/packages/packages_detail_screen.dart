import 'package:flutter/material.dart';
import 'package:triperry/theme/app_theme.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class PackageDetailScreen extends StatefulWidget {
  final Map<String, dynamic> package;

  const PackageDetailScreen({
    super.key,
    required this.package,
  }) ;

  @override
  State<PackageDetailScreen> createState() => _PackageDetailScreenState();
}

class _PackageDetailScreenState extends State<PackageDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;
  bool _isBooked = false;

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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Package image
                  Image.asset(
                    widget.package['image'],
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
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
                ],
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _isFavorite
                              ? '${widget.package['title']} added to favorites'
                              : '${widget.package['title']} removed from favorites',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.black),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sharing package...'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          
          // Content area
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and basic info
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        widget.package['title'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Location row
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 20,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.package['location'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Duration row
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.package['duration'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(width: 24),
                          const Icon(
                            Icons.category,
                            size: 18,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.package['category'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Price and rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Price
                          Text(
                            widget.package['price'],
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          
                          // Rating
                          Row(
                            children: [
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < widget.package['rating'].floor()
                                        ? Icons.star
                                        : index < widget.package['rating']
                                            ? Icons.star_half
                                            : Icons.star_border,
                                    color: Colors.amber,
                                    size: 22,
                                  );
                                }),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '(${widget.package['reviews']})',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Tags
                      if (widget.package['tags'] != null)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (widget.package['tags'] as List)
                              .map<Widget>((tag) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppTheme.primaryColor.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Text(
                                      tag,
                                      style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                    ],
                  ),
                ),
                
                // Tab bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: AppTheme.primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: AppTheme.primaryColor,
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.description),
                        text: 'Details',
                      ),
                      Tab(
                        icon: Icon(Icons.list_alt),
                        text: 'Itinerary',
                      ),
                      Tab(
                        icon: Icon(Icons.map),
                        text: 'Map',
                      ),
                    ],
                  ),
                ),
                
                // Tab content
                SizedBox(
                  height: 500, // Fixed height for the tab content
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Details tab
                      _buildDetailsTab(),
                      
                      // Itinerary tab
                      _buildItineraryTab(),
                      
                      // Map tab
                      _buildMapTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Bottom action bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Contact button
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: () {
                  // Action for contact
                  _showContactDialog();
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppTheme.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Contact',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Book now button
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isBooked = !_isBooked;
                  });
                  
                  // Show a different message based on current state
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isBooked
                            ? 'Package booked successfully!'
                            : 'Booking has been cancelled',
                      ),
                      duration: const Duration(seconds: 2),
                      action: _isBooked
                          ? SnackBarAction(
                              label: 'View',
                              onPressed: () {
                                // Navigate to bookings page
                              },
                            )
                          : null,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isBooked ? Colors.grey : AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  _isBooked ? 'Cancel Booking' : 'Book Now',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Build the details tab content
  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.package['description_full'] ?? 'No description available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          
          // Amenities
          const Text(
            'What\'s Included',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          if (widget.package['amenities'] != null)
            Column(
              children: (widget.package['amenities'] as List).map<Widget>((amenity) {
                IconData iconData = Icons.check_circle;
                
                // Map the amenity to an appropriate icon
                if (amenity.toString().toLowerCase().contains('transport')) {
                  iconData = Icons.directions_car;
                } else if (amenity.toString().toLowerCase().contains('meal')) {
                  iconData = Icons.restaurant;
                } else if (amenity.toString().toLowerCase().contains('guide')) {
                  iconData = Icons.person;
                } else if (amenity.toString().toLowerCase().contains('accommodation')) {
                  iconData = Icons.hotel;
                } else if (amenity.toString().toLowerCase().contains('equipment')) {
                  iconData = Icons.hiking;
                } else if (amenity.toString().toLowerCase().contains('chef')) {
                  iconData = Icons.food_bank;
                } else if (amenity.toString().toLowerCase().contains('villa')) {
                  iconData = Icons.villa;
                }
                
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Icon(
                        iconData,
                        size: 20,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        amenity,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            )
          else
            Text(
              'No amenities information available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
  
  // Build the itinerary tab content
  Widget _buildItineraryTab() {
    final hasItinerary = widget.package['itinerary'] != null && 
                        (widget.package['itinerary'] as List).isNotEmpty;
    
    return hasItinerary
        ? SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Itinerary items
                for (var i = 0; i < (widget.package['itinerary'] as List).length; i++)
                  _buildItineraryItem(widget.package['itinerary'][i], i, (widget.package['itinerary'] as List).length),
              ],
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_note,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Itinerary not available',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please contact us for detailed information',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
  }
  
  // Build each itinerary item
  Widget _buildItineraryItem(Map<String, dynamic> item, int index, int totalItems) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (index < totalItems - 1)
              Container(
                width: 2,
                height: 100, // Adjust this based on content
                color: Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 16),
        
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day label
              Text(
                item['day'] ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              
              // Title
              Text(
                item['title'] ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // Details
              Text(
                item['details'] ?? '',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
  
  // Build the map tab
  Widget _buildMapTab() {
    // Check if we have coordinates
    final hasCoordinates = widget.package['coordinates'] != null;
    
    return hasCoordinates        ? FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(
                widget.package['coordinates']['lat'],
                widget.package['coordinates']['lng'],
              ),
              initialZoom: 10.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.triperry.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(
                      widget.package['coordinates']['lat'],
                      widget.package['coordinates']['lng'],
                    ),
                    width: 40,
                    height: 40,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primaryColor,
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              // Additional text overlay
              Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.package['location'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Get Directions',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map, // Changed from Icons.map_off
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Map not available',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This package includes multiple locations',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {
                    _tabController.animateTo(1); // Go to itinerary tab
                  },
                  icon: const Icon(Icons.list_alt),
                  label: const Text('View Itinerary'),
                ),
              ],
            ),
          );
  }
  
  // Contact dialog
  void _showContactDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildContactOption(
                icon: Icons.phone,
                title: 'Call Us',
                subtitle: '+254 123 456 789',
                onTap: () {
                  launchUrl(Uri.parse('tel:+254123456789'));
                },
              ),
              const Divider(),
              _buildContactOption(
                icon: Icons.email,
                title: 'Email',
                subtitle: 'info@tripperry.com',
                onTap: () {
                  launchUrl(Uri.parse('mailto:info@tripperry.com'));
                },
              ),
              const Divider(),
              _buildContactOption(
                icon: Icons.chat,
                title: 'Live Chat',
                subtitle: 'Chat with our agents',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Live chat feature coming soon!'),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  // Contact option builder
  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryColor,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}
