import 'package:flutter/material.dart';
import '../models/ai_models.dart';

/// Widget that displays travel recommendations
class TravelRecommendationsStage extends StatefulWidget {
  /// Travel trip data
  final Map<String, dynamic> tripData;
  
  /// Animation for fade effect
  final Animation<double> fadeAnimation;
  
  /// Animation for slide effect
  final Animation<Offset> slideAnimation;
  
  /// Callback when restart is requested
  final VoidCallback onRestart;
  
  /// Callback when booking is requested
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

class _TravelRecommendationsStageState extends State<TravelRecommendationsStage> with SingleTickerProviderStateMixin {
  int _selectedPackageIndex = 0;
  late final AnimationController _staggeredController;
  late final List<Animation<double>> _itemAnimations;
  bool _expanded = false;
  bool _showDetailView = false;
  bool _showBookingConfirmation = false;
  
  @override
  void initState() {
    super.initState();
    
    // Setup staggered animations for recommendation items
    _staggeredController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    const int itemCount = 4; // Number of animated elements
    _itemAnimations = List.generate(itemCount, (index) {
      final startInterval = index * 0.1;
      final endInterval = startInterval + 0.4;
      
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _staggeredController,
        curve: Interval(
          startInterval,
          endInterval,
          curve: Curves.easeOutQuart,
        ),
      ));
    });
    
