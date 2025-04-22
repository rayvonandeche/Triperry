import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class AiPage extends StatefulWidget {
  const AiPage({Key? key}) : super(key: key);

  @override
  State<AiPage> createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Interaction state
  late AnimationController _fadeController;
  late AnimationController _slideController;
  String _currentPrompt = "";
  bool _isThinking = false;
  
  // Travel planning data
  TravelStage _currentStage = TravelStage.welcome;
  String _selectedInterest = "";
  String _selectedDestination = "";
  String _travelTime = "";
  List<String> _recommendations = [];
  List<TravelOption> _travelOptions = [];

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }
  
  void _processUserInput(String text) {
    if (text.trim().isEmpty) return;
    
    final userInput = text.toLowerCase();
    _textController.clear();
    
    setState(() {
      _currentPrompt = text;
      _isThinking = true;
    });
    
    // Simulate AI processing delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      
      setState(() {
        _isThinking = false;
        
        // Process based on the current stage and user input
        switch (_currentStage) {
          case TravelStage.welcome:
            _processInterestSelection(userInput);
            break;
            
          case TravelStage.interestSelected:
            _processDestinationSelection(userInput);
            break;
            
          case TravelStage.destinationSelected:
            _processTravelTime(userInput);
            break;
            
          case TravelStage.timeSelected:
            _processActivityPreferences(userInput);
            break;
            
          case TravelStage.complete:
            _resetPlanning();
            _processInterestSelection(userInput);
            break;
        }
      });
      
      // Reset animations for next interaction
      _fadeController.reset();
      _slideController.reset();
      _fadeController.forward();
      _slideController.forward();
      
      // Scroll to see new content
      _scrollToBottom();
    });
  }
  
  void _processInterestSelection(String input) {
    if (input.contains('beach') || input.contains('ocean') || input.contains('sea')) {
      _selectedInterest = 'beach';
      _travelOptions = beachDestinations;
    } else if (input.contains('mountain') || input.contains('hiking') || input.contains('nature')) {
      _selectedInterest = 'mountain';
      _travelOptions = mountainDestinations;
    } else if (input.contains('city') || input.contains('urban') || input.contains('culture')) {
      _selectedInterest = 'city';
      _travelOptions = cityDestinations;
    } else if (input.contains('food') || input.contains('culinary') || input.contains('cuisine')) {
      _selectedInterest = 'food';
      _travelOptions = culinaryDestinations;
    } else {
      _selectedInterest = 'general';
      _travelOptions = popularDestinations;
    }
    
    _currentStage = TravelStage.interestSelected;
  }
  
  void _processDestinationSelection(String input) {
    // Find if the user mentioned any of the previously shown destinations
    TravelOption? selectedOption = _travelOptions.firstWhere(
      (option) => input.contains(option.name.toLowerCase()),
      orElse: () => _travelOptions.first, // Default to first option if no match
    );
    
    _selectedDestination = selectedOption.name;
    _recommendations = selectedOption.activities;
    _currentStage = TravelStage.destinationSelected;
  }
  
  void _processTravelTime(String input) {
    if (input.contains('summer') || input.contains('july') || input.contains('august')) {
      _travelTime = "summer";
    } else if (input.contains('winter') || input.contains('december') || input.contains('january')) {
      _travelTime = "winter";
    } else if (input.contains('spring') || input.contains('april') || input.contains('may')) {
      _travelTime = "spring";
    } else if (input.contains('fall') || input.contains('autumn') || input.contains('october')) {
      _travelTime = "fall";
    } else {
      _travelTime = "flexible";
    }
    
    _currentStage = TravelStage.timeSelected;
  }
  
  void _processActivityPreferences(String input) {
    // In a real app, this would generate personalized recommendations
    _currentStage = TravelStage.complete;
  }
  
  void _resetPlanning() {
    _currentStage = TravelStage.welcome;
    _selectedInterest = "";
    _selectedDestination = "";
    _travelTime = "";
    _recommendations = [];
    _travelOptions = [];
  }
  
  void _selectChip(String text) {
    _processUserInput(text);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 500, // Extra space to ensure it scrolls far enough
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          // Main content area
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + kToolbarHeight + 8,
                bottom: 24,
                left: 16,
                right: 16,
              ),
              children: [
                // AI Assistant Header
                _buildAssistantHeader(),
                
                const SizedBox(height: 16),
                
                // Dynamic content based on conversation stage
                _buildConversationStage(),
                
                // User's current prompt if thinking
                if (_isThinking) _buildThinkingIndicator(),
                
                const SizedBox(height: 120), // Space for the input field
              ],
            ),
          ),
          
          // Floating input area at bottom
          _buildInputArea(),
        ],
      ),
    );
  }
  
  Widget _buildAssistantHeader() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.2),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOutCubic,
      )),
      child: FadeTransition(
        opacity: _fadeController,
        child: Container(
          margin: const EdgeInsets.only(top: 8, bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.tertiary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 24,
                child: Icon(
                  Icons.assistant_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Triperry AI',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getAssistantMessageForStage(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _getAssistantMessageForStage() {
    switch (_currentStage) {
      case TravelStage.welcome:
        return "Hi! I'm your travel assistant. What kind of trip are you looking for?";
      case TravelStage.interestSelected:
        return "Great choice! Here are some ${_selectedInterest.isNotEmpty ? _selectedInterest : 'popular'} destinations. Which one interests you?";
      case TravelStage.destinationSelected:
        return "Wonderful! $_selectedDestination is an amazing choice. When are you thinking of traveling?";
      case TravelStage.timeSelected:
        return "Perfect! What kind of activities are you interested in for your $_travelTime trip to $_selectedDestination?";
      case TravelStage.complete:
        return "I've prepared some recommendations for your $_travelTime trip to $_selectedDestination. Enjoy exploring!";
    }
  }
  
  Widget _buildConversationStage() {
    switch (_currentStage) {
      case TravelStage.welcome:
        return _buildWelcomeStage();
      case TravelStage.interestSelected:
        return _buildDestinationOptions();
      case TravelStage.destinationSelected:
        return _buildTimeSelectionStage();
      case TravelStage.timeSelected:
        return _buildActivitySelectionStage();
      case TravelStage.complete:
        return _buildFinalRecommendationsStage();
    }
  }
  
  Widget _buildWelcomeStage() {
    return FadeTransition(
      opacity: _fadeController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "I can help you plan the perfect getaway! What kind of experience are you looking for?",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          _buildInterestCategories(),
        ],
      ),
    );
  }
  
  Widget _buildInterestCategories() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildInterestCard(
          "Beach Getaway",
          "Relax on stunning shores",
          Icons.beach_access,
          Colors.blue,
          () => _selectChip("I'm interested in beach destinations"),
        ),
        _buildInterestCard(
          "Mountain Escape",
          "Adventure in the heights",
          Icons.landscape,
          Colors.green,
          () => _selectChip("I'd like to explore mountain destinations"),
        ),
        _buildInterestCard(
          "City Exploration",
          "Discover urban wonders",
          Icons.location_city,
          Colors.amber,
          () => _selectChip("I want to visit city destinations"),
        ),
        _buildInterestCard(
          "Culinary Journey",
          "Taste global flavors",
          Icons.restaurant,
          Colors.red,
          () => _selectChip("I'm interested in food tourism"),
        ),
      ],
    );
  }
  
  Widget _buildInterestCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDestinationOptions() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.05, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutCubic,
      )),
      child: FadeTransition(
        opacity: _fadeController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Based on your interest in ${_selectedInterest.isEmpty ? 'travel' : _selectedInterest} experiences, here are some destinations you might love:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < _travelOptions.length && i < 3; i++)
              _buildDestinationCard(_travelOptions[i], i),
            const SizedBox(height: 16),
            Text(
              "Which destination would you like to explore?",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDestinationCard(TravelOption option, int index) {
    return GestureDetector(
      onTap: () => _selectChip("I'd like to explore ${option.name}"),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Destination image
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    option.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / 
                                  loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Destination info
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        option.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTimeSelectionStage() {
    return FadeTransition(
      opacity: _fadeController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Destination header
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Destination selected",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        _selectedDestination,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // When to travel
          Text(
            "When are you thinking of traveling to $_selectedDestination?",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          
          // Season selection
          _buildSeasonCards(),
          
          const SizedBox(height: 16),
          
          // Text hint
          Text(
            "Or tell me your preferred dates in the chat.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSeasonCards() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildSeasonChip("Spring (Mar-May)", "spring"),
        _buildSeasonChip("Summer (Jun-Aug)", "summer"),
        _buildSeasonChip("Fall (Sep-Nov)", "fall"),
        _buildSeasonChip("Winter (Dec-Feb)", "winter"),
      ],
    );
  }
  
  Widget _buildSeasonChip(String label, String value) {
    return GestureDetector(
      onTap: () => _selectChip("I'd like to travel in $value"),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
  
  Widget _buildActivitySelectionStage() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.05),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutCubic,
      )),
      child: FadeTransition(
        opacity: _fadeController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip summary card
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Trip",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$_selectedDestination in $_travelTime",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(color: Colors.white24, thickness: 1, height: 24),
                  Text(
                    "What activities are you interested in?",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            // Activity options
            _buildActivityOptions(),
            
            const SizedBox(height: 16),
            
            Text(
              "Or tell me specific activities you're interested in.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActivityOptions() {
    List<String> activities = [];
    
    // Show relevant activities based on the destination type
    if (_selectedInterest == 'beach') {
      activities = [
        "Swimming & Snorkeling",
        "Beach Relaxation",
        "Water Sports",
        "Coastal Hiking",
        "Local Cuisine"
      ];
    } else if (_selectedInterest == 'mountain') {
      activities = [
        "Hiking & Trekking",
        "Scenic Views",
        "Wildlife Watching",
        "Photography",
        "Local Culture"
      ];
    } else if (_selectedInterest == 'city') {
      activities = [
        "Museums & Galleries",
        "Historical Sites",
        "Shopping",
        "Nightlife",
        "Local Cuisine"
      ];
    } else if (_selectedInterest == 'food') {
      activities = [
        "Food Tours",
        "Cooking Classes",
        "Local Markets",
        "Fine Dining",
        "Street Food"
      ];
    } else {
      activities = [
        "Sightseeing",
        "Cultural Experiences",
        "Adventure Activities",
        "Relaxation",
        "Local Cuisine"
      ];
    }
    
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: activities.map((activity) => _buildActivityChip(activity)).toList(),
    );
  }
  
  Widget _buildActivityChip(String activity) {
    return GestureDetector(
      onTap: () => _selectChip("I'm interested in $activity"),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          activity,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
  
  Widget _buildFinalRecommendationsStage() {
    // Create a sample itinerary
    final itineraryDays = _generateSampleItinerary();
    
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.05),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutCubic,
      )),
      child: FadeTransition(
        opacity: _fadeController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip header with destination image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    _getTripImageUrl(),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: const Center(child: Icon(Icons.image_not_supported)),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your $_travelTime Trip to",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _selectedDestination,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
            
            const SizedBox(height: 24),
            
            // Sample itinerary
            Text(
              "Sample Itinerary",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            for (var day in itineraryDays) 
              _buildItineraryDay(day),
              
            const SizedBox(height: 24),
            
            // Planning options
            Row(
              children: [
                Expanded(
                  child: _buildPlanningButton(
                    "Refine Plan",
                    Icons.edit_outlined,
                    Theme.of(context).colorScheme.primary,
                    () => _selectChip("I'd like to refine this plan"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPlanningButton(
                    "New Trip",
                    Icons.add_circle_outline,
                    Theme.of(context).colorScheme.secondary,
                    _resetPlanning,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            Center(
              child: TextButton.icon(
                onPressed: () => _selectChip("Show me hotel options"),
                icon: const Icon(Icons.hotel),
                label: const Text("Show accommodation options"),
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  List<ItineraryDay> _generateSampleItinerary() {
    if (_selectedInterest == 'beach') {
      return [
        ItineraryDay(
          title: "Day 1: Arrival & Beach Relaxation",
          activities: [
            "Morning: Arrive and check in to your accommodation",
            "Afternoon: Visit the main beach and relax",
            "Evening: Sunset dinner at a beachside restaurant"
          ],
        ),
        ItineraryDay(
          title: "Day 2: Ocean Adventures",
          activities: [
            "Morning: Snorkeling tour to nearby coral reefs",
            "Afternoon: Beach activities or water sports",
            "Evening: Seafood dinner and local entertainment"
          ],
        ),
        ItineraryDay(
          title: "Day 3: Coastal Exploration",
          activities: [
            "Morning: Hike along coastal trails",
            "Afternoon: Visit to local markets and shops",
            "Evening: Beach bonfire or night swimming"
          ],
        ),
      ];
    } else if (_selectedInterest == 'mountain') {
      return [
        ItineraryDay(
          title: "Day 1: Arrival & Orientation",
          activities: [
            "Morning: Arrive and check in to your accommodation",
            "Afternoon: Short introductory hike to a viewpoint",
            "Evening: Dinner at a local mountain lodge"
          ],
        ),
        ItineraryDay(
          title: "Day 2: Full Day Trek",
          activities: [
            "Morning: Begin trek to popular mountain trail",
            "Afternoon: Picnic lunch at a scenic spot",
            "Evening: Relax with hot cocoa and mountain views"
          ],
        ),
        ItineraryDay(
          title: "Day 3: Nature & Wildlife",
          activities: [
            "Morning: Guided nature walk with local expert",
            "Afternoon: Visit to wildlife sanctuary or natural landmark",
            "Evening: Traditional dinner with local specialties"
          ],
        ),
      ];
    } else {
      return [
        ItineraryDay(
          title: "Day 1: Arrival & City Introduction",
          activities: [
            "Morning: Arrive and check in to your accommodation",
            "Afternoon: Walking tour of main city attractions",
            "Evening: Dinner at a popular local restaurant"
          ],
        ),
        ItineraryDay(
          title: "Day 2: Cultural Exploration",
          activities: [
            "Morning: Visit to major museums or galleries",
            "Afternoon: Shopping and local markets",
            "Evening: Cultural performance or night tour"
          ],
        ),
        ItineraryDay(
          title: "Day 3: Local Experiences",
          activities: [
            "Morning: Food tour or cooking class",
            "Afternoon: Visit to historical sites",
            "Evening: Dinner at a well-known restaurant"
          ],
        ),
      ];
    }
  }
  
  String _getTripImageUrl() {
    // Return a relevant image URL based on destination and interest
    if (_selectedInterest == 'beach') {
      return 'https://picsum.photos/id/128/600/400';
    } else if (_selectedInterest == 'mountain') {
      return 'https://picsum.photos/id/29/600/400';
    } else if (_selectedInterest == 'city') {
      return 'https://picsum.photos/id/42/600/400';
    } else {
      return 'https://picsum.photos/id/20/600/400';
    }
  }
  
  Widget _buildItineraryDay(ItineraryDay day) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          for (var activity in day.activities)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(activity),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildPlanningButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildThinkingIndicator() {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "Thinking...",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _textController,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: _getInputHint(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  onSubmitted: _processUserInput,
                ),
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () => _processUserInput(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _getInputHint() {
    switch (_currentStage) {
      case TravelStage.welcome:
        return "What kind of trip are you looking for?";
      case TravelStage.interestSelected:
        return "Which destination interests you?";
      case TravelStage.destinationSelected:
        return "When would you like to travel?";
      case TravelStage.timeSelected:
        return "What activities are you interested in?";
      case TravelStage.complete:
        return "Ask me anything about your trip...";
    }
  }
}

// Data models
enum TravelStage {
  welcome,
  interestSelected,
  destinationSelected,
  timeSelected,
  complete,
}

class TravelOption {
  final String name;
  final String description;
  final String imageUrl;
  final List<String> activities;
  
  const TravelOption({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.activities,
  });
}

class ItineraryDay {
  final String title;
  final List<String> activities;
  
  const ItineraryDay({
    required this.title,
    required this.activities,
  });
}

// Sample destinations data
final List<TravelOption> beachDestinations = [
  TravelOption(
    name: "Bali, Indonesia",
    description: "Paradise island with stunning beaches, temples, and tropical vibes",
    imageUrl: "https://picsum.photos/id/42/600/400",
    activities: ["Beach relaxation", "Surfing", "Temple visits", "Balinese massage"],
  ),
  TravelOption(
    name: "Maldives",
    description: "Pristine white sand beaches and crystal-clear turquoise waters",
    imageUrl: "https://picsum.photos/id/43/600/400",
    activities: ["Snorkeling", "Overwater bungalow stay", "Spa treatments", "Sunset cruises"],
  ),
  TravelOption(
    name: "Amalfi Coast, Italy",
    description: "Breathtaking Mediterranean coastline with colorful villages",
    imageUrl: "https://picsum.photos/id/44/600/400",
    activities: ["Coastal drives", "Beach clubs", "Italian cuisine", "Boat tours"],
  ),
];

final List<TravelOption> mountainDestinations = [
  TravelOption(
    name: "Swiss Alps",
    description: "Majestic mountain ranges with picturesque villages and excellent hiking",
    imageUrl: "https://picsum.photos/id/29/600/400",
    activities: ["Hiking", "Skiing", "Cable car rides", "Swiss chocolate tasting"],
  ),
  TravelOption(
    name: "Patagonia",
    description: "Dramatic landscapes with glaciers, mountains, and unique wildlife",
    imageUrl: "https://picsum.photos/id/28/600/400",
    activities: ["Trekking", "Wildlife watching", "Photography", "Camping"],
  ),
  TravelOption(
    name: "Canadian Rockies",
    description: "Stunning mountain range with emerald lakes and abundant wildlife",
    imageUrl: "https://picsum.photos/id/27/600/400",
    activities: ["Hiking", "Lake activities", "Wildlife spotting", "Scenic drives"],
  ),
];

final List<TravelOption> cityDestinations = [
  TravelOption(
    name: "Tokyo, Japan",
    description: "Ultramodern metropolis with traditional elements and vibrant culture",
    imageUrl: "https://picsum.photos/id/30/600/400",
    activities: ["Shopping in Shibuya", "Visiting temples", "Food tours", "Robot restaurant"],
  ),
  TravelOption(
    name: "Barcelona, Spain",
    description: "Vibrant city with stunning architecture, beaches, and amazing food",
    imageUrl: "https://picsum.photos/id/31/600/400",
    activities: ["Sagrada Familia tour", "Tapas hopping", "Beach time", "Gothic Quarter"],
  ),
  TravelOption(
    name: "New York City, USA",
    description: "Iconic global city with world-famous landmarks and endless entertainment",
    imageUrl: "https://picsum.photos/id/32/600/400",
    activities: ["Broadway shows", "Museum visits", "Central Park", "Skyline views"],
  ),
];

final List<TravelOption> culinaryDestinations = [
  TravelOption(
    name: "Lyon, France",
    description: "Gastronomic capital with exceptional cuisine and charming atmosphere",
    imageUrl: "https://picsum.photos/id/33/600/400",
    activities: ["Food tours", "Cooking classes", "Wine tasting", "Market visits"],
  ),
  TravelOption(
    name: "Bangkok, Thailand",
    description: "Street food paradise with vibrant flavors and culinary diversity",
    imageUrl: "https://picsum.photos/id/34/600/400",
    activities: ["Street food tours", "Cooking classes", "Market exploration", "Restaurant dining"],
  ),
  TravelOption(
    name: "Bologna, Italy",
    description: "Italy's food capital known for pasta, cured meats, and cheeses",
    imageUrl: "https://picsum.photos/id/35/600/400",
    activities: ["Pasta making", "Food market tours", "Parmesan factories", "Wine tasting"],
  ),
];

final List<TravelOption> popularDestinations = [
  TravelOption(
    name: "Paris, France",
    description: "City of lights with iconic landmarks and romantic atmosphere",
    imageUrl: "https://picsum.photos/id/36/600/400",
    activities: ["Eiffel Tower", "Louvre Museum", "Seine River cruise", "Café culture"],
  ),
  TravelOption(
    name: "Kyoto, Japan",
    description: "Cultural heart of Japan with ancient temples and traditional gardens",
    imageUrl: "https://picsum.photos/id/37/600/400",
    activities: ["Temple visits", "Geisha district", "Tea ceremonies", "Garden tours"],
  ),
  TravelOption(
    name: "Costa Rica",
    description: "Biodiverse paradise with rainforests, beaches, and adventure activities",
    imageUrl: "https://picsum.photos/id/38/600/400",
    activities: ["Zip-lining", "Wildlife watching", "Surfing", "Rainforest hikes"],
  ),
];