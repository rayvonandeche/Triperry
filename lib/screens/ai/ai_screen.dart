import 'package:flutter/material.dart';
import 'dart:ui';

import 'animations/ai_animations.dart';
import 'models/ai_models.dart';
import 'services/ai_conversation_service.dart';
import 'widgets/activity_selection_stage.dart';
import 'widgets/assistant_header.dart';
import 'widgets/budget_selection_stage.dart';
import 'widgets/conversation_history.dart';
import 'widgets/destination_options.dart';
import 'widgets/final_recommendations_stage.dart';
import 'widgets/history_toggle_button.dart';
import 'widgets/input_area.dart';
import 'widgets/thinking_indicator.dart';
import 'widgets/time_selection_stage.dart';
import 'widgets/welcome_stage.dart';
import 'widgets/quick_trip_form.dart';
import 'widgets/trip_query_intake_stage.dart';
import 'widgets/travel_recommendations_stage.dart';

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
  
  void _processUserInput(String text) {
    if (text.trim().isEmpty) return;
    
    final userInput = text.toLowerCase();
    _textController.clear();
    
    // Add user message to conversation history
    _addToConversationHistory(true, text);
    
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
            _currentStage = AiConversationService.processInterestSelection(
              userInput,
              (interest) => _selectedInterest = interest,
              (options) => _travelOptions = options,
            );
            break;
            
          case TravelStage.interestSelected:
            _currentStage = AiConversationService.processDestinationSelection(
              userInput,
              _travelOptions,
              (destination) => _selectedDestination = destination,
              (recommendations) => _recommendations = recommendations,
            );
            break;
            
          case TravelStage.destinationSelected:
            _currentStage = AiConversationService.processTravelTime(
              userInput,
              (time) => _travelTime = time,
            );
            break;
            
          case TravelStage.timeSelected:
            _currentStage = AiConversationService.processActivityPreferences(userInput);
            break;
            
          case TravelStage.activitySelected:
            _currentStage = AiConversationService.processBudgetSelection(
              userInput,
              (budget) => _selectedBudget = budget,
            );
            break;
            
          case TravelStage.budgetSelected:
            _currentStage = TravelStage.complete;
            break;
            
          case TravelStage.complete:
            // Check if user wants to start over
            if (userInput.contains('start') && (userInput.contains('new') || userInput.contains('over'))) {
              _resetPlanning();
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.98),
      body: Column(
        children: [
          // Fixed top padding for status bar
          SizedBox(height: MediaQuery.of(context).padding.top + AppBar().preferredSize.height),
          
          // AI Assistant Header with enhanced design
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: AssistantHeader(
              assistantMessage: _tripBooked 
                  ? "Thank you for booking! Your trip details have been confirmed."
                  : _tripData.isNotEmpty
                      ? "Here are your travel recommendations based on your preferences!"
                      : AiConversationService.getAssistantMessageForStage(
                          _currentStage,
                          _selectedInterest,
                          _selectedDestination,
                          _travelTime,
                        ),
              slideAnimation: AiAnimations.createHeaderSlideAnimation(_headerController),
              fadeAnimation: AiAnimations.createFadeAnimation(_headerController),
              showToggleButton: false,
            ),
          ),
          
          // Main content area with smooth transitions
          Expanded(
            child: Stack(
              children: [
                // Background gradient for visual appeal
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primary.withOpacity(0.03),
                          Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                          Theme.of(context).scaffoldBackgroundColor.withOpacity(0.02),
                        ],
                        stops: const [0.05, 0.4, 1],
                      ),
                    ),
                  ),
                ),
                
                // Main content with smooth transitions
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
                      : SingleChildScrollView(
                          controller: _scrollController,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                
                                // Stage-specific content with enhanced animations
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
                                
                                // Enhanced conversation history
                                if (_showHistory)
                                  ConversationHistoryWidget(
                                    conversationHistory: _conversationHistory,
                                  ),
                                
                                const SizedBox(height: 100), // Space for input area
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          
          // Enhanced input area with backdrop blur and gradient
          if (!_formCompleted)
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.85),
                        Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: InputArea(
                    textController: _textController,
                    inputHint: AiConversationService.getInputHintForStage(_currentStage),
                    onSubmit: _processUserInput,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCurrentStage() {
    // If using conversational UI
    if (_tripBooked && _bookingDetails != null) {
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
    
    if (_tripData.isNotEmpty) {
      return TravelRecommendationsStage(
        tripData: _tripData,
        fadeAnimation: _fadeController,
        slideAnimation: AiAnimations.createVerticalSlideAnimation(_slideController),
        onRestart: _resetPlanning,
        onBookTrip: _handleBookTrip,
      );
    }
    
    return TripQueryIntakeStage(
      onFormComplete: _handleTripQueryComplete,
      fadeAnimation: _fadeController,
      slideAnimation: AiAnimations.createVerticalSlideAnimation(_slideController),
    );
  }

  String _getSeasonFromDates(DateTime date) {
    final month = date.month;
    if (month >= 3 && month <= 5) return 'spring';
    if (month >= 6 && month <= 8) return 'summer';
    if (month >= 9 && month <= 11) return 'fall';
    return 'winter';
  }
}