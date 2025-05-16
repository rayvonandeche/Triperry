import 'package:flutter/material.dart';
import 'package:triperry/theme/app_theme.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:intl/intl.dart';

class TransportDetailScreen extends StatefulWidget {
  final Map<String, dynamic> transport;

  const TransportDetailScreen({
    Key? key,
    required this.transport,
  }) : super(key: key);

  @override
  State<TransportDetailScreen> createState() => _TransportDetailScreenState();
}

class _TransportDetailScreenState extends State<TransportDetailScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _photoPageController;
  int _currentPhotoPage = 0;
  bool _isFavorite = false;

  // Date selection fields
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  int _passengerCount = 1;
  
  // For flight/train selections
  bool _isRoundTrip = false;
  DateTime? _returnDate;

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
    final String mainImage = (widget.transport['image'] as String?) ?? defaultImage;
    
    // Log the current photo page for debugging purposes
    if (_currentPhotoPage > 0) {
      print('Viewing photo: ${_currentPhotoPage + 1} of 3');
    }
    
    return [
      mainImage,
      mainImage, // Duplicate for demo purposes
      mainImage, // Duplicate for demo purposes
    ];
  }
  
  // Select date helper method
  Future<void> _selectDate(BuildContext context, {bool isReturn = false}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isReturn ? (_returnDate ?? _selectedDate.add(const Duration(days: 1))) : _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        if (isReturn) {
          _returnDate = picked;
        } else {
          _selectedDate = picked;
          // If return date exists and is before the new departure date, update it
          if (_returnDate != null && _returnDate!.isBefore(_selectedDate)) {
            _returnDate = _selectedDate.add(const Duration(days: 1));
          }
        }
      });
    }
  }
  
  // Select time helper method
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if this is a flight or train that might need return trip option
    final bool showReturnOption = 
        widget.transport['type'] == 'Flights' || 
        widget.transport['type'] == 'Trains';
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTransportHeader(),
                const Divider(),
                _buildTabBar(),
                _buildTabContent(),
                const Divider(),
                _buildDateSelection(showReturnOption),
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
          children: [            PageView.builder(
              controller: _photoPageController,
              onPageChanged: (index) => setState(() => _currentPhotoPage = index),
              itemCount: _photos.length,
              itemBuilder: (context, index) {
                return Hero(
                  tag: '${widget.transport['id'] ?? 'transport'}_$index',
                  child: Image.asset(
                    _photos[index],
                    fit: BoxFit.cover,
                  ),
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
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isFavorite
                      ? '${widget.transport['title'] ?? 'Transport'} added to favorites'
                      : '${widget.transport['title'] ?? 'Transport'} removed from favorites',
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
                content: Text('Sharing transport option...'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTransportHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.transport['title'] ?? 'Transport',
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
                    const SizedBox(width: 4),
                    Text(
                      '${widget.transport['rating'] ?? 4.0}',
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
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                widget.transport['address'] ?? 'Kenya',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Tags
          if (widget.transport['tags'] != null)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ((widget.transport['tags'] as List<dynamic>?) ?? []).map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    tag.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                widget.transport['price'] ?? 'Price on request',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
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
          Tab(text: 'Details'),
          Tab(text: 'Location'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return SizedBox(
      height: 300,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildDetailsTab(),
          _buildLocationTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
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
            widget.transport['description'] ?? 'No description available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Features',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...(widget.transport['amenities'] as List<dynamic>? ?? [])
              .map((amenity) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          amenity,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    // Customize based on transport type
    final String transportType = widget.transport['type'] ?? 'Transport';
    
    // Different detail sections based on transport type
    List<Widget> detailWidgets = [];
    
    switch (transportType) {
      case 'Cars':
        detailWidgets = [
          _buildDetailRow('Vehicle Type', 'Car/SUV'),
          _buildDetailRow('Duration', 'Daily rental'),
          _buildDetailRow('Pick-up', 'Airport or Hotel'),
          _buildDetailRow('Drop-off', 'Same as Pick-up'),
          _buildDetailRow('Driver', 'Optional (additional cost)'),
        ];
        break;
      case 'Flights':
        detailWidgets = [
          _buildDetailRow('Flight Type', 'Scheduled/Charter'),
          _buildDetailRow('Duration', '45-90 minutes'),
          _buildDetailRow('Departure', widget.transport['address'] ?? 'Airport'),
          _buildDetailRow('Luggage', '15kg included'),
          _buildDetailRow('Refreshments', 'Included'),
        ];
        break;
      case 'Trains':
        detailWidgets = [
          _buildDetailRow('Train Type', 'Express/Scenic'),
          _buildDetailRow('Duration', '4-6 hours'),
          _buildDetailRow('Class', 'Economy/First available'),
          _buildDetailRow('Meals', 'Available on board'),
          _buildDetailRow('Station', widget.transport['address'] ?? 'Station'),
        ];
        break;
      case 'Boats':
        detailWidgets = [
          _buildDetailRow('Vessel Type', 'Traditional/Modern'),
          _buildDetailRow('Duration', '2-4 hours'),
          _buildDetailRow('Capacity', '6-20 passengers'),
          _buildDetailRow('Inclusions', 'Safety gear, guide'),
          _buildDetailRow('Port', widget.transport['address'] ?? 'Port'),
        ];
        break;
      case 'Safari':
        detailWidgets = [
          _buildDetailRow('Vehicle Type', '4x4 Land Cruiser'),
          _buildDetailRow('Duration', 'Full day (8 hours)'),
          _buildDetailRow('Capacity', '6 passengers'),
          _buildDetailRow('Inclusions', 'Guide, water'),
          _buildDetailRow('Pick-up', 'Hotel/Lodge'),
        ];
        break;
      default:
        detailWidgets = [
          _buildDetailRow('Type', transportType),
          _buildDetailRow('Duration', 'Variable'),
          _buildDetailRow('Location', widget.transport['address'] ?? 'Kenya'),
        ];
    }
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$transportType Details',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...detailWidgets,
          const SizedBox(height: 16),
          const Text(
            'Cancellation Policy',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Free cancellation up to 24 hours before the scheduled time. After that, a 50% fee applies.',
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTab() {
    // Define default coordinates for Kenya if not available
    final LatLng defaultLocation = LatLng(-1.286389, 36.817223); // Nairobi

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
            height: 200,
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
                  initialCenter: defaultLocation,
                  initialZoom: 10,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.triperry.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: defaultLocation,
                        width: 100,
                        height: 40,
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
                              ),
                              child: Text(
                                widget.transport['address'] ?? 'Location',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              final url = 'https://www.google.com/maps/search/?api=1&query=${widget.transport['address'] ?? 'Kenya'}';
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
            icon: const Icon(Icons.map),
            label: const Text('View on Google Maps'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              foregroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              minimumSize: const Size(double.infinity, 0),
            ),
          ),
        ],
      ),
    );
  }
  
  // Widget for the date selection section
  Widget _buildDateSelection(bool showReturnOption) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Book Your Transport',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Trip type selection for flights and trains
          if (showReturnOption) 
            Row(
              children: [
                Expanded(
                  child: _buildSelectorButton(
                    'One-way',
                    !_isRoundTrip,
                    () => setState(() => _isRoundTrip = false),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSelectorButton(
                    'Round-trip',
                    _isRoundTrip,
                    () => setState(() => _isRoundTrip = true),
                  ),
                ),
              ],
            ),
          
          if (showReturnOption) 
            const SizedBox(height: 16),
          
          // Date picker button
          InkWell(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        showReturnOption ? 'Departure Date' : 'Date',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    DateFormat('EEE, MMM d, yyyy').format(_selectedDate),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Return date (only if round trip is selected)
          if (_isRoundTrip)
            Column(
              children: [
                InkWell(
                  onTap: () => _selectDate(context, isReturn: true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Text(
                              'Return Date',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          _returnDate != null 
                              ? DateFormat('EEE, MMM d, yyyy').format(_returnDate!)
                              : 'Select Date',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          
          // Time selector
          InkWell(
            onTap: () => _selectTime(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Time',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _selectedTime.format(context),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Passenger counter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, size: 18, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      'Passengers',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (_passengerCount > 1) {
                          setState(() {
                            _passengerCount--;
                          });
                        }
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: _passengerCount > 1 
                              ? AppTheme.primaryColor 
                              : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 16,
                          color: _passengerCount > 1 ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        _passengerCount.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (_passengerCount < 10) {
                          setState(() {
                            _passengerCount++;
                          });
                        }
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: _passengerCount < 10 
                              ? AppTheme.primaryColor 
                              : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          size: 16,
                          color: _passengerCount < 10 ? Colors.white : Colors.grey[600],
                        ),
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
  }
  
  Widget _buildSelectorButton(String text, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: isSelected 
              ? Border.all(color: AppTheme.primaryColor) 
              : Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey[800],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -1),
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
              Text(
                _calculateTotalPrice(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Validate and proceed
                if (_isRoundTrip && _returnDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a return date'),
                    ),
                  );
                  return;
                }
                
                // Show booking confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Booking ${widget.transport['title'] ?? 'transport'} for ${_passengerCount} passenger(s) on ${DateFormat('MMM d').format(_selectedDate)} at ${_selectedTime.format(context)}'),
                    duration: const Duration(seconds: 2),
                  ),
                );
                
                // Here you would normally navigate to a booking confirmation screen
                // or process the booking in the background
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Calculate the total price based on selections
  String _calculateTotalPrice() {
    // Extract base price
    final String priceString = widget.transport['price'] ?? 'KSh 5,000';
    final RegExp regex = RegExp(r'([0-9,]+)');
    final Match? match = regex.firstMatch(priceString);
    
    if (match == null) return priceString;
    
    String numericPart = match.group(1)?.replaceAll(',', '') ?? '5000';
    double basePrice = double.tryParse(numericPart) ?? 5000;
    
    // Calculate total based on selections
    double total = basePrice * _passengerCount;
    
    // Double for round trip
    if (_isRoundTrip) total *= 2;
    
    // Format with commas for thousands
    final formatter = NumberFormat('#,###');
    return 'KSh ${formatter.format(total)}';
  }
}
