import 'package:flutter/material.dart';
import 'dart:math';
import '../models/ai_models.dart';

/// Widget that displays the itinerary creation phase of the travel planning process
class ItineraryCreationWidget extends StatefulWidget {
  /// The selected destination
  final String selectedDestination;
  
  /// The travel time period
  final String travelTime;
  
  /// The selected interest category
  final String selectedInterest;
  
  /// Research data from previous phase
  final Map<String, dynamic> researchData;
  
  /// Contingency plan data from previous phase
  final Map<String, dynamic> contingencyPlanData;
  
  /// Animation for fade effect
  final Animation<double> fadeAnimation;
  
  /// Animation for slide effect
  final Animation<Offset> slideAnimation;
  
  /// Callback when itinerary creation is complete
  final Function(Map<String, dynamic>) onItineraryCreationComplete;

  const ItineraryCreationWidget({
    super.key,
    required this.selectedDestination,
    required this.travelTime,
    required this.selectedInterest,
    required this.researchData,
    required this.contingencyPlanData,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.onItineraryCreationComplete,
  });

  @override
  State<ItineraryCreationWidget> createState() => _ItineraryCreationWidgetState();
}

class _ItineraryCreationWidgetState extends State<ItineraryCreationWidget> with SingleTickerProviderStateMixin {
  final List<ItineraryDay> _itineraryDays = [];
  int _selectedDayIndex = 0;
  late TabController _tabController;
  int _numberOfDays = 3; // Default number of days
  bool _isGeneratingItinerary = true;
  final Map<String, dynamic> _itineraryData = {};
  
  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(length: _numberOfDays, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedDayIndex = _tabController.index;
      });
    });
    
    // Generate itinerary after a short delay to simulate processing
    Future.delayed(const Duration(seconds: 2), () {
      _generateItinerary();
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  void _generateItinerary() {
    // Generate sample itinerary data based on destination and interest
    final List<ItineraryDay> days = [];
    
    // Day 1: Arrival and Orientation
    days.add(
      ItineraryDay(
        title: "Day 1: Arrival & Orientation",
        activities: [
          ItineraryActivity(
            title: "Airport Transfer",
            description: "Transportation to your accommodation",
            time: "Upon arrival",
            duration: 45,
          ),
          ItineraryActivity(
            title: "Check-in & Refresh",
            description: "Get settled in your accommodation",
            time: "Afternoon",
            duration: 60,
          ),
          ItineraryActivity(
            title: "Welcome Dinner",
            description: "Enjoy local cuisine at a popular restaurant",
            time: "7:00 PM",
            location: "Downtown",
            price: 45.0,
            duration: 90,
          ),
          ItineraryActivity(
            title: "Evening Stroll",
            description: "Light walk to orient yourself in the area",
            time: "9:00 PM",
            location: "Near accommodation",
            duration: 45,
          ),
        ],
        imageUrl: "https://picsum.photos/id/164/600/400",
        weather: "Partly Cloudy",
        temperature: 22.0,
      )
    );
    
    // Day 2: Exploring Main Attractions
    days.add(
      ItineraryDay(
        title: "Day 2: Main Attractions",
        activities: [
          ItineraryActivity(
            title: "Breakfast",
            description: "Morning meal at your accommodation or local café",
            time: "8:00 AM",
            price: 15.0,
            duration: 60,
          ),
          ItineraryActivity(
            title: "Cultural Tour",
            description: "Guided tour of the main historical sites",
            time: "10:00 AM",
            location: "City Center",
            price: 35.0,
            duration: 180,
          ),
          ItineraryActivity(
            title: "Lunch Break",
            description: "Midday meal at a local favorite spot",
            time: "1:30 PM",
            price: 25.0,
            duration: 60,
          ),
          ItineraryActivity(
            title: "Landmark Visit",
            description: "Explore the most iconic site in ${widget.selectedDestination}",
            time: "3:00 PM",
            price: 20.0,
            duration: 120,
          ),
          ItineraryActivity(
            title: "Dinner & Entertainment",
            description: "Evening meal with local entertainment",
            time: "7:30 PM",
            price: 55.0,
            duration: 120,
          ),
        ],
        imageUrl: "https://picsum.photos/id/165/600/400",
        weather: "Sunny",
        temperature: 24.0,
      )
    );
    
    // Day 3: Activity based on interest
    final String title = widget.selectedInterest == "beach" 
        ? "Beach & Relaxation" 
        : widget.selectedInterest == "mountain" 
            ? "Nature Exploration" 
            : widget.selectedInterest == "city" 
                ? "Urban Discovery" 
                : "Local Experiences";
                
    final List<ItineraryActivity> day3Activities = [];
    
    if (widget.selectedInterest == "beach") {
      day3Activities.addAll([
        ItineraryActivity(
          title: "Beach Day",
          description: "Relax on the beautiful beaches of ${widget.selectedDestination}",
          time: "10:00 AM",
          location: "Main Beach",
          duration: 240,
        ),
        ItineraryActivity(
          title: "Water Activity",
          description: "Optional snorkeling or boat tour",
          time: "2:00 PM",
          price: 45.0,
          duration: 120,
        ),
      ]);
    } else if (widget.selectedInterest == "mountain") {
      day3Activities.addAll([
        ItineraryActivity(
          title: "Guided Hike",
          description: "Explore the natural beauty with a local guide",
          time: "9:00 AM",
          location: "Nature reserve",
          price: 40.0,
          duration: 240,
        ),
        ItineraryActivity(
          title: "Picnic Lunch",
          description: "Enjoy a meal with scenic views",
          time: "1:00 PM",
          price: 25.0,
          duration: 90,
        ),
      ]);
    } else {
      day3Activities.addAll([
        ItineraryActivity(
          title: "Local Experience",
          description: "Immersive activity based on your interests",
          time: "10:00 AM",
          price: 35.0,
          duration: 180,
        ),
        ItineraryActivity(
          title: "Free Exploration",
          description: "Time to discover places on your own",
          time: "2:00 PM",
          duration: 180,
        ),
      ]);
    }
    
    // Add farewell dinner to day 3
    day3Activities.add(
      ItineraryActivity(
        title: "Farewell Dinner",
        description: "Special meal to conclude your trip",
        time: "7:00 PM",
        price: 60.0,
        duration: 120,
      ),
    );
    
    days.add(
      ItineraryDay(
        title: "Day 3: $title",
        activities: day3Activities,
        imageUrl: "https://picsum.photos/id/166/600/400",
        weather: "Clear",
        temperature: 23.0,
      )
    );
    
    // Update state with generated itinerary
    setState(() {
      _itineraryDays.addAll(days);
      _isGeneratingItinerary = false;
      
      // Store itinerary data
      _itineraryData['days'] = days.length;
      _itineraryData['fullItinerary'] = days.map((day) {
        return {
          'title': day.title,
          'activities': day.activities.map((activity) {
            return {
              'title': activity.title,
              'time': activity.time,
              'description': activity.description,
              'location': activity.location,
              'price': activity.price,
              'duration': activity.duration,
            };
          }).toList(),
        };
      }).toList();
    });
  }
  
  void _completeItineraryCreation() {
    widget.onItineraryCreationComplete(_itineraryData);
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
              "Itinerary Creation",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Here's your personalized daily itinerary for ${widget.selectedDestination}.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            
            if (_isGeneratingItinerary) ...[
              // Loading state
              Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 24),
                    Text(
                      "Creating your personalized itinerary...",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Considering your interests, travel time, and destination",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Tab bar for day selection
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs: List.generate(_itineraryDays.length, (index) {
                    return Tab(
                      text: "Day ${index + 1}",
                    );
                  }),
                  dividerColor: Colors.transparent,
                  labelColor: Theme.of(context).colorScheme.primary,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Current day content
              if (_itineraryDays.isNotEmpty) ...[
                _buildDayContent(_itineraryDays[_selectedDayIndex], context),
              ],
              
              const SizedBox(height: 24),
              
              // Continue button
              Center(
                child: ElevatedButton(
                  onPressed: _completeItineraryCreation,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text("Continue to Booking"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildDayContent(ItineraryDay day, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Day header with image
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: NetworkImage(day.imageUrl ?? "https://picsum.photos/id/164/600/400"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
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
            padding: const EdgeInsets.all(16),
            alignment: Alignment.bottomLeft,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      if (day.weather != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              day.weather == "Sunny" ? Icons.wb_sunny_outlined :
                              day.weather == "Clear" ? Icons.nights_stay_outlined :
                              Icons.cloud_outlined,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${day.weather}, ${day.temperature}°C",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.schedule,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Full day",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Day timeline
        ...day.activities.map((activity) => _buildActivityCard(activity, context)),
      ],
    );
  }
  
  Widget _buildActivityCard(ItineraryActivity activity, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time column
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  activity.time,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 2,
                height: 80,
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),
            ],
          ),
          const SizedBox(width: 16),
          
          // Activity details
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          activity.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (activity.duration != null) ...[
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${activity.duration} min",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(activity.description),
                  if (activity.location != null || activity.price != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (activity.location != null) ...[
                          Icon(
                            Icons.place,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            activity.location!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        if (activity.price != null) ...[
                          Icon(
                            Icons.attach_money,
                            size: 16,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "\$${activity.price!.toStringAsFixed(0)}",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItineraryDay {
  final String title;
  final List<ItineraryActivity> activities;
  final String? imageUrl;
  final String? weather;
  final double? temperature;
  
  ItineraryDay({
    required this.title,
    required this.activities,
    this.imageUrl,
    this.weather,
    this.temperature,
  });
}

class ItineraryActivity {
  final String title;
  final String description;
  final String time;
  final int duration; // in minutes
  final double? price; // optional price
  final String? location; // optional location
  
  ItineraryActivity({
    required this.title,
    required this.description,
    required this.time,
    required this.duration,
    this.price,
    this.location,
  });
}