    // Start the animations
    _staggeredController.forward();
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }

  void _bookTrip() {
    final recommendations = _generateRecommendations();
    final selectedPackage = recommendations[_selectedPackageIndex];
    
    // First show the booking confirmation
    setState(() {
      _showBookingConfirmation = true;
    });
  }
  
  void _confirmBooking() {
    final recommendations = _generateRecommendations();
    final selectedPackage = recommendations[_selectedPackageIndex];
    
    final bookingDetails = {
      'destination': widget.tripData['destination'],
      'package': selectedPackage.title,
      'duration': selectedPackage.duration,
      'totalPrice': selectedPackage.totalPrice,
      'bookingNumber': 'TR${DateTime.now().millisecondsSinceEpoch.toString().substring(7, 13)}',
      'hotelName': selectedPackage.hotelDetails.name,
      'airline': selectedPackage.flightDetails.airline,
      'departureTime': selectedPackage.flightDetails.departureTime,
      'returnTime': selectedPackage.flightDetails.returnTime,
      // User details are assumed to be already available
      'userName': 'John Doe',
      'userEmail': 'john.doe@example.com',
      'userPhone': '+1 555-123-4567',
    };
    
    widget.onBookTrip(bookingDetails);
  }
  
  void _cancelBooking() {
    setState(() {
      _showBookingConfirmation = false;
    });
  }
  
  void _viewPackageDetails() {
    setState(() {
      _showDetailView = true;
    });
  }
  
  void _closeDetailView() {
    setState(() {
      _showDetailView = false;
    });
  }

  List<TravelRecommendation> _generateRecommendations() {
    final destination = widget.tripData['destination'];
    final travelTime = widget.tripData['travelTime'];
    
    return [
      TravelRecommendation(
        title: 'Essential $destination',
        description: 'Perfect for first-time visitors who want to see all the main attractions',
        hotelDetails: HotelDetails(
          name: 'Comfort Inn $destination',
          rating: 4.2,
          pricePerNight: 120.0,
          features: ['Free WiFi', 'Breakfast included', 'Central location'],
          images: ['https://picsum.photos/id/164/600/400']
        ),
        flightDetails: FlightDetails(
          airline: 'JetWay Airlines',
          departureTime: '10:00 AM, ${DateTime.now().add(const Duration(days: 30)).day}/${DateTime.now().add(const Duration(days: 30)).month}',
          returnTime: '3:30 PM, ${DateTime.now().add(const Duration(days: 35)).day}/${DateTime.now().add(const Duration(days: 35)).month}',
          stopCount: 1,
          price: 450.0,
          features: ['1 checked bag', 'Meal included']
        ),
        activities: [
          'Guided city tour',
          'Museum visits',
          'Local cuisine tasting',
        ],
        totalPrice: 1350.0,
        duration: '5 days, 4 nights',
        accessibilityFeatures: ['Wheelchair accessible', 'Airport transfers'],
      ),
      TravelRecommendation(
        title: 'Deluxe $destination Explorer',
        description: 'Enhanced experience with premium accommodations and exclusive activities',
        hotelDetails: HotelDetails(
          name: 'Grand Hotel $destination',
          rating: 4.7,
          pricePerNight: 280.0,
          features: ['Luxury amenities', 'Spa access', 'Fine dining'],
          images: ['https://picsum.photos/id/165/600/400']
        ),
        flightDetails: FlightDetails(
          airline: 'Azure Airways',
          departureTime: '12:30 PM, ${DateTime.now().add(const Duration(days: 32)).day}/${DateTime.now().add(const Duration(days: 32)).month}',
          returnTime: '5:15 PM, ${DateTime.now().add(const Duration(days: 39)).day}/${DateTime.now().add(const Duration(days: 39)).month}',
          stopCount: 0,
          price: 680.0,
          features: ['2 checked bags', 'Premium meals', 'Priority boarding']
        ),
        activities: [
          'Private guided tours',
          'Exclusive cultural experiences',
          'Premium dining package',
          'Evening entertainment',
        ],
        totalPrice: 2880.0,
        duration: '7 days, 6 nights',
        accessibilityFeatures: ['Fully accessible', 'Private transfers'],
      ),
      TravelRecommendation(
        title: 'Budget-friendly $travelTime Getaway',
        description: 'Great value package with all the essentials for an enjoyable stay',
        hotelDetails: HotelDetails(
          name: 'Traveler Lodge',
          rating: 3.8,
          pricePerNight: 85.0,
          features: ['Free WiFi', 'Self-service laundry', 'Shared kitchen'],
          images: ['https://picsum.photos/id/163/600/400']
        ),
        flightDetails: FlightDetails(
          airline: 'ValueJet',
          departureTime: '7:15 AM, ${DateTime.now().add(const Duration(days: 28)).day}/${DateTime.now().add(const Duration(days: 28)).month}',
          returnTime: '9:45 PM, ${DateTime.now().add(const Duration(days: 32)).day}/${DateTime.now().add(const Duration(days: 32)).month}',
          stopCount: 1,
          price: 320.0,
          features: ['1 personal item', 'Snacks for purchase']
        ),
        activities: [
          'Self-guided tour map',
          'Public transport pass',
          'Discount card for attractions',
        ],
        totalPrice: 920.0,
        duration: '4 days, 3 nights',
        accessibilityFeatures: ['Basic accessibility'],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final recommendations = _generateRecommendations();
    
    if (_showDetailView) {
      return _buildDetailedView(context, recommendations[_selectedPackageIndex]);
    }
    
    if (_showBookingConfirmation) {
      return _buildBookingConfirmation(context, recommendations[_selectedPackageIndex]);
    }
    
    return FadeTransition(
      opacity: widget.fadeAnimation,
      child: SlideTransition(
        position: widget.slideAnimation,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Here's the fix: setting mainAxisSize to min to prevent unbounded height issue
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated destination header
              FadeTransition(
                opacity: _itemAnimations[0],
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.2),
                    end: Offset.zero,
                  ).animate(_itemAnimations[0]),
                  child: _buildDestinationHeader(context),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Title for recommendations
              FadeTransition(
                opacity: _itemAnimations[1],
                child: Text(
                  'Recommended Packages',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color?.withOpacity(0.9),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Animated recommendation cards
              FadeTransition(
                opacity: _itemAnimations[2],
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.2, 0),
                    end: Offset.zero,
                  ).animate(_itemAnimations[2]),
                  child: SizedBox(
                    height: 380, // Fixed height for package cards carousel
                    child: PageView.builder(
                      itemCount: recommendations.length,
                      onPageChanged: (index) {
                        setState(() {
                          _selectedPackageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final recommendation = recommendations[index];
                        return _buildPackageCard(context, recommendation, index == _selectedPackageIndex);
                      },
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Page indicator
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, // Add this to fix layout
                  children: List.generate(recommendations.length, (index) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == _selectedPackageIndex
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      ),
                    );
                  }),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Action buttons
              FadeTransition(
                opacity: _itemAnimations[3],
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                  ).animate(_itemAnimations[3]),
                  child: Row(
                    mainAxisSize: MainAxisSize.max, // Ensure this row takes full width
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _viewPackageDetails,
                          icon: const Icon(Icons.info_outline),
                          label: const Text('View Details'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _bookTrip,
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('Book Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Start over button
              Center(
                child: TextButton.icon(
                  onPressed: widget.onRestart,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Start Over'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  ),
                ),
              ),
              
              // Add bottom padding to ensure content isn't cut off
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Hero image
                Image.network(
                  'https://picsum.photos/id/${100 + (widget.tripData['destination'].hashCode % 100).abs()}/800/400',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 180,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      child: Center(child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      )),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      child: const Center(child: Icon(Icons.error_outline)),
                    );
                  },
                ),
                
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.5, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                
                // Destination info
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.tripData['destination'],
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Colors.white.withOpacity(0.9),
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Best time to visit: ${widget.tripData['travelTime']}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                              ),
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
        ],
      ),
    );
  }

  Widget _buildPackageCard(BuildContext context, TravelRecommendation recommendation, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).cardColor.withOpacity(0.97),
            Theme.of(context).cardColor.withOpacity(0.85),
          ],
          stops: const [0.3, 1.0],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
              : Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.04),
          width: isSelected ? 2.0 : 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                : Colors.black.withOpacity(0.06),
            blurRadius: isSelected ? 15 : 8,
            spreadRadius: isSelected ? 1 : 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Package header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.9),
                  Theme.of(context).colorScheme.primary.withBlue(
                      Theme.of(context).colorScheme.primary.blue + 10).withOpacity(0.8),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 0.8,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recommendation.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        recommendation.duration,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '\$${recommendation.totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Package details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hotel info
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.hotel_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hotel',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                recommendation.hotelDetails.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber.shade400,
                                    size: 18,
                                  ),
                                  Text(
                                    ' ${recommendation.hotelDetails.rating}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    ' • \$${recommendation.hotelDetails.pricePerNight.toStringAsFixed(0)}/night',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const Divider(height: 24),
                    
                    // Flight info
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.flight_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Flight',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                recommendation.flightDetails.airline,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Departure: ${recommendation.flightDetails.departureTime}',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Return: ${recommendation.flightDetails.returnTime}',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                recommendation.flightDetails.stopCount == 0
                                    ? 'Direct flight'
                                    : '${recommendation.flightDetails.stopCount} stop',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const Divider(height: 24),
                    
                    // Activities
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.attractions_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Included Activities',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              ...recommendation.activities.map((activity) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('• ', style: TextStyle(fontSize: 14)),
                                    Expanded(
                                      child: Text(
                                        activity,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedView(BuildContext context, TravelRecommendation recommendation) {
    return FadeTransition(
      opacity: widget.fadeAnimation,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button and title
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _closeDetailView,
                ),
                Expanded(
                  child: Text(
                    recommendation.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Destination image with rating
            SizedBox(
              height: 200,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://picsum.photos/id/${100 + (widget.tripData['destination'].hashCode % 100).abs()}/800/400',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: const Center(child: Icon(Icons.error_outline)),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber.shade300,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              recommendation.hotelDetails.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Detail sections - put content directly in the column, no fixed height container
            // Package summary
            Text(
              "Package Summary",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                    Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.15)
                      : Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  width: 0.8,
                ),
              ),
              child: Column(
                children: [
                  _buildDetailRow("Destination", widget.tripData['destination']),
                  _buildDetailRow("Duration", recommendation.duration),
                  _buildDetailRow("Total Price", "\$${recommendation.totalPrice.toStringAsFixed(2)}"),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Hotel details
            Text(
              "Hotel Details",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                    Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.15)
                      : Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  width: 0.8,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recommendation.hotelDetails.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("Price per night: \$${recommendation.hotelDetails.pricePerNight.toStringAsFixed(2)}"),
                  const SizedBox(height: 4),
                  Text("Rating: ${recommendation.hotelDetails.rating} stars"),
                  const SizedBox(height: 12),
                  Text(
                    "Features:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...recommendation.hotelDetails.features.map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(feature),
                      ],
                    ),
                  )),
                  
                  const SizedBox(height: 16),
                  const Text("Hotel Image:"),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      recommendation.hotelDetails.images[0],
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Flight details
            Text(
              "Flight Details",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                    Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.15)
                      : Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  width: 0.8,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recommendation.flightDetails.airline,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFlightDetailRow(
                    "Outbound",
                    recommendation.flightDetails.departureTime,
                    Icons.flight_takeoff,
                    context
                  ),
                  const SizedBox(height: 8),
                  _buildFlightDetailRow(
                    "Return",
                    recommendation.flightDetails.returnTime,
                    Icons.flight_land,
                    context
                  ),
                  const SizedBox(height: 12),
                  Text(
                    recommendation.flightDetails.stopCount == 0
                        ? "Direct flight"
                        : "${recommendation.flightDetails.stopCount} stop",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: recommendation.flightDetails.stopCount == 0
                          ? Colors.green
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Features:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...recommendation.flightDetails.features.map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(feature),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Activities
            Text(
              "Included Activities",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                    Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.15)
                      : Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  width: 0.8,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...recommendation.activities.map((activity) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 10,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            activity,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Accessibility features
            Text(
              "Accessibility",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                    Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.15)
                      : Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  width: 0.8,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...recommendation.accessibilityFeatures.map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.accessible_outlined,
                          color: Theme.of(context).colorScheme.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(feature),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _closeDetailView,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _bookTrip,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Book Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBookingConfirmation(BuildContext context, TravelRecommendation recommendation) {
    return FadeTransition(
      opacity: widget.fadeAnimation,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Add mainAxisSize.min to prevent unbounded height issue
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Confirm Your Booking",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Please review your booking details before confirming.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Booking summary card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.surface.withOpacity(0.97),
                    Theme.of(context).colorScheme.surface.withOpacity(0.85),
                  ],
                  stops: const [0.3, 1.0],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                    spreadRadius: 0.5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Add mainAxisSize.min to all Column widgets
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ...existing code...
                  // Keep the rest of this method the same
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          recommendation.hotelDetails.images[0],
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              recommendation.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.tripData['destination'],
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const Divider(height: 24),
                  
                  // Package details
                  _buildDetailRow("Package", recommendation.title),
                  _buildDetailRow("Duration", recommendation.duration),
                  _buildDetailRow("Hotel", recommendation.hotelDetails.name),
                  _buildDetailRow("Flight", recommendation.flightDetails.airline),
                  _buildDetailRow("Departure", recommendation.flightDetails.departureTime),
                  _buildDetailRow("Return", recommendation.flightDetails.returnTime),
                  
                  const Divider(height: 24),
                  
                  // User details (already available)
                  Text(
                    "Booking For:",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow("Name", "John Doe"),
                  _buildDetailRow("Email", "john.doe@example.com"),
                  _buildDetailRow("Phone", "+1 555-123-4567"),
                  
                  const Divider(height: 24),
                  
                  // Price summary
                  _buildDetailRow("Hotel Cost", "\$${(recommendation.hotelDetails.pricePerNight * 4).toStringAsFixed(2)}"),
                  _buildDetailRow("Flight Cost", "\$${recommendation.flightDetails.price.toStringAsFixed(2)}"),
                  _buildDetailRow("Taxes & Fees", "\$${(recommendation.totalPrice * 0.1).toStringAsFixed(2)}"),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "Total Price:",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "\$${recommendation.totalPrice.toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Payment method
                  Text(
                    "Payment Method:",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.credit_card,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        const Text("Visa ending in 4567"),
                        const Spacer(),
                        Text(
                          "Change",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Terms and conditions checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: true,
                  onChanged: (value) {},
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                Expanded(
                  child: Text(
                    "I agree to the Terms and Conditions and Privacy Policy. I confirm that all provided information is correct.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _cancelBooking,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _confirmBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Confirm Booking'),
                  ),
                ),
              ],
            ),
            
            // Bottom padding
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFlightDetailRow(String label, String value, IconData icon, BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          "$label:",
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}