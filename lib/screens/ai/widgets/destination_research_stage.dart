import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Widget that displays the destination research phase of travel planning
class DestinationResearchStage extends StatefulWidget {
  /// The selected destination to research
  final String destination;
  
  /// Animation for slide effect
  final Animation<Offset> slideAnimation;
  
  /// Animation for fade effect
  final Animation<double> fadeAnimation;
  
  /// Callback when research is complete
  final Function(Map<String, dynamic>) onResearchComplete;

  const DestinationResearchStage({
    super.key,
    required this.destination,
    required this.slideAnimation,
    required this.fadeAnimation,
    required this.onResearchComplete,
  });

  @override
  State<DestinationResearchStage> createState() => _DestinationResearchStageState();
}

class _DestinationResearchStageState extends State<DestinationResearchStage> with TickerProviderStateMixin {
  bool _isResearching = false;
  bool _researchCompleted = false;
  
  // Categories of information being researched
  List<ResearchCategory> _categories = [];
  
  // Controller for loading animation
  late AnimationController _loadingController;
  
  // Research data
  Map<String, dynamic> _researchData = {};
  
  @override
  void initState() {
    super.initState();
    
    // Initialize loading animation controller
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    
    // Define research categories
    _categories = [
      ResearchCategory(
        name: 'Weather',
        icon: Icons.wb_sunny,
        color: Colors.orange,
        details: const {
          'title': 'Climate Information',
          'subtitle': 'Seasonal variations and current conditions',
        },
      ),
      ResearchCategory(
        name: 'Culture',
        icon: Icons.theater_comedy,
        color: Colors.purple,
        details: const {
          'title': 'Local Customs & Traditions',
          'subtitle': 'Cultural norms, language, and etiquette',
        },
      ),
      ResearchCategory(
        name: 'Safety',
        icon: Icons.health_and_safety,
        color: Colors.blue,
        details: const {
          'title': 'Health & Safety',
          'subtitle': 'Local advisories, health recommendations',
        },
      ),
      ResearchCategory(
        name: 'Transit',
        icon: Icons.directions_bus,
        color: Colors.green,
        details: const {
          'title': 'Getting Around',
          'subtitle': 'Transportation options and connectivity',
        },
      ),
      ResearchCategory(
        name: 'Costs',
        icon: Icons.attach_money,
        color: Colors.amber,
        details: const {
          'title': 'Cost Analysis',
          'subtitle': 'Price levels and cost comparisons',
        },
      ),
    ];
  }
  
  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }
  
  void _startResearch() async {
    setState(() {
      _isResearching = true;
    });
    
    // Simulate API calls to gather information
    // In a real app, this would be actual API calls to travel information services
    
    // Generate research data for each category with simulated delays
    for (var category in _categories) {
      category.status = ResearchStatus.inProgress;
      setState(() {});
      
      // Simulate network delay
      await Future.delayed(Duration(milliseconds: math.Random().nextInt(2000) + 1000));
      
      // Generate fake data based on category
      final data = _generateCategoryData(category.name, widget.destination);
      
      // Update research data
      _researchData[category.name.toLowerCase()] = data;
      
      // Update category status
      category.status = ResearchStatus.completed;
      category.data = data;
      setState(() {});
    }
    
    // Complete research
    setState(() {
      _isResearching = false;
      _researchCompleted = true;
    });
  }
  
  Map<String, dynamic> _generateCategoryData(String category, String destination) {
    // This would be replaced with actual API calls in a real app
    switch (category.toLowerCase()) {
      case 'weather':
        return {
          'current': {
            'temperature': '${math.Random().nextInt(20) + 10}°C',
            'condition': _getRandomElement(['Sunny', 'Cloudy', 'Rainy', 'Partly Cloudy']),
          },
          'forecast': [
            {
              'day': 'Today',
              'high': '${math.Random().nextInt(10) + 20}°C',
              'low': '${math.Random().nextInt(10) + 10}°C',
              'condition': 'Sunny',
            },
            {
              'day': 'Tomorrow',
              'high': '${math.Random().nextInt(10) + 20}°C',
              'low': '${math.Random().nextInt(10) + 10}°C',
              'condition': 'Partly Cloudy',
            },
            {
              'day': 'Day 3',
              'high': '${math.Random().nextInt(10) + 20}°C',
              'low': '${math.Random().nextInt(10) + 10}°C',
              'condition': 'Rainy',
            },
          ],
          'bestTimeToVisit': _getRandomElement([
            'Spring (March-May)',
            'Summer (June-August)',
            'Fall (September-November)',
            'Winter (December-February)',
          ]),
        };
      case 'culture':
        return {
          'language': _getRandomElement(['English', 'Spanish', 'French', 'Italian', 'German']),
          'customs': [
            'Remove shoes before entering homes',
            'Tipping is ${math.Random().nextBool() ? 'expected' : 'not common'}',
            'Greet people with a ${_getRandomElement(['handshake', 'bow', 'nod'])}',
          ],
          'localCuisine': [
            _getRandomElement(['Pasta', 'Seafood', 'Street Food', 'Vegetarian dishes']),
            _getRandomElement(['Wine', 'Beer', 'Coffee', 'Tea']),
            _getRandomElement(['Desserts', 'Cheese', 'Fruits', 'Bread']),
          ],
          'events': [
            {
              'name': '${destination} Annual Festival',
              'date': 'July',
              'description': 'Major cultural celebration',
            },
            {
              'name': 'Local Music Event',
              'date': 'September',
              'description': 'Traditional music performances',
            },
          ],
        };
      case 'safety':
        return {
          'overallRisk': _getRandomElement(['Low', 'Moderate', 'High']),
          'healthAdvice': [
            'Tap water is ${math.Random().nextBool() ? 'safe to drink' : 'not recommended'}',
            'Medical facilities are ${_getRandomElement(['excellent', 'good', 'basic'])}',
            'Recommended vaccinations: ${math.Random().nextBool() ? 'None required' : 'Hepatitis A, Typhoid'}',
          ],
          'safetyTips': [
            'Keep valuables secure',
            'Be aware of surroundings in tourist areas',
            'Use registered taxis or ride-sharing services',
          ],
          'emergencyContacts': {
            'police': '${math.Random().nextInt(900) + 100}',
            'ambulance': '${math.Random().nextInt(900) + 100}',
            'touristPolice': '${math.Random().nextInt(900) + 100}',
          },
        };
      case 'transit':
        return {
          'localTransport': [
            {
              'type': 'Public Transit',
              'quality': _getRandomElement(['Excellent', 'Good', 'Average', 'Limited']),
              'cost': '${math.Random().nextInt(10) + 1} USD per ride',
            },
            {
              'type': 'Taxi',
              'availability': _getRandomElement(['Very Common', 'Common', 'Limited']),
              'costEstimate': '${math.Random().nextInt(20) + 5} USD for short trips',
            },
            {
              'type': 'Rental Car',
              'recommended': math.Random().nextBool(),
              'costPerDay': '${math.Random().nextInt(50) + 20} USD',
            },
          ],
          'gettingFromAirport': [
            'Taxi: ${math.Random().nextInt(30) + 20} USD',
            'Airport Shuttle: ${math.Random().nextInt(20) + 10} USD',
            'Public Transportation: ${math.Random().nextInt(10) + 5} USD',
          ],
          'walkability': _getRandomElement(['Excellent', 'Good', 'Average', 'Poor']),
        };
      case 'costs':
        return {
          'budgetEstimate': {
            'budget': '${math.Random().nextInt(50) + 50} USD/day',
            'midRange': '${math.Random().nextInt(100) + 100} USD/day',
            'luxury': '${math.Random().nextInt(300) + 200} USD/day',
          },
          'accommodation': {
            'hostel': '${math.Random().nextInt(30) + 20} USD/night',
            'budgetHotel': '${math.Random().nextInt(50) + 50} USD/night',
            'midrangeHotel': '${math.Random().nextInt(100) + 100} USD/night',
            'luxuryHotel': '${math.Random().nextInt(300) + 200} USD/night',
          },
          'mealCosts': {
            'budgetMeal': '${math.Random().nextInt(10) + 5} USD',
            'midrangeMeal': '${math.Random().nextInt(20) + 15} USD',
            'fineDining': '${math.Random().nextInt(50) + 40} USD',
          },
          'localCurrency': _getRandomElement(['USD', 'EUR', 'GBP', 'JPY']),
          'exchangeRate': '1 USD = ${(math.Random().nextDouble() * 10).toStringAsFixed(2)} local',
        };
      default:
        return {
          'message': 'No specific data available for $category in $destination',
        };
    }
  }
  
  String _getRandomElement(List<String> items) {
    return items[math.Random().nextInt(items.length)];
  }
  
  void _submitResearch() {
    // Add metadata to research
    final completeResearchData = {
      ..._researchData,
      'destination': widget.destination,
      'researchDate': DateTime.now().toString(),
      'researchCompleted': true,
    };
    
    // Call the callback
    widget.onResearchComplete(completeResearchData);
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
              "Destination Research",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Analyzing essential information about ${widget.destination} to help prepare for your journey.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            
            // Research categories
            ...(_isResearching || _researchCompleted
                ? _buildCategoryList()
                : [_buildStartResearchButton()]),
            
            const SizedBox(height: 24),
            
            // Continue button (only show when research is completed)
            if (_researchCompleted)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitResearch,
                  icon: const Icon(Icons.check_circle),
                  label: const Text("Continue to Planning"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStartResearchButton() {
    return Center(
      child: Column(
        children: [
          Image.asset(
            'lib/assets/images/research.png',
            height: 120,
            // If image doesn't exist, show an icon instead
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.search,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _startResearch,
              icon: const Icon(Icons.search),
              label: const Text("Start Destination Research"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "We'll gather essential information about ${widget.destination} to help you plan effectively.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
  
  List<Widget> _buildCategoryList() {
    return _categories.map((category) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: category.status == ResearchStatus.completed
                  ? category.color
                  : Theme.of(context).colorScheme.outline.withOpacity(0.5),
              width: 1.5,
            ),
            color: category.color.withOpacity(
              category.status == ResearchStatus.completed ? 0.1 : 0.05,
            ),
          ),
          child: ExpansionTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                category.icon,
                color: category.color,
                size: 24,
              ),
            ),
            title: Text(
              category.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(category.details['subtitle'] ?? ''),
            trailing: _buildCategoryStatus(category),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              category.status == ResearchStatus.completed
                  ? _buildCategoryDetails(category)
                  : const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
            ],
          ),
        ),
      );
    }).toList();
  }
  
  Widget _buildCategoryStatus(ResearchCategory category) {
    switch (category.status) {
      case ResearchStatus.notStarted:
        return const Icon(Icons.hourglass_empty);
      case ResearchStatus.inProgress:
        return AnimatedBuilder(
          animation: _loadingController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _loadingController.value * 2 * 3.14159,
              child: const Icon(Icons.sync, color: Colors.orange),
            );
          },
        );
      case ResearchStatus.completed:
        return const Icon(Icons.check_circle, color: Colors.green);
      default:
        return const SizedBox.shrink();
    }
  }
  
  Widget _buildCategoryDetails(ResearchCategory category) {
    // Build different content based on category type
    switch (category.name.toLowerCase()) {
      case 'weather':
        final weatherData = category.data as Map<String, dynamic>;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.wb_sunny,
                    color: Colors.orange,
                    size: 36,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current: ${weatherData['current']['temperature']}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        "${weatherData['current']['condition']}",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              const Text("Forecast", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: (weatherData['forecast'] as List).map<Widget>((day) {
                  return Column(
                    children: [
                      Text(day['day'], style: const TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(day['high']),
                      Text(day['low'], style: TextStyle(color: Colors.grey)),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Best time to visit: ${weatherData['bestTimeToVisit']}",
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      
      case 'safety':
        final safetyData = category.data as Map<String, dynamic>;
        final riskColor = safetyData['overallRisk'] == 'Low' 
            ? Colors.green 
            : safetyData['overallRisk'] == 'Moderate'
                ? Colors.orange
                : Colors.red;
                
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: riskColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.security,
                          color: riskColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Risk Level: ${safetyData['overallRisk']}",
                          style: TextStyle(
                            color: riskColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Health Information", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...((safetyData['healthAdvice'] as List).map((advice) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.circle, size: 8),
                    const SizedBox(width: 8),
                    Expanded(child: Text(advice)),
                  ],
                ),
              ))),
              const SizedBox(height: 16),
              const Text("Safety Tips", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...((safetyData['safetyTips'] as List).map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.circle, size: 8),
                    const SizedBox(width: 8),
                    Expanded(child: Text(tip)),
                  ],
                ),
              ))),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Emergency Contacts",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text("Police: ${safetyData['emergencyContacts']['police']}"),
                    Text("Ambulance: ${safetyData['emergencyContacts']['ambulance']}"),
                    Text("Tourist Police: ${safetyData['emergencyContacts']['touristPolice']}"),
                  ],
                ),
              ),
            ],
          ),
        );
      
      case 'costs':
        final costsData = category.data as Map<String, dynamic>;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Daily Budget Estimates",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildBudgetItem("Budget Traveler", costsData['budgetEstimate']['budget'], Colors.green),
                      _buildBudgetItem("Mid-Range", costsData['budgetEstimate']['midRange'], Colors.blue),
                      _buildBudgetItem("Luxury", costsData['budgetEstimate']['luxury'], Colors.purple),
                    ],
                  ),
                ],
              ),
              const Divider(),
              const Text(
                "Accommodation",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildCostDetail("Hostel", costsData['accommodation']['hostel']),
              _buildCostDetail("Budget Hotel", costsData['accommodation']['budgetHotel']),
              _buildCostDetail("Mid-range Hotel", costsData['accommodation']['midrangeHotel']),
              _buildCostDetail("Luxury Hotel", costsData['accommodation']['luxuryHotel']),
              const Divider(),
              const Text(
                "Meal Costs",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildCostDetail("Budget Meal", costsData['mealCosts']['budgetMeal']),
              _buildCostDetail("Mid-range Restaurant", costsData['mealCosts']['midrangeMeal']),
              _buildCostDetail("Fine Dining", costsData['mealCosts']['fineDining']),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.currency_exchange, size: 16, color: Colors.amber),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Local Currency: ${costsData['localCurrency']}"),
                          Text("Exchange Rate: ${costsData['exchangeRate']}"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      
      default:
        // Generic renderer for other categories
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Detailed information collected for ${category.name} in ${widget.destination}.",
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        );
    }
  }
  
  Widget _buildBudgetItem(String type, String amount, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(type, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Text(
            amount,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCostDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/// Enum representing the status of a research category
enum ResearchStatus {
  notStarted,
  inProgress,
  completed,
}

/// Class representing a category of travel research
class ResearchCategory {
  /// The name of the category
  final String name;
  
  /// The icon representing this category
  final IconData icon;
  
  /// The color associated with this category
  final Color color;
  
  /// Additional details about this category
  final Map<String, String> details;
  
  /// The current status of research for this category
  ResearchStatus status;
  
  /// The data collected for this category
  dynamic data;
  
  /// Constructor
  ResearchCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.details,
    this.status = ResearchStatus.notStarted,
    this.data,
  });
}