import 'package:flutter/material.dart';
import 'dart:math';

import '../models/ai_models.dart';

class TravelRecommendationsStage extends StatefulWidget {
  final Map<String, dynamic> tripData;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final VoidCallback onRestart;
  final Function(Map<String, dynamic>) onBookTrip;

  const TravelRecommendationsStage({
    super.key,
    required this.tripData,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.onRestart,
    required this.onBookTrip,
  });

  @override
  State<TravelRecommendationsStage> createState() => _TravelRecommendationsStageState();
}

class _TravelRecommendationsStageState extends State<TravelRecommendationsStage> with TickerProviderStateMixin {
  final List<TravelRecommendation> _recommendations = [];
  bool _isLoading = true;
  int _selectedIndex = -1;
  bool _showBookingForm = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isProcessingPayment = false;
  bool _bookingComplete = false;
  bool _showAccessibilityOptions = false;
  
  late TabController _tabController;
  final List<String> _tabs = ['Hotels', 'Flights', 'Activities', 'Summary'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    
    // Simulate loading recommendations from an API
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      _generateRecommendations();
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _generateRecommendations() {
    final random = Random();
    final destination = widget.tripData['destination'] ?? 'Unknown';
    final activityType = widget.tripData['activityType'] ?? 'Mixed';
    final budget = widget.tripData['budget'] ?? 'Mid-range';
    final needsAccessibility = widget.tripData['accessibility'] != null && 
                              widget.tripData['accessibility'] != 'No special requirements';
    
    // Generate 3 recommendations
    for (int i = 0; i < 3; i++) {
      // Determine hotel type based on budget
      String hotelType = 'Standard Hotel';
      double hotelPrice = 0;
      
      switch (budget) {
        case 'Budget friendly':
          hotelType = ['Budget Hotel', 'Hostel', 'Guesthouse'][random.nextInt(3)];
          hotelPrice = 50.0 + random.nextDouble() * 50;
          break;
        case 'Mid-range':
          hotelType = ['3-Star Hotel', 'Boutique Hotel', 'Apartment'][random.nextInt(3)];
          hotelPrice = 100.0 + random.nextDouble() * 100;
          break;
        case 'Luxury':
          hotelType = ['5-Star Resort', 'Luxury Hotel', 'Premium Villa'][random.nextInt(3)];
          hotelPrice = 250.0 + random.nextDouble() * 250;
          break;
        case 'No budget limit':
          hotelType = ['Elite Resort', 'Exclusive Villa', 'Presidential Suite'][random.nextInt(3)];
          hotelPrice = 500.0 + random.nextDouble() * 1000;
          break;
      }

      // Generate activities based on trip type
      List<String> activities = [];
      switch (activityType.split(', ')[0]) {
        case 'Adventure':
          activities = ['Hiking trip', 'Scuba diving', 'Zip-lining', 'Mountain biking'];
          break;
        case 'Relaxation':
          activities = ['Spa day', 'Beach relaxation', 'Meditation retreat', 'Yoga classes'];
          break;
        case 'Cultural':
          activities = ['Museum tours', 'Historic site visits', 'Local cooking class', 'Cultural shows'];
          break;
        case 'Nature':
          activities = ['National park visit', 'Wildlife safari', 'Botanical garden tour', 'Nature hikes'];
          break;
        case 'Urban':
          activities = ['City tour', 'Shopping trip', 'Restaurant hopping', 'Nightlife experience'];
          break;
        default:
          activities = ['City exploration', 'Beach day', 'Local cuisine tasting', 'Sightseeing'];
      }

      // Add accessibility features if needed
      List<String> accessibilityFeatures = [];
      if (needsAccessibility) {
        accessibilityFeatures = [
          'Wheelchair accessible transportation',
          'Accessible hotel rooms',
          'Step-free access to activities',
          'Accessible bathroom facilities',
          'Visual/audio aids available'
        ];
      }

      _recommendations.add(
        TravelRecommendation(
          title: "Option ${i+1}: $destination ${_getPackageType(i)}",
          description: "Experience the best of $destination with our specially curated package.",
          hotelDetails: HotelDetails(
            name: "$hotelType in $destination",
            rating: 3.5 + random.nextDouble() * 1.5,
            pricePerNight: hotelPrice,
            features: [
              "Free WiFi",
              "${random.nextInt(2) + 1} Restaurant${random.nextInt(2) > 0 ? 's' : ''}",
              "Swimming Pool",
              if (needsAccessibility) "Accessible Rooms",
              "Air Conditioning"
            ],
            images: [
              "https://example.com/hotel${i+1}_image1.jpg",
              "https://example.com/hotel${i+1}_image2.jpg"
            ]
          ),
          flightDetails: FlightDetails(
            airline: _getRandomAirline(),
            departureTime: "08:${30 + random.nextInt(30)}",
            returnTime: "18:${10 + random.nextInt(50)}",
            stopCount: random.nextInt(2),
            price: 200.0 + random.nextDouble() * 300,
            features: [
              "In-flight meals",
              "${random.nextInt(2) > 0 ? 'Free' : 'Paid'} baggage",
              if (needsAccessibility) "Special assistance",
              "In-flight entertainment"
            ]
          ),
          activities: activities.sublist(0, min(3, activities.length)),
          totalPrice: 0, // Will be calculated
          duration: "${random.nextInt(5) + 3} days",
          accessibilityFeatures: accessibilityFeatures,
        )
      );
      
      // Calculate total price
      _recommendations[i].totalPrice = _recommendations[i].hotelDetails.pricePerNight * 
          int.parse(_recommendations[i].duration.split(" ")[0]) +
          _recommendations[i].flightDetails.price;
    }
    
    // Sort by price
    _recommendations.sort((a, b) => a.totalPrice.compareTo(b.totalPrice));
  }
  
  String _getPackageType(int index) {
    switch (index) {
      case 0: return "Essential";
      case 1: return "Premium";
      case 2: return "Exclusive";
      default: return "Custom";
    }
  }
  
  String _getRandomAirline() {
    final airlines = [
      "SkyWings",
      "Global Air",
      "Horizon Airways",
      "Summit Airlines",
      "Celestial Flights"
    ];
    return airlines[Random().nextInt(airlines.length)];
  }
  
  void _selectRecommendation(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  void _startBooking() {
    setState(() {
      _showBookingForm = true;
    });
  }
  
  void _processBooking() {
    if (_nameController.text.isEmpty || 
        _emailController.text.isEmpty || 
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields'))
      );
      return;
    }
    
    setState(() {
      _isProcessingPayment = true;
    });
    
    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isProcessingPayment = false;
        _bookingComplete = true;
      });
      
