import 'package:flutter/material.dart';
import 'dart:ui';

import 'animations/ai_animations.dart';
import 'models/ai_models.dart';
import 'services/ai_conversation_service.dart';
import 'widgets/assistant_header.dart';
import 'widgets/conversation_history.dart';
import 'widgets/input_area.dart';
import 'widgets/thinking_indicator.dart';
import 'widgets/travel_recommendations_stage.dart';
import 'widgets/budget_and_season_info.dart';
import 'widgets/quick_form.dart';
import 'widgets/planning_style_selector.dart';

class AiPage extends StatefulWidget {
  const AiPage({Key? key}) : super(key: key);

  @override
  State<AiPage> createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Interaction state
  late AnimationController _headerController;
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
  BudgetRange? _selectedBudget;
  
  // Conversation history
  List<ConversationMessage> _conversationHistory = [];
  bool _showHistory = false;

  // Add new state variables for quick form data
  Map<String, dynamic>? _quickFormData;
  
  // State for conversational trip planning
  bool _formCompleted = false;
  Map<String, dynamic> _tripData = {};
  bool _tripBooked = false;
  Map<String, dynamic>? _bookingDetails;

  // Add new state variable for planning style
  bool? _useQuickForm;

  @override
  void initState() {
    super.initState();
    
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _headerController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }
  
  Future<void> _processUserInput(String userInput) async {
    setState(() {
      _isThinking = true;
      _addToConversationHistory(true, userInput);
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      
      setState(() {
        _isThinking = false;
        
        // Process based on the current stage and user input
        switch (_currentStage) {
          case TravelStage.welcome:
            _currentStage = AiConversationService.processInterestSelection(
              userInput,
              (interest) {
                _selectedInterest = interest;
                _addToConversationHistory(
                  false,
                  "Great choice! I see you're interested in $interest. Let me suggest some destinations for you.",
                );
              },
              (options) {
                _travelOptions = options;
                _addToConversationHistory(
                  false,
                  "Here are some great destinations that match your interest in $userInput. Which one would you like to explore?",
                );
              },
            );
            break;
            
          case TravelStage.interestSelected:
            _currentStage = AiConversationService.processDestinationSelection(
              userInput,
              _travelOptions,
              (destination) {
                _selectedDestination = destination;
                _addToConversationHistory(
                  false,
                  "Excellent choice! $destination is a wonderful destination. When would you like to visit?",
                );
              },
              (recommendations) {
                _recommendations = recommendations;
                _addToConversationHistory(
                  false,
                  "I've found some great activities in $_selectedDestination. When would you like to visit?",
                );
              },
            );
            break;
            
          case TravelStage.destinationSelected:
            _currentStage = AiConversationService.processTravelTime(
              userInput,
              (time) {
                _travelTime = time;
                _addToConversationHistory(
                  false,
                  "Perfect! $time is a great time to visit $_selectedDestination. What kind of activities are you interested in?",
                );
              },
            );
            break;
            
          case TravelStage.timeSelected:
            _currentStage = AiConversationService.processActivityPreferences(
              userInput,
              (activities) {
                _addToConversationHistory(
                  false,
                  "I've noted your interest in $activities. What's your budget range for this trip?",
                );
              },
            );
            break;
            
          case TravelStage.activitySelected:
            _currentStage = AiConversationService.processBudgetSelection(
              userInput,
              (budget) {
                _selectedBudget = budget;
                _addToConversationHistory(
                  false,
                  "Thanks! Based on your preferences for $_selectedDestination, visiting during $_travelTime, "
                  "with a $budget budget, I can recommend some great options. Would you like to see them?",
                );
              },
              _selectedDestination,
              'USD', // Default currency, should be configurable
            );
            break;
            
          case TravelStage.budgetSelected:
            _currentStage = TravelStage.complete;
            _addToConversationHistory(
              false,
              "Here are your personalized travel recommendations for $_selectedDestination! "
              "You can ask me any questions about the destination, activities, or start planning a new trip.",
            );
            break;
            
          case TravelStage.complete:
            // Check if user wants to start over
            if (userInput.contains('start') && (userInput.contains('new') || userInput.contains('over'))) {
              _resetPlanning();
              _addToConversationHistory(
                false,
                "Great! Let's plan a new trip. What kind of travel experience are you looking for?",
              );
            } else {
              // Handle follow-up questions in the complete stage
              _handleFollowUpQuestion(userInput);
            }
            break;
        }
      });
      
      // Reset animations for next interaction with smoother curves
      _fadeController.reset();
      _slideController.reset();
      _fadeController.forward();
      _slideController.forward();
      
      // Scroll to see new content
      _scrollToBottom();
    });
  }
  
