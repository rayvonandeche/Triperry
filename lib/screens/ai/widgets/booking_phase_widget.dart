import 'package:flutter/material.dart';
import '../models/ai_models.dart';

/// Widget that displays the booking phase of the travel planning process
class BookingPhaseWidget extends StatefulWidget {
  /// The selected destination
  final String selectedDestination;
  
  /// The travel time period
  final String travelTime;
  
  /// Full itinerary data from previous phases
  final Map<String, dynamic> itineraryData;
  
  /// Budget information
  final BudgetRange budgetRange;
  
  /// Animation for fade effect
  final Animation<double> fadeAnimation;
  
  /// Animation for slide effect
  final Animation<Offset> slideAnimation;
  
  /// Callback when booking is complete
  final Function(Map<String, dynamic>) onBookingComplete;

  const BookingPhaseWidget({
    super.key,
    required this.selectedDestination,
    required this.travelTime,
    required this.itineraryData,
    required this.budgetRange,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.onBookingComplete,
  });

  @override
  State<BookingPhaseWidget> createState() => _BookingPhaseWidgetState();
}

class _BookingPhaseWidgetState extends State<BookingPhaseWidget> {
  int _currentStep = 0;
  bool _isLoadingFlights = true;
  bool _isLoadingAccommodation = false;
  bool _isLoadingActivities = false;
  
  // Flight options
  List<FlightOption> _flightOptions = [];
  FlightOption? _selectedFlight;
  
  // Accommodation options
  List<AccommodationOption> _accommodationOptions = [];
  AccommodationOption? _selectedAccommodation;
  
  // Activity booking options
  List<ActivityBookingOption> _activityOptions = [];
  final List<ActivityBookingOption> _selectedActivities = [];
  
  // Booking summary
  final Map<String, dynamic> _bookingData = {};
  