      // Pass booking details back
      widget.onBookTrip({
        'package': _recommendations[_selectedIndex].title,
        'totalPrice': _recommendations[_selectedIndex].totalPrice,
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'destination': widget.tripData['destination'],
        'bookingNumber': 'BK${100000 + Random().nextInt(900000)}',
        'travelDate': DateTime.now().add(const Duration(days: 30)),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.fadeAnimation,
      child: SlideTransition(
        position: widget.slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Travel Recommendations",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Based on your preferences, here are some options for your trip to ${widget.tripData['destination'] ?? 'your destination'}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            
            if (_isLoading)
              Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      "Finding the best options for you...",
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  ],
                ),
              )
            else if (_bookingComplete)
              _buildBookingConfirmation()
            else if (_showBookingForm)
              _buildBookingForm()
            else if (_selectedIndex >= 0)
              _buildDetailedView()
            else
              _buildRecommendationsList(),
              
            const SizedBox(height: 24),
            
            if (!_isLoading && !_showBookingForm && !_bookingComplete)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text("Start Over"),
                    onPressed: widget.onRestart,
                  ),
                  if (!_isLoading && _selectedIndex >= 0)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text("Book This Trip"),
                      onPressed: _startBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRecommendationsList() {
    return Column(
      children: [
        if (widget.tripData['accessibility'] != null && 
            widget.tripData['accessibility'] != 'No special requirements')
          Card(
            color: Theme.of(context).colorScheme.surface,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.accessible, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Accessibility Needs Included",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "All recommendations include ${widget.tripData['accessibility']} accommodations",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _showAccessibilityOptions = !_showAccessibilityOptions;
                            });
                          },
                          child: Text(
                            _showAccessibilityOptions ? "Hide details" : "Show details",
                          ),
                        ),
                        if (_showAccessibilityOptions)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              const Text("• Special assistance at airports and hotels"),
                              const Text("• Accessible transportation for all included activities"),
                              const Text("• Customized itinerary based on mobility needs"),
                              const Text("• Priority boarding and specialized seating"),
                              if (widget.tripData['accessibility'] == 'Vision assistance')
                                const Text("• Audio descriptive guides and braille information"),
                              if (widget.tripData['accessibility'] == 'Hearing assistance')
                                const Text("• Text-based communications and visual alerts"),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ..._recommendations.asMap().entries.map((entry) {
          final index = entry.key;
          final recommendation = entry.value;
          
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () => _selectRecommendation(index),
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.8),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            index == 0 ? Icons.bookmark : 
                              index == 1 ? Icons.star : Icons.diamond,
                            size: 40,
                            color: Colors.white,
                          ),
                          Text(
                            recommendation.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.hotel, 
                                 color: Theme.of(context).primaryColor),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                recommendation.hotelDetails.name,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            _buildRatingStars(recommendation.hotelDetails.rating),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Icon(Icons.flight, 
                                 color: Theme.of(context).primaryColor),
                            const SizedBox(width: 8),
                            Text(
                              "${recommendation.flightDetails.airline} ● ${recommendation.flightDetails.departureTime}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, 
                                 color: Theme.of(context).primaryColor),
                            const SizedBox(width: 8),
                            Text(
                              recommendation.duration,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Spacer(),
                            Text(
                              "\$${recommendation.totalPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _selectRecommendation(index),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: index == 1 
                                  ? const Color(0xFFFFD700).withOpacity(0.8) 
                                  : null,
                            ),
                            child: const Text("View Details"),
                          ),
                        ),
                        if (index == 1)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Best Value",
                                style: TextStyle(
                                  color: const Color(0xFFFFD700),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
  
  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, color: Color(0xFFFFD700), size: 16);
        } else if (index < rating.ceil() && rating.truncateToDouble() != rating) {
          return const Icon(Icons.star_half, color: Color(0xFFFFD700), size: 16);
        } else {
          return const Icon(Icons.star_border, color: Color(0xFFFFD700), size: 16);
        }
      }),
    );
  }
  
  Widget _buildDetailedView() {
    final recommendation = _recommendations[_selectedIndex];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back button
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedIndex = -1;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back, size: 16, 
                 color: Theme.of(context).primaryColor),
              const SizedBox(width: 4),
              Text(
                "Back to all options",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Package title
        Text(
          recommendation.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          recommendation.description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        
        // Tab navigation
        TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          indicatorColor: Theme.of(context).primaryColor,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
        const SizedBox(height: 16),
        
        // Tab content
        SizedBox(
          height: 300,
          child: TabBarView(
            controller: _tabController,
            children: [
              // Hotels tab
              _buildHotelDetails(recommendation.hotelDetails),
              
              // Flights tab
              _buildFlightDetails(recommendation.flightDetails),
              
              // Activities tab
              _buildActivitiesDetails(recommendation.activities, recommendation.accessibilityFeatures),
              
              // Summary tab
              _buildSummaryDetails(recommendation),
            ],
          ),
        ),
        
        // Price and book button
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Total Price"),
                  Text(
                    "\$${recommendation.totalPrice.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _startBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text("Book Now"),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildHotelDetails(HotelDetails hotel) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            color: Colors.grey.shade200,
            child: Center(
              child: Icon(
                Icons.hotel,
                size: 64,
                color: Colors.grey.shade400,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            hotel.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _buildRatingStars(hotel.rating),
              const SizedBox(width: 8),
              Text("${hotel.rating.toStringAsFixed(1)}/5.0"),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Price per night: \$${hotel.pricePerNight.toStringAsFixed(2)}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Features & Amenities",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...hotel.features.map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(feature),
              ],
            ),
          )),
        ],
      ),
    );
  }
  
  Widget _buildFlightDetails(FlightDetails flight) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.flight_takeoff,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "DEPARTURE",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            flight.departureTime,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(flight.airline),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.flight_land,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "RETURN",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            flight.returnTime,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text("${flight.stopCount} stop${flight.stopCount != 1 ? 's' : ''}"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Total airfare: \$${flight.price.toStringAsFixed(2)}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Flight Amenities",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...flight.features.map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(feature),
              ],
            ),
          )),
        ],
      ),
    );
  }
  
  Widget _buildActivitiesDetails(List<String> activities, List<String> accessibilityFeatures) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Included Activities",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...activities.asMap().entries.map((entry) {
            final index = entry.key;
            final activity = entry.value;
            
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text("${index + 1}"),
                ),
                title: Text(activity),
                subtitle: Text("Day ${index + 1}"),
                trailing: const Icon(Icons.info_outline),
              ),
            );
          }),
          
          if (accessibilityFeatures.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text(
              "Accessibility Features",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...accessibilityFeatures.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.accessible,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: Text(feature)),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }
  
  Widget _buildSummaryDetails(TravelRecommendation recommendation) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your Trip Summary",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Destination and Duration
          _buildSummaryItem(
            icon: Icons.place,
            title: "Destination",
            detail: widget.tripData['destination'] ?? 'Unknown',
          ),
          _buildSummaryItem(
            icon: Icons.calendar_today,
            title: "Duration",
            detail: recommendation.duration,
          ),
          
          // Hotel
          _buildSummaryItem(
            icon: Icons.hotel,
            title: "Accommodation",
            detail: "${recommendation.hotelDetails.name} (${recommendation.hotelDetails.rating.toStringAsFixed(1)}★)",
            price: recommendation.hotelDetails.pricePerNight * 
                int.parse(recommendation.duration.split(" ")[0]),
          ),
          
          // Flight
          _buildSummaryItem(
            icon: Icons.flight,
            title: "Flights",
            detail: "${recommendation.flightDetails.airline} (${recommendation.flightDetails.stopCount} stop${recommendation.flightDetails.stopCount != 1 ? 's' : ''})",
            price: recommendation.flightDetails.price,
          ),
          
          // Activities
          _buildSummaryItem(
            icon: Icons.event,
            title: "Activities",
            detail: "${recommendation.activities.length} included",
            price: 0, // Included in package
            showIncluded: true,
          ),
          
          if (recommendation.accessibilityFeatures.isNotEmpty)
            _buildSummaryItem(
              icon: Icons.accessible,
              title: "Accessibility",
              detail: "${recommendation.accessibilityFeatures.length} features",
              price: 0,
              showIncluded: true,
            ),
          
          const Divider(thickness: 2),
          
          // Total
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                const Text(
                  "Total Price",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  "\$${recommendation.totalPrice.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryItem({
    required IconData icon,
    required String title,
    required String detail,
    double? price,
    bool showIncluded = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  detail,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (price != null)
            Text(
              showIncluded ? "Included" : "\$${price.toStringAsFixed(2)}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: showIncluded ? Colors.green : null,
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildBookingForm() {
    final recommendation = _recommendations[_selectedIndex];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back button
        GestureDetector(
          onTap: () {
            setState(() {
              _showBookingForm = false;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back, size: 16, 
                 color: Theme.of(context).primaryColor),
              const SizedBox(width: 4),
              Text(
                "Back to package details",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        Text(
          "Complete Your Booking",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "You're booking: ${recommendation.title}",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        
        // Traveler Information Section
        const Text(
          "Traveler Information",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: "Full Name",
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: "Email Address",
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: "Phone Number",
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
        ),
        
        const SizedBox(height: 32),
        
        // Payment Summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Payment Summary",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Package Price"),
                  Text("\$${recommendation.totalPrice.toStringAsFixed(2)}"),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Amount",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "\$${recommendation.totalPrice.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Payment Method
        const Text(
          "Payment Method",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              const Row(
                children: [
                  Icon(Icons.credit_card),
                  SizedBox(width: 16),
                  Text(
                    "Credit/Debit Card",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text("Pay now", style: TextStyle(color: Colors.grey[600])),
                  const Spacer(),
                  Text("\$${recommendation.totalPrice.toStringAsFixed(2)}"),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Complete Booking Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isProcessingPayment ? null : _processBooking,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isProcessingPayment
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text("Processing Payment..."),
                    ],
                  )
                : const Text("Complete Booking"),
          ),
        ),
      ],
    );
  }
  
  Widget _buildBookingConfirmation() {
    final recommendation = _recommendations[_selectedIndex];
    
    return Column(
      children: [
        // Success icon and message
        Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 64,
        ),
        const SizedBox(height: 16),
        Text(
          "Booking Confirmed!",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Your trip to ${widget.tripData['destination']} has been booked successfully.",
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 32),
        
        // Booking details card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green),
          ),
          child: Column(
            children: [
              // Booking reference
              Row(
                children: [
                  const Text("Booking Reference:"),
                  const Spacer(),
                  Text(
                    "BK${100000 + Random().nextInt(900000)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(),
              
              // Package name
              Row(
                children: [
                  const Text("Package:"),
                  const Spacer(),
                  Text(
                    recommendation.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(),
              
              // Total price
              Row(
                children: [
                  const Text("Total Price:"),
                  const Spacer(),
                  Text(
                    "\$${recommendation.totalPrice.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Next steps
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "What's Next?",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text("• A confirmation email has been sent to your inbox"),
              const Text("• You'll receive your e-tickets within 24 hours"),
              const Text("• Our team will contact you for any additional information"),
            ],
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton.icon(
              onPressed: widget.onRestart,
              icon: const Icon(Icons.refresh),
              label: const Text("Plan Another Trip"),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.email),
              label: const Text("View Confirmation"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}