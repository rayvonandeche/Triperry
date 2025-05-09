import 'package:flutter/material.dart';

/// Widget that displays the itinerary creation phase of travel planning
class ItineraryCreationStage extends StatefulWidget {
  /// The selected destination
  final String selectedDestination;
  
  /// The selected travel time
  final String travelTime;
  
  /// Animation for slide effect
  final Animation<Offset> slideAnimation;
  
  /// Animation for fade effect
  final Animation<double> fadeAnimation;
  
  /// Callback when itinerary creation is complete
  final Function(Map<String, dynamic>) onItineraryComplete;

  const ItineraryCreationStage({
    super.key,
    required this.selectedDestination,
    required this.travelTime,
    required this.slideAnimation,
    required this.fadeAnimation,
    required this.onItineraryComplete,
  });

  @override
  State<ItineraryCreationStage> createState() => _ItineraryCreationStageState();
}

class _ItineraryCreationStageState extends State<ItineraryCreationStage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<ItineraryDay> _days = [];
  bool _isLoading = true;
  Map<String, dynamic> _itineraryData = {};
  bool _isCustomizing = false;
  
  @override
  void initState() {
    super.initState();
    
    // Generate itinerary days first, then set tab controller
    _generateItinerary().then((_) {
      if (mounted) {
        setState(() {
          _tabController = TabController(length: _days.length, vsync: this);
          _isLoading = false;
        });
      }
    });
  }
  
  @override
  void dispose() {
    if (!_isLoading) {
      _tabController.dispose();
    }
    super.dispose();
  }
  
  Future<void> _generateItinerary() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    
    // Using a 4-day itinerary for this example
    final days = [
      {
        'title': 'Day 1',
        'date': 'June 15, 2025',
        'weather': 'Sunny',
        'weatherTemp': 28,
        'activities': [
          {
            'time': '09:00 AM',
            'title': 'City Walking Tour',
            'description': 'Discover the highlights of ${widget.selectedDestination} with a local guide',
            'location': 'City Center',
            'category': 'Sightseeing',
            'duration': 180,
            'icon': Icons.tour,
          },
          {
            'time': '12:30 PM',
            'title': 'Lunch at Local Restaurant',
            'description': 'Enjoy authentic local cuisine',
            'location': 'Old Town',
            'category': 'Food',
            'duration': 90,
            'icon': Icons.restaurant,
          },
          {
            'time': '03:00 PM',
            'title': 'Museum Visit',
            'description': 'Explore the city\'s art and history',
            'location': 'National Museum',
            'category': 'Culture',
            'duration': 120,
            'icon': Icons.museum,
          },
          {
            'time': '06:30 PM',
            'title': 'Dinner Cruise',
            'description': 'Scenic dinner along the waterfront',
            'location': 'Harbor',
            'category': 'Food',
            'duration': 150,
            'icon': Icons.directions_boat,
          },
        ],
        'travelTime': widget.travelTime,
      },
      {
        'title': 'Day 2',
        'date': 'June 16, 2025',
        'weather': 'Partly Cloudy',
        'weatherTemp': 26,
        'activities': [
          {
            'time': '09:30 AM',
            'title': 'Local Market',
            'description': 'Shop for souvenirs and taste local products',
            'location': 'Farmer\'s Market',
            'category': 'Shopping',
            'duration': 120,
            'icon': Icons.shopping_basket,
          },
          {
            'time': '12:00 PM',
            'title': 'Lunch & Relaxation',
            'description': 'Casual lunch followed by relaxation time',
            'location': 'Beach Side Café',
            'category': 'Relaxation',
            'duration': 120,
            'icon': Icons.restaurant,
          },
          {
            'time': '03:00 PM',
            'title': 'Beach Time',
            'description': 'Relax at the beautiful beaches',
            'location': 'Golden Beach',
            'category': 'Relaxation',
            'duration': 180,
            'icon': Icons.beach_access,
          },
          {
            'time': '07:30 PM',
            'title': 'Seaside Dinner',
            'description': 'Fresh seafood with ocean views',
            'location': 'Ocean View Restaurant',
            'category': 'Food',
            'duration': 120,
            'icon': Icons.dinner_dining,
          },
        ],
        'travelTime': widget.travelTime,
      },
      {
        'title': 'Day 3',
        'date': 'June 17, 2025',
        'weather': 'Sunny',
        'weatherTemp': 29,
        'activities': [
          {
            'time': '08:00 AM',
            'title': 'Hiking Tour',
            'description': 'Guided nature hike with stunning views',
            'location': 'Mountain Trail',
            'category': 'Adventure',
            'duration': 240,
            'icon': Icons.landscape,
          },
          {
            'time': '01:30 PM',
            'title': 'Picnic Lunch',
            'description': 'Outdoor lunch with scenic views',
            'location': 'Viewpoint',
            'category': 'Food',
            'duration': 90,
            'icon': Icons.fastfood,
          },
          {
            'time': '04:00 PM',
            'title': 'Spa Treatment',
            'description': 'Relax with a massage and wellness treatments',
            'location': 'Wellness Center',
            'category': 'Relaxation',
            'duration': 120,
            'icon': Icons.spa,
          },
          {
            'time': '07:00 PM',
            'title': 'Cultural Show & Dinner',
            'description': 'Traditional performances and local cuisine',
            'location': 'Cultural Center',
            'category': 'Entertainment',
            'duration': 180,
            'icon': Icons.theater_comedy,
          },
        ],
        'travelTime': widget.travelTime,
      },
      {
        'title': 'Day 4',
        'date': 'June 18, 2025',
        'weather': 'Sunny',
        'weatherTemp': 27,
        'activities': [
          {
            'time': '10:00 AM',
            'title': 'Free Time & Shopping',
            'description': 'Explore on your own and shop for souvenirs',
            'location': 'Downtown',
            'category': 'Free Time',
            'duration': 180,
            'icon': Icons.shopping_bag,
          },
          {
            'time': '01:30 PM',
            'title': 'Farewell Lunch',
            'description': 'Final meal in ${widget.selectedDestination}',
            'location': 'Signature Restaurant',
            'category': 'Food',
            'duration': 120,
            'icon': Icons.lunch_dining,
          },
          {
            'time': '04:00 PM',
            'title': 'Airport Transfer',
            'description': 'Transportation to the airport for departure',
            'location': 'Hotel to Airport',
            'category': 'Transportation',
            'duration': 60,
            'icon': Icons.flight_takeoff,
          },
        ],
        'travelTime': widget.travelTime,
      },
    ];
    
    // Convert the raw data to ItineraryDay objects
    for (var day in days) {
      List<ItineraryActivity> activities = [];
      for (var activity in day['activities'] as List) {
        activities.add(
          ItineraryActivity(
            time: activity['time'],
            title: activity['title'],
            description: activity['description'],
            location: activity['location'],
            duration: activity['duration'],
            category: activity['category'],
          ),
        );
      }
      
      _days.add(
        ItineraryDay(
          title: day['title'] as String,
          date: day['date'] as String,
          activities: activities,
          weatherForecast: day['weather'] as String,
          travelTime: day['travelTime'] as String,
        ),
      );
    }
    
    // Prepare itinerary data for callback
    _itineraryData = {
      'destination': widget.selectedDestination,
      'travelTime': widget.travelTime,
      'days': _days.length,
      'startDate': _days.first.date,
      'endDate': _days.last.date,
      'activities': _days.fold<int>(0, (sum, day) => sum + day.activities.length),
      'itineraryGenerated': true,
    };
  }
  
  void _completeItinerary() {
    widget.onItineraryComplete(_itineraryData);
  }
  
  void _toggleCustomization() {
    setState(() {
      _isCustomizing = !_isCustomizing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.fadeAnimation,
      child: SlideTransition(
        position: widget.slideAnimation,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Itinerary for ${widget.selectedDestination}",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "We've created a personalized itinerary for your trip during ${widget.travelTime}. "
                    "You can review and make changes below.",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                        ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Itinerary controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${_days.length} Days Itinerary",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      OutlinedButton.icon(
                        onPressed: _toggleCustomization,
                        icon: Icon(_isCustomizing ? Icons.check : Icons.edit),
                        label: Text(_isCustomizing ? "Done" : "Customize"),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Day tabs
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    dividerColor: Colors.transparent,
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    tabs: _days
                        .map((day) => Tab(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(day.title),
                                  Text(
                                    day.date,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  
                  // Day content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: _days.map((day) => _buildDayItinerary(day, context)).toList(),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _completeItinerary,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Continue to Booking"),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
  
  Widget _buildDayItinerary(ItineraryDay day, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Weather info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  day.weatherForecast.contains('Sunny') 
                      ? Icons.wb_sunny 
                      : day.weatherForecast.contains('Rain') 
                          ? Icons.beach_access 
                          : Icons.cloud,
                  color: day.weatherForecast.contains('Sunny') 
                      ? Colors.orange 
                      : day.weatherForecast.contains('Rain') 
                          ? Colors.blue 
                          : Colors.grey,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Weather Forecast",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "${day.weatherForecast}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Activities timeline
          ...List.generate(
            day.activities.length, 
            (index) => _buildActivityItem(
              day.activities[index], 
              context, 
              index, 
              day.activities.length
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }
  
  Widget _buildActivityItem(ItineraryActivity activity, BuildContext context, int index, int total) {
    final bool isLast = index == total - 1;
    final Color categoryColor = _getCategoryColor(activity.category, context);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time column
        SizedBox(
          width: 80,
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              activity.time,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        
        // Timeline column
        SizedBox(
          width: 24,
          child: Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: categoryColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: categoryColor,
                    width: 2,
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 100,
                  color: Theme.of(context).dividerColor,
                ),
            ],
          ),
        ),
        
        // Content column
        Expanded(
          child: Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and category
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          activity.category,
                          style: TextStyle(
                            color: categoryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "${activity.duration} mins",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Activity title
                  Text(
                    activity.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Activity description
                  Text(
                    activity.description,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Location
                  if (activity.location != null)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          activity.location!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
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
    );
  }
  
  Color _getCategoryColor(String category, BuildContext context) {
    switch (category.toLowerCase()) {
      case 'sightseeing':
        return Colors.blue;
      case 'food':
        return Colors.orange;
      case 'culture':
        return Colors.purple;
      case 'adventure':
        return Colors.green;
      case 'relaxation':
        return Colors.teal;
      case 'shopping':
        return Colors.pink;
      case 'entertainment':
        return Colors.amber;
      case 'transportation':
        return Colors.red;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }
}

/// Represents a day in the itinerary
class ItineraryDay {
  final String title;
  final String date;
  final List<ItineraryActivity> activities;
  final String weatherForecast;
  final String travelTime;
  
  ItineraryDay({
    required this.title,
    required this.date,
    required this.activities,
    required this.weatherForecast,
    required this.travelTime,
  });
}

/// Represents an activity in the itinerary
class ItineraryActivity {
  final String time;
  final String title;
  final String description;
  final String? location;
  final IconData? icon;
  final String category;
  final int? duration;
  
  ItineraryActivity({
    required this.time,
    required this.title,
    required this.description,
    this.location,
    this.icon,
    required this.category,
    this.duration,
  });
}