  void _addToConversationHistory(bool isUser, String message, {MessageType type = MessageType.text, Map<String, dynamic>? metadata}) {
    setState(() {
      _conversationHistory.add(
        ConversationMessage(
          isUser: isUser,
          text: message,
          timestamp: DateTime.now(),
          type: type,
          metadata: metadata,
        ),
      );
    });
  }
  
  void _handleFollowUpQuestion(String input) {
    // Add AI response to conversation history based on the question
    final response = AiConversationService.handleFollowUpQuestion(
      input, 
      _selectedDestination, 
      _travelTime
    );
    
    _addToConversationHistory(false, response);
  }
  
  void _goToPreviousStage() {
    setState(() {
      switch (_currentStage) {
        case TravelStage.complete:
          _currentStage = TravelStage.budgetSelected;
          break;
        case TravelStage.budgetSelected:
          _currentStage = TravelStage.activitySelected;
          break;
        case TravelStage.activitySelected:
          _currentStage = TravelStage.timeSelected;
          break;
        case TravelStage.timeSelected:
          _currentStage = TravelStage.destinationSelected;
          break;
        case TravelStage.destinationSelected:
          _currentStage = TravelStage.interestSelected;
          break;
        case TravelStage.interestSelected:
          _currentStage = TravelStage.welcome;
          break;
        case TravelStage.welcome:
          // Already at first stage, nothing to do
          break;
      }
      
      // Reset animations with smoother transitions
      _fadeController.reset();
      _slideController.reset();
      
      _fadeController.forward(from: 0.3);  // Start from partially visible for smoother effect
      _slideController.forward(from: 0.2); // Start partly moved for smoother effect
    });
  }
  
  void _toggleConversationHistory() {
    setState(() {
      _showHistory = !_showHistory;
    });
  }
  