  @override
  void initState() {
    super.initState();
    
    // Simulate loading flight options
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoadingFlights = false;
        _flightOptions = _generateFlightOptions();
      });
    });
  }
  
  List<FlightOption> _generateFlightOptions() {
    // Generate sample flight options based on destination and budget
    final List<FlightOption> options = [];
    
    // Budget airline option
    options.add(
      FlightOption(
        airline: 'EconoAir',
        departureTime: '08:15',
        departureDate: 'Jun 15, 2025',
        arrivalTime: '14:30',
        arrivalDate: 'Jun 15, 2025',
        returnDepartureTime: 'Jun 22, 2025 10:45',
        returnArrivalTime: 'Jun 22, 2025 17:05',
        price: widget.budgetRange.min * 0.3,
        duration: '6h 15m',
        stopCount: 1,
        stopLocations: ['Frankfurt'],
        baggageAllowance: '1 checked bag (23kg)',
        flightNumbers: ['EC1234', 'EC5678'],
        aircraftType: 'Boeing 737-800',
        amenities: ['In-flight entertainment', 'Meals available for purchase'],
        cancellationPolicy: 'Non-refundable',
        ecoFriendlyScore: 3.5,
      ),
    );
    
    // Mid-range airline option
    options.add(
      FlightOption(
        airline: 'Continental Airways',
        departureTime: '10:30',
        departureDate: 'Jun 15, 2025',
        arrivalTime: '16:15',
        arrivalDate: 'Jun 15, 2025',
        returnDepartureTime: 'Jun 22, 2025 11:20',
        returnArrivalTime: 'Jun 22, 2025 17:10',
        price: widget.budgetRange.min * 0.4,
        duration: '5h 45m',
        stopCount: 0,
        baggageAllowance: '2 checked bags (23kg each)',
        flightNumbers: ['CA789', 'CA790'],
        aircraftType: 'Airbus A320neo',
        amenities: ['Wi-Fi', 'Complimentary meals', 'USB charging'],
        cancellationPolicy: 'Cancellation fee applies within 48 hours',
        ecoFriendlyScore: 4.0,
      ),
    );
    
    // Premium airline option
    options.add(
      FlightOption(
        airline: 'LuxuryJet',
        departureTime: '12:45',
        departureDate: 'Jun 15, 2025',
        arrivalTime: '18:20',
        arrivalDate: 'Jun 15, 2025',
        returnDepartureTime: 'Jun 22, 2025 14:15',
        returnArrivalTime: 'Jun 22, 2025 19:50',
        price: widget.budgetRange.min * 0.5,
        duration: '5h 35m',
        stopCount: 0,
        baggageAllowance: '2 checked bags (32kg each)',
        flightNumbers: ['LX501', 'LX502'],
        aircraftType: 'Boeing 787 Dreamliner',
        amenities: ['Premium Wi-Fi', 'Multi-course meals', 'Lie-flat seats', 'Lounge access'],
        cancellationPolicy: 'Free cancellation up to 24 hours before departure',
        ecoFriendlyScore: 4.8,
        cabinClass: 'Business',
      ),
    );
    
    return options;
  }
  
  List<AccommodationOption> _generateAccommodationOptions() {
    // Generate sample accommodation options based on destination and budget
    final List<AccommodationOption> options = [];
    
    // Budget accommodation
    options.add(
      AccommodationOption(
        name: 'City Center Hostel',
        type: 'Hostel',
        address: '123 Main Street, ${widget.selectedDestination}',
        rating: 4.1,
        price: widget.budgetRange.min * 0.05,
        priceUnit: 'night',
        imageUrl: 'https://picsum.photos/id/164/600/400',
        amenities: [
          'Free Wi-Fi',
          'Shared kitchen',
          'Locker storage',
          'Common area',
          '24-hour reception',
        ],
        reviews: 128,
        distanceToCenter: '0.5 km',
      ),
    );
    
    // Mid-range accommodation
    options.add(
      AccommodationOption(
        name: 'Comfort Inn & Suites',
        type: 'Hotel',
        address: '456 Harbor Road, ${widget.selectedDestination}',
        rating: 4.5,
        price: widget.budgetRange.min * 0.1,
        priceUnit: 'night',
        imageUrl: 'https://picsum.photos/id/165/600/400',
        amenities: [
          'Free Wi-Fi',
          'Breakfast included',
          'Swimming pool',
          'Fitness center',
          'Room service',
          'Air conditioning',
        ],
        reviews: 342,
        distanceToCenter: '1.2 km',
        roomTypes: ['Standard', 'Deluxe', 'Family Suite'],
      ),
    );
    
    // Luxury accommodation
    options.add(
      AccommodationOption(
        name: 'Grand Palace Resort',
        type: 'Resort',
        address: '789 Beachfront Avenue, ${widget.selectedDestination}',
        rating: 4.8,
        price: widget.budgetRange.min * 0.15,
        priceUnit: 'night',
        imageUrl: 'https://picsum.photos/id/166/600/400',
        amenities: [
          'High-speed Wi-Fi',
          'Gourmet breakfast',
          'Infinity pool',
          'Spa and wellness center',
          'Multiple restaurants',
          'Concierge service',
          'Beach access',
          'Luxury toiletries',
          'Turndown service',
        ],
        reviews: 506,
        distanceToCenter: '3.5 km',
        roomTypes: ['Deluxe Room', 'Ocean View Suite', 'Presidential Suite'],
        cancellationPolicy: 'Free cancellation up to 7 days before check-in',
      ),
    );
    
    return options;
  }
  
  List<ActivityBookingOption> _generateActivityOptions() {
    // Generate sample activity booking options based on destination and itinerary
    final List<ActivityBookingOption> options = [];
    
    // City tour
    options.add(
      ActivityBookingOption(
        name: '${widget.selectedDestination} City Tour',
        type: 'Guided Tour',
        duration: '3 hours',
        price: widget.budgetRange.min * 0.03,
        imageUrl: 'https://picsum.photos/id/167/600/400',
        description: 'Explore the history and culture of ${widget.selectedDestination} with a knowledgeable local guide.',
        rating: 4.6,
        reviews: 231,
        timeSlots: ['9:00 AM', '2:00 PM'],
        includedItems: ['Professional guide', 'Hotel pickup and drop-off'],
        languages: ['English', 'Spanish', 'French'],
      ),
    );
    
    // Cooking class
    options.add(
      ActivityBookingOption(
        name: 'Local Cuisine Cooking Class',
        type: 'Workshop',
        duration: '4 hours',
        price: widget.budgetRange.min * 0.04,
        imageUrl: 'https://picsum.photos/id/168/600/400',
        description: 'Learn to cook traditional dishes from ${widget.selectedDestination} with a professional chef.',
        rating: 4.9,
        reviews: 87,
        timeSlots: ['10:00 AM'],
        includedItems: ['Ingredients', 'Recipe book', 'Lunch'],
        languages: ['English'],
      ),
    );
    
    // Outdoor adventure
    options.add(
      ActivityBookingOption(
        name: 'Hiking Adventure',
        type: 'Outdoor Activity',
        duration: '6 hours',
        price: widget.budgetRange.min * 0.05,
        imageUrl: 'https://picsum.photos/id/169/600/400',
        description: 'Hike through the beautiful natural landscapes surrounding ${widget.selectedDestination}.',
        rating: 4.7,
        reviews: 142,
        timeSlots: ['8:00 AM'],
        includedItems: ['Guide', 'Transportation', 'Packed lunch', 'Water'],
        requirements: ['Good physical condition', 'Appropriate footwear'],
      ),
    );
    
    // Cultural experience
    options.add(
      ActivityBookingOption(
        name: 'Evening Cultural Show',
        type: 'Entertainment',
        duration: '2 hours',
        price: widget.budgetRange.min * 0.025,
        imageUrl: 'https://picsum.photos/id/170/600/400',
        description: 'Enjoy traditional music and dance performances from ${widget.selectedDestination}.',
        rating: 4.5,
        reviews: 189,
        timeSlots: ['7:00 PM', '9:00 PM'],
        includedItems: ['Welcome drink', 'Program guide'],
      ),
    );
    
    return options;
  }
  
  void _selectFlight(FlightOption flight) {
    setState(() {
      _selectedFlight = flight;
      // Load accommodation options after flight selection
      _isLoadingAccommodation = true;
    });
    
    // Simulate loading accommodation options
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoadingAccommodation = false;
        _accommodationOptions = _generateAccommodationOptions();
      });
    });
  }
  
  void _selectAccommodation(AccommodationOption accommodation) {
    setState(() {
      _selectedAccommodation = accommodation;
      // Load activity booking options after accommodation selection
      _isLoadingActivities = true;
    });
    
    // Simulate loading activity booking options
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoadingActivities = false;
        _activityOptions = _generateActivityOptions();
      });
    });
  }
  
  void _toggleActivitySelection(ActivityBookingOption activity) {
    setState(() {
      if (_selectedActivities.contains(activity)) {
        _selectedActivities.remove(activity);
      } else {
        _selectedActivities.add(activity);
      }
    });
  }
  
  void _continueToNextStep() {
    if (_currentStep == 0 && _selectedFlight != null) {
      setState(() {
        _currentStep = 1;
      });
    } else if (_currentStep == 1 && _selectedAccommodation != null) {
      setState(() {
        _currentStep = 2;
      });
    } else if (_currentStep == 2) {
      setState(() {
        _currentStep = 3;
      });
      
      // Prepare booking summary data
      _prepareBookingSummary();
    }
  }
  
  void _prepareBookingSummary() {
    // Calculate total cost
    double totalCost = 0;
    
    if (_selectedFlight != null) {
      totalCost += _selectedFlight!.price;
    }
    
    // Calculate accommodation cost for the duration
    if (_selectedAccommodation != null) {
      // Extract number of days from travel time (simple implementation)
      final int daysCount = 7; // In a real app, calculate from widget.travelTime
      totalCost += _selectedAccommodation!.price * daysCount;
    }
    
    // Add costs for selected activities
    for (final activity in _selectedActivities) {
      totalCost += activity.price;
    }
    
    // Prepare booking data
    _bookingData['flight'] = _selectedFlight != null ? {
      'airline': _selectedFlight!.airline,
      'departureDate': _selectedFlight!.departureDate,
      'departureTime': _selectedFlight!.departureTime,
      'returnDate': _selectedFlight!.returnDepartureTime.split(' ')[0],
      'price': _selectedFlight!.price,
      'flightNumbers': _selectedFlight!.flightNumbers,
    } : null;
    
    _bookingData['accommodation'] = _selectedAccommodation != null ? {
      'name': _selectedAccommodation!.name,
      'type': _selectedAccommodation!.type,
      'address': _selectedAccommodation!.address,
      'pricePerNight': _selectedAccommodation!.price,
      'totalAccommodationCost': _selectedAccommodation!.price * 7, // Assuming 7 days
    } : null;
    
    _bookingData['activities'] = _selectedActivities.map((activity) => {
      'name': activity.name,
      'type': activity.type,
      'price': activity.price,
      'duration': activity.duration,
    }).toList();
    
    _bookingData['totalCost'] = totalCost;
    _bookingData['destination'] = widget.selectedDestination;
    _bookingData['travelTime'] = widget.travelTime;
  }
  
  void _completeBooking() {
    widget.onBookingComplete(_bookingData);
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
              "Booking",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Let's book your trip to ${widget.selectedDestination}.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            
            // Stepper UI
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              child: Row(
                children: [
                  _buildStepIndicator(0, "Flights", _currentStep >= 0),
                  _buildStepConnector(_currentStep >= 1),
                  _buildStepIndicator(1, "Accommodation", _currentStep >= 1),
                  _buildStepConnector(_currentStep >= 2),
                  _buildStepIndicator(2, "Activities", _currentStep >= 2),
                  _buildStepConnector(_currentStep >= 3),
                  _buildStepIndicator(3, "Summary", _currentStep >= 3),
                ],
              ),
            ),
            
            // Step content
            Expanded(
              child: SingleChildScrollView(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildCurrentStepContent(),
                ),
              ),
            ),
            
            // Bottom navigation
            if (_currentStep < 3) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _currentStep > 0
                        ? () {
                            setState(() {
                              _currentStep--;
                            });
                          }
                        : null,
                    child: const Text("Back"),
                  ),
                  ElevatedButton(
                    onPressed: _canContinue() ? _continueToNextStep : null,
                    child: const Text("Continue"),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _completeBooking,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: const Text("Complete Booking"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  bool _canContinue() {
    if (_currentStep == 0) {
      return _selectedFlight != null;
    } else if (_currentStep == 1) {
      return _selectedAccommodation != null;
    } else {
      return true; // Activities are optional
    }
  }
  
  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildFlightSelectionStep();
      case 1:
        return _buildAccommodationSelectionStep();
      case 2:
        return _buildActivityBookingStep();
      case 3:
        return _buildBookingSummaryStep();
      default:
        return const SizedBox.shrink();
    }
  }
  
  Widget _buildStepIndicator(int step, String label, bool isActive) {
    final isCurrent = _currentStep == step;
    
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isActive
                  ? (isCurrent
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primaryContainer)
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                isCurrent
                    ? Icons.edit
                    : (isActive ? Icons.check : Icons.circle_outlined),
                size: 16,
                color: isActive
                    ? (isCurrent
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.primary)
                    : Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildStepConnector(bool isActive) {
    return Container(
      width: 20,
      height: 2,
      color: isActive
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.outline.withOpacity(0.5),
    );
  }
  
  Widget _buildFlightSelectionStep() {
    if (_isLoadingFlights) {
      return _buildLoadingIndicator("Searching for flights...");
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select your flight to ${widget.selectedDestination}",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        
        // Flight options list
        ..._flightOptions.map((flight) => _buildFlightCard(flight)),
      ],
    );
  }
  
  Widget _buildFlightCard(FlightOption flight) {
    final isSelected = _selectedFlight == flight;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => _selectFlight(flight),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Airline and price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.flight,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        flight.airline,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (flight.cabinClass != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            flight.cabinClass!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    "\$${flight.price.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Flight details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Departure info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        flight.departureTime,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        flight.departureDate,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                  
                  // Flight duration
                  Column(
                    children: [
                      Text(
                        flight.duration,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 2,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Icon(
                            Icons.flight,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          Expanded(
                            child: Container(
                              height: 2,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        flight.stopCount == 0
                            ? "Nonstop"
                            : "${flight.stopCount} stop${flight.stopCount > 1 ? 's' : ''}",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                  
                  // Arrival info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        flight.arrivalTime,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        flight.arrivalDate,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              
              // Return flight summary
              Row(
                children: [
                  Icon(
                    Icons.flight_takeoff,
                    size: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Return: ${flight.returnDepartureTime} - ${flight.returnArrivalTime}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Flight amenities
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: flight.amenities.map((amenity) {
                  return Chip(
                    label: Text(
                      amenity,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                    ),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
              
              if (isSelected) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Selected for booking",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildAccommodationSelectionStep() {
    if (_isLoadingAccommodation) {
      return _buildLoadingIndicator("Finding accommodations...");
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select your accommodation in ${widget.selectedDestination}",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        
        // Accommodation options list
        ..._accommodationOptions.map((accommodation) => _buildAccommodationCard(accommodation)),
      ],
    );
  }
  
  Widget _buildAccommodationCard(AccommodationOption accommodation) {
    final isSelected = _selectedAccommodation == accommodation;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => _selectAccommodation(accommodation),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Accommodation image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                accommodation.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Accommodation name and price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              accommodation.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              accommodation.type,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "\$${accommodation.price.toStringAsFixed(0)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            "per ${accommodation.priceUnit}",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Rating and reviews
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        accommodation.rating.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "(${accommodation.reviews} reviews)",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        accommodation.distanceToCenter,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Address
                  Text(
                    accommodation.address,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  
                  // Amenities
                  Text(
                    "Amenities",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: accommodation.amenities.map((amenity) {
                      return Chip(
                        label: Text(
                          amenity,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                        ),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    }).toList(),
                  ),
                  
                  if (isSelected) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Selected for booking",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActivityBookingStep() {
    if (_isLoadingActivities) {
      return _buildLoadingIndicator("Finding activities...");
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select activities in ${widget.selectedDestination}",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Choose activities to enhance your trip. This step is optional.",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(height: 24),
        
        // Activity options list
        ..._activityOptions.map((activity) => _buildActivityCard(activity)),
      ],
    );
  }
  
  Widget _buildActivityCard(ActivityBookingOption activity) {
    final isSelected = _selectedActivities.contains(activity);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isSelected ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => _toggleActivitySelection(activity),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Activity image with type badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    activity.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
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
                      activity.type,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // Selected indicator
                if (isSelected)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 16,
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
                  // Activity name and price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          activity.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        "\$${activity.price.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  
                  // Rating and duration
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        activity.rating.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "(${activity.reviews})",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        activity.duration,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Description
                  Text(
                    activity.description,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Time slots
                  if (activity.timeSlots.isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Available times: ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          activity.timeSlots.join(", "),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                  
                  // Included items
                  if (activity.includedItems.isNotEmpty) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 16,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "Includes: ${activity.includedItems.join(", ")}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  
                  const SizedBox(height: 8),
                  
                  // Add/Remove button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _toggleActivitySelection(activity),
                      icon: Icon(
                        isSelected ? Icons.remove : Icons.add,
                        size: 18,
                      ),
                      label: Text(isSelected ? "Remove" : "Add to Trip"),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isSelected
                              ? Colors.red.shade300
                              : Theme.of(context).colorScheme.primary,
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
  }
  
  Widget _buildBookingSummaryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Booking Summary",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Review your trip details before confirming your booking.",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(height: 24),
        
        // Trip overview
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Trip to ${widget.selectedDestination}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Duration: ${widget.travelTime}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Flight details
        if (_selectedFlight != null) ...[
          Text(
            "Flight",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedFlight!.airline,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Flight ${_selectedFlight!.flightNumbers.first}",
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.flight_takeoff,
                                size: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              const Text("Departure"),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${_selectedFlight!.departureDate} at ${_selectedFlight!.departureTime}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.flight_land,
                                size: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              const Text("Return"),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedFlight!.returnDepartureTime,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Price",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        "\$${_selectedFlight!.price.toStringAsFixed(0)}",
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
          ),
          const SizedBox(height: 16),
        ],
        
        // Accommodation details
        if (_selectedAccommodation != null) ...[
          Text(
            "Accommodation",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    _selectedAccommodation!.imageUrl,
                    height: 120,
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
                        _selectedAccommodation!.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedAccommodation!.address,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "7 nights",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "\$${(_selectedAccommodation!.price * 7).toStringAsFixed(0)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              Text(
                                "(\$${_selectedAccommodation!.price.toStringAsFixed(0)} × 7 nights)",
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodySmall?.color,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        
        // Activities details
        if (_selectedActivities.isNotEmpty) ...[
          Text(
            "Activities",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _selectedActivities.length,
            itemBuilder: (context, index) {
              final activity = _selectedActivities[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    activity.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    "${activity.duration} - ${activity.timeSlots.first}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  trailing: Text(
                    "\$${activity.price.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
        
        // Total price
        Card(
          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Flight",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      _selectedFlight != null
                          ? "\$${_selectedFlight!.price.toStringAsFixed(0)}"
                          : "\$0",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Accommodation (7 nights)",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      _selectedAccommodation != null
                          ? "\$${(_selectedAccommodation!.price * 7).toStringAsFixed(0)}"
                          : "\$0",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                if (_selectedActivities.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Activities (${_selectedActivities.length})",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        "\$${_selectedActivities.fold<double>(0, (sum, item) => sum + item.price).toStringAsFixed(0)}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "\$${_bookingData["totalCost"].toStringAsFixed(0)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildLoadingIndicator(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

/// Flight option data model
class FlightOption {
  final String airline;
  final String departureTime;
  final String departureDate;
  final String arrivalTime;
  final String arrivalDate;
  final String returnDepartureTime;
  final String returnArrivalTime;
  final double price;
  final String duration;
  final int stopCount;
  final List<String> stopLocations;
  final String baggageAllowance;
  final List<String> flightNumbers;
  final String aircraftType;
  final List<String> amenities;
  final String cancellationPolicy;
  final double ecoFriendlyScore;
  final String? cabinClass;

  FlightOption({
    required this.airline,
    required this.departureTime,
    required this.departureDate,
    required this.arrivalTime,
    required this.arrivalDate,
    required this.returnDepartureTime,
    required this.returnArrivalTime,
    required this.price,
    required this.duration,
    required this.stopCount,
    this.stopLocations = const [],
    required this.baggageAllowance,
    required this.flightNumbers,
    required this.aircraftType,
    required this.amenities,
    required this.cancellationPolicy,
    required this.ecoFriendlyScore,
    this.cabinClass,
  });
}

/// Accommodation option data model
class AccommodationOption {
  final String name;
  final String type;
  final String address;
  final double rating;
  final double price;
  final String priceUnit;
  final String imageUrl;
  final List<String> amenities;
  final int reviews;
  final String distanceToCenter;
  final List<String>? roomTypes;
  final String? cancellationPolicy;

  AccommodationOption({
    required this.name,
    required this.type,
    required this.address,
    required this.rating,
    required this.price,
    required this.priceUnit,
    required this.imageUrl,
    required this.amenities,
    required this.reviews,
    required this.distanceToCenter,
    this.roomTypes,
    this.cancellationPolicy,
  });
}

/// Activity booking option data model
class ActivityBookingOption {
  final String name;
  final String type;
  final String duration;
  final double price;
  final String imageUrl;
  final String description;
  final double rating;
  final int reviews;
  final List<String> timeSlots;
  final List<String> includedItems;
  final List<String>? requirements;
  final List<String>? languages;

  ActivityBookingOption({
    required this.name,
    required this.type,
    required this.duration,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.rating,
    required this.reviews,
    required this.timeSlots,
    required this.includedItems,
    this.requirements,
    this.languages,
  });
}