  void _resetPlanning() {
    setState(() {
      _currentStage = TravelStage.welcome;
      _selectedInterest = "";
      _selectedDestination = "";
      _travelTime = "";
      _recommendations = [];
      _travelOptions = [];
      _selectedBudget = null;
      _quickFormData = null;
      _tripData = {};
      _tripBooked = false;
      _bookingDetails = null;
      
      // Reset animations
      _fadeController.reset();
      _slideController.reset();
      _fadeController.forward();
      _slideController.forward();
    });
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

  void _handleQuickFormComplete(Map<String, dynamic> formData) {
    setState(() {
      _quickFormData = formData;
      _formCompleted = true;
      
      // Initialize conversation with form data
      _selectedDestination = formData['destination'];
      _selectedBudget = BudgetRange(
        label: _getBudgetRangeLabel(formData['budget']),
        min: formData['budget'] * 0.8,
        max: formData['budget'] * 1.2,
        currency: 'USD',
      );
      
      // Set interest based on trip type
      switch (formData['tripType']) {
        case 'leisure':
          _selectedInterest = 'beach';
          _travelOptions = beachDestinations;
          break;
        case 'business':
          _selectedInterest = 'city';
          _travelOptions = cityDestinations;
          break;
        case 'adventure':
          _selectedInterest = 'adventure';
          _travelOptions = mountainDestinations;
          break;
        case 'family':
          _selectedInterest = 'family';
          _travelOptions = popularDestinations;
          break;
        default:
          _selectedInterest = 'general';
          _travelOptions = popularDestinations;
      }
      
      // Skip to activity selection since we have all other info
      _currentStage = TravelStage.activitySelected;
      
      // Add initial message to conversation
      _addToConversationHistory(
        false,
        "Thanks for sharing your preferences! I see you're planning a ${formData['tripType']} trip to ${formData['destination']} "
        "for ${formData['duration']} days with ${formData['travelers']} travelers. "
        "Your budget is around \$${formData['budget'].toStringAsFixed(0)}. "
        "Let me help you plan the perfect trip!",
      );
    });
  }

  String _getBudgetRangeLabel(double budget) {
    if (budget < 1000) return 'Budget';
    if (budget < 3000) return 'Mid-range';
    return 'Luxury';
  }
  
  void _handleTripQueryComplete(Map<String, dynamic> tripData) {
    setState(() {
      _tripData = tripData;
      
      // Reset animations
      _fadeController.reset();
      _slideController.reset();
      _fadeController.forward();
      _slideController.forward();
    });
  }
  
  void _handleBookTrip(Map<String, dynamic> bookingDetails) {
    setState(() {
      _bookingDetails = bookingDetails;
      _tripBooked = true;
      
      // Reset animations
      _fadeController.reset();
      _slideController.reset();
      _fadeController.forward();
      _slideController.forward();
      
      // Add booking to conversation history
      _addToConversationHistory(
        false, 
        "Your trip to ${bookingDetails['destination']} has been booked! Booking reference: ${bookingDetails['bookingNumber']}",
        type: MessageType.booking,
        metadata: bookingDetails
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.98),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.90),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.80),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AI Assistant Header
              Padding(
                padding: EdgeInsets.fromLTRB(8, MediaQuery.of(context).padding.top + 8, 8, 0),
                child: AssistantHeader(
                  assistantMessage: _useQuickForm == null
                      ? "Welcome! Let's plan your perfect trip."
                      : _useQuickForm!
                          ? _formCompleted 
                              ? "Great! I've got your preferences. Let me help you plan your trip to ${_quickFormData!['destination']}."
                              : "Hi! Let's start by getting some basic information about your trip."
                          : "Hi! I'm your travel planning assistant. Let's plan your perfect trip together!",
                  slideAnimation: AiAnimations.createHeaderSlideAnimation(_headerController),
                  fadeAnimation: AiAnimations.createFadeAnimation(_headerController),
                  showToggleButton: false,
                ),
              ),
              
              // Main content area
              Expanded(
                child: Stack(
                  children: [
                    // Background gradient
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).colorScheme.primary.withOpacity(0.03),
                              Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.02),
                            ],
                            stops: const [0.1, 0.4, 1],
                          ),
                        ),
                      ),
                    ),
                    
                    // Main content
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: _isThinking
                          ? Container(
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  center: Alignment.center,
                                  radius: 0.8,
                                  colors: [
                                    Theme.of(context).colorScheme.surface.withOpacity(0.5),
                                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.1),
                                  ],
                                  stops: const [0.0, 1.0],
                                ),
                              ),
                              child: const Center(
                                child: ThinkingIndicator(
                                  currentPrompt: '',
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: _useQuickForm == null
                                ? Center(
                                    child: SingleChildScrollView(
                                      child: PlanningStyleSelector(
                                        onStyleSelected: (useQuickForm) {
                                          setState(() {
                                            _useQuickForm = useQuickForm;
                                            if (!useQuickForm) {
                                              _formCompleted = true;
                                              // Add initial message for conversational style
                                              _addToConversationHistory(
                                                false,
                                                "Hi! I'm your travel planning assistant. Let's plan your perfect trip together! "
                                                "What kind of travel experience are you looking for?",
                                              );
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  )
                                : _formCompleted
                                  ? SingleChildScrollView(
                                      controller: _scrollController,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 16),
                                          
                                          // Show quick form data summary if using quick form
                                          if (_useQuickForm! && _quickFormData != null)
                                            _buildQuickFormSummary(),
                                          
                                          const SizedBox(height: 24),
                                          
                                          // Stage-specific content
                                          FadeTransition(
                                            opacity: _fadeController,
                                            child: SlideTransition(
                                              position: Tween<Offset>(
                                                begin: const Offset(0, 0.1),
                                                end: Offset.zero,
                                              ).animate(CurvedAnimation(
                                                parent: _slideController,
                                                curve: Curves.easeOutCubic,
                                              )),
                                              child: _buildCurrentStage(),
                                            ),
                                          ),
                                          
                                          const SizedBox(height: 24),
                                          
                                          // Conversation history
                                          if (_showHistory)
                                            ConversationHistoryWidget(
                                              conversationHistory: _conversationHistory,
                                            ),
                                          
                                          const SizedBox(height: 100),
                                        ],
                                      ),
                                    )
                                  : QuickForm(
                                      onComplete: _handleQuickFormComplete,
                                    ),
                            ),
                    ),
                  ],
                ),
              ),
              
              // Input area (only show after form completion)
              if (_formCompleted)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomLeft,
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.1),
                        Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                      ],
                      stops: const [-0.8, 1.0],
                    ),
                  ),
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: InputArea(
                        textController: _textController,
                        inputHint: AiConversationService.getInputHintForStage(_currentStage),
                        onSubmit: _processUserInput,
                        suggestions: _getSuggestionsForCurrentStage(),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStage() {
    // If using conversational UI
    if (_tripBooked && _bookingDetails != null) {
      return _buildBookingConfirmation();
    }
    
    if (_tripData.isNotEmpty) {
      return TravelRecommendationsStage(
        tripData: _tripData,
        fadeAnimation: _fadeController,
        slideAnimation: AiAnimations.createVerticalSlideAnimation(_slideController),
        onRestart: _resetPlanning,
        onBookTrip: _handleBookTrip,
      );
    }

    // Show stage-specific content
    switch (_currentStage) {
      case TravelStage.welcome:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Let's plan your dream vacation!",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "I can help you find the perfect destination based on your interests. What kind of travel experience are you looking for?",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),
            // Interactive interest cards with enhanced gradients
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildInterestCard(
                  context,
                  "Beach & Ocean",
                  "Relax on pristine beaches and enjoy water activities",
                  Icons.beach_access,
                  "beach",
                ),
                _buildInterestCard(
                  context,
                  "Mountain & Nature",
                  "Explore scenic landscapes and outdoor adventures",
                  Icons.landscape,
                  "mountain",
                ),
                _buildInterestCard(
                  context,
                  "City & Culture",
                  "Experience vibrant cities and rich cultural heritage",
                  Icons.location_city,
                  "city",
                ),
                _buildInterestCard(
                  context,
                  "Food & Cuisine",
                  "Discover culinary delights and local flavors",
                  Icons.restaurant,
                  "food",
                ),
              ],
            ),
          ],
        );

      case TravelStage.interestSelected:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Great choice!",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Based on your interest in $_selectedInterest, here are some amazing destinations to consider:",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 16),
            // Interactive destination cards with enhanced visuals
            for (int i = 0; i < _travelOptions.length && i < 3; i++)
              _buildDestinationCard(context, _travelOptions[i], i),
          ],
        );

      case TravelStage.destinationSelected:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Perfect choice!",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "$_selectedDestination is an amazing destination! When would you like to visit?",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),
            // Interactive time selection cards with enhanced gradients
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildTimeCard(
                  context,
                  "Next Weekend",
                  "Quick getaway",
                  Icons.weekend,
                ),
                _buildTimeCard(
                  context,
                  "Next Month",
                  "Plan ahead",
                  Icons.calendar_month,
                ),
                _buildTimeCard(
                  context,
                  "Summer Vacation",
                  "June - August",
                  Icons.wb_sunny,
                ),
                _buildTimeCard(
                  context,
                  "Winter Holidays",
                  "December - January",
                  Icons.ac_unit,
                ),
              ],
            ),
          ],
        );

      case TravelStage.timeSelected:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Great timing!",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "$_travelTime is a perfect time to visit $_selectedDestination. What kind of activities are you interested in?",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),
            // Interactive activity cards with enhanced gradients
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildActivityCard(
                  context,
                  "Adventure",
                  "Hiking, water sports, and outdoor activities",
                  Icons.directions_bike,
                ),
                _buildActivityCard(
                  context,
                  "Relaxation",
                  "Spa, beach time, and wellness",
                  Icons.spa,
                ),
                _buildActivityCard(
                  context,
                  "Culture",
                  "Museums, historical sites, and local experiences",
                  Icons.museum,
                ),
                _buildActivityCard(
                  context,
                  "Food & Dining",
                  "Local cuisine and culinary experiences",
                  Icons.restaurant_menu,
                ),
              ],
            ),
          ],
        );

      case TravelStage.activitySelected:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Excellent choices!",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Now, let's talk about your budget for this trip to $_selectedDestination.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),
            // Interactive budget cards with enhanced gradients
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildBudgetCard(
                  context,
                  "Budget Friendly",
                  "Up to \$1,000",
                  Icons.attach_money,
                ),
                _buildBudgetCard(
                  context,
                  "Mid-Range",
                  "\$1,000 - \$3,000",
                  Icons.monetization_on,
                ),
                _buildBudgetCard(
                  context,
                  "Luxury",
                  "\$3,000+",
                  Icons.diamond,
                ),
              ],
            ),
          ],
        );

      case TravelStage.budgetSelected:
        final season = AiConversationService.getTravelSeason(_selectedDestination, _travelTime);
        final documents = AiConversationService.getRequiredDocuments(_selectedDestination, 'US'); // TODO: Get actual nationality

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Perfect!",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Based on your preferences for $_selectedDestination, visiting during $_travelTime, "
                  "with a ${_selectedBudget?.label} budget, here's your detailed plan:",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 24),
                BudgetAndSeasonInfo(
                  budgetRange: _selectedBudget!,
                  season: season,
                  documents: documents,
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentStage = TravelStage.complete;
                        _tripData = {
                          'destination': _selectedDestination,
                          'travelTime': _travelTime,
                          'budget': _selectedBudget,
                          'season': season,
                          'documents': documents,
                        };
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Continue to Recommendations'),
                  ),
                ),
              ],
            ),
          ),
        );

      case TravelStage.complete:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Trip Plan",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 16),
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
                  color: Theme.of(context).dividerColor.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Destination: $_selectedDestination",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Travel Time: $_travelTime",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Budget: ${_selectedBudget?.label}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "You can ask me anything about your trip or start planning a new one!",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.8),
              ),
            ),
          ],
        );
    }
  }

  Widget _buildBookingConfirmation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.green.shade300,
                Colors.green,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 42,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Booking Confirmed!",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.headlineSmall?.color?.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Your trip to ${_bookingDetails!['destination']} has been booked successfully.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Booking details card with gradient
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).cardColor,
                Theme.of(context).cardColor.withOpacity(0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withOpacity(0.5), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            children: [
              // Booking reference
              Row(
                children: [
                  const Text("Booking Reference:"),
                  const Spacer(),
                  Text(
                    _bookingDetails!['bookingNumber'],
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
                    _bookingDetails!['package'],
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
                    "\$${(_bookingDetails!['totalPrice'] as double).toStringAsFixed(2)}",
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
        
        const SizedBox(height: 32),
        
        // Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton.icon(
              onPressed: _resetPlanning,
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

  String _getSeasonFromDates(DateTime date) {
    final month = date.month;
    if (month >= 3 && month <= 5) return 'spring';
    if (month >= 6 && month <= 8) return 'summer';
    if (month >= 9 && month <= 11) return 'fall';
    return 'winter';
  }

  List<String>? _getSuggestionsForCurrentStage() {
    switch (_currentStage) {
      case TravelStage.welcome:
        return [
          "I want to go to the beach",
          "I'm looking for a city break",
          "I want to go hiking",
          "I'm interested in food tourism",
          "I want to explore nature"
        ];
      case TravelStage.interestSelected:
        return _travelOptions.map((option) => option.name).toList();
      case TravelStage.destinationSelected:
        return [
          "Next weekend",
          "Next month",
          "Summer vacation",
          "Winter holidays",
          "In 3 months"
        ];
      case TravelStage.timeSelected:
        return [
          "Adventure activities",
          "Relaxation",
          "Cultural experiences",
          "Food and dining",
          "Shopping"
        ];
      case TravelStage.activitySelected:
        return [
          "Budget friendly",
          "Mid-range",
          "Luxury",
          "No budget limit"
        ];
      case TravelStage.budgetSelected:
      case TravelStage.complete:
        return [
          "Tell me more about the destination",
          "What's the best time to visit?",
          "What are the must-see attractions?",
          "What's the local cuisine like?",
          "Start a new trip"
        ];
    }
  }

  Widget _buildInterestCard(BuildContext context, String title, String description, IconData icon, String interest) {
    return GestureDetector(
      onTap: () => _processUserInput(interest),
      child: Container(
        width: 160,
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
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationCard(BuildContext context, TravelOption option, int index) {
    return GestureDetector(
      onTap: () => _processUserInput(option.name),
      child: Container(
        height: 180,
        margin: const EdgeInsets.only(bottom: 16),
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
    );
  }

  Widget _buildTimeCard(BuildContext context, String title, String subtitle, IconData icon) {
    return GestureDetector(
      onTap: () => _processUserInput(title.toLowerCase()),
      child: Container(
        width: 160,
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
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context, String title, String description, IconData icon) {
    return GestureDetector(
      onTap: () => _processUserInput(title.toLowerCase()),
      child: Container(
        width: 160,
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
            color: Theme.of(context).dividerColor.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetCard(BuildContext context, String title, String range, IconData icon) {
    return GestureDetector(
      onTap: () => _processUserInput(title.toLowerCase()),
      child: Container(
        width: 160,
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
            color: Theme.of(context).dividerColor.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              range,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickFormSummary() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Trip Preferences',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryItem(
              'Destination',
              _quickFormData!['destination'],
              Icons.location_on,
            ),
            _buildSummaryItem(
              'Trip Type',
              _quickFormData!['tripType'].toString().toUpperCase(),
              Icons.flight,
            ),
            _buildSummaryItem(
              'Duration',
              '${_quickFormData!['duration']} days',
              Icons.calendar_today,
            ),
            _buildSummaryItem(
              'Travelers',
              '${_quickFormData!['travelers']} people',
              Icons.people,
            ),
            _buildSummaryItem(
              'Budget',
              '\$${_quickFormData!['budget'].toStringAsFixed(0)}',
              Icons.attach_money,
            ),
            if (_quickFormData!['interests'].isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Interests',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (_quickFormData!['interests'] as List<String>).map((interest) {
                  return Chip(
                    label: Text(interest),
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}