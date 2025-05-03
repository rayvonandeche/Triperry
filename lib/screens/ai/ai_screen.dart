import 'package:flutter/material.dart';
import 'dart:ui';

import 'animations/ai_animations.dart';
import 'models/ai_models.dart';
import 'services/ai_conversation_service.dart';
import 'widgets/activity_selection_stage.dart';
import 'widgets/assistant_header.dart';
import 'widgets/conversation_history.dart';
import 'widgets/destination_options.dart';
import 'widgets/final_recommendations_stage.dart';
import 'widgets/history_toggle_button.dart';
import 'widgets/input_area.dart';
import 'widgets/thinking_indicator.dart';
import 'widgets/time_selection_stage.dart';
import 'widgets/welcome_stage.dart';

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
  
  // Conversation history
  List<ConversationMessage> _conversationHistory = [];
  bool _showHistory = false;

  @override
  void initState() {
    super.initState();
    
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600), // Increased from 400ms
      vsync: this,
    )..forward();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800), // Increased from 600ms
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
  
  void _addToConversationHistory(bool isUser, String message) {
    setState(() {
      _conversationHistory.add(
        ConversationMessage(
          isUser: isUser,
          text: message,
          timestamp: DateTime.now(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
      body: Column(
        children: [
          // Fixed top padding for status bar
          SizedBox(height: MediaQuery.of(context).padding.top + AppBar().preferredSize.height),
          
          // AI Assistant Header with enhanced design
          AssistantHeader(
            assistantMessage: AiConversationService.getAssistantMessageForStage(
              _currentStage,
              _selectedInterest,
              _selectedDestination,
              _travelTime,
            ),
            slideAnimation: AiAnimations.createHeaderSlideAnimation(_headerController),
            fadeAnimation: AiAnimations.createFadeAnimation(_headerController),
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
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).colorScheme.primary.withOpacity(0.05),
                          Theme.of(context).scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Main content with smooth transitions
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _isThinking
                      ? const Center(
                          child: ThinkingIndicator(
                            currentPrompt: '',
                          ),
                        )
                      : SingleChildScrollView(
                          controller: _scrollController,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
          
          // Enhanced input area with suggestions
          InputArea(
            textController: _textController,
            inputHint: AiConversationService.getInputHintForStage(_currentStage),
            onSubmit: _processUserInput,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStage() {
    switch (_currentStage) {
      case TravelStage.welcome:
        return WelcomeStage(
          onSelectChip: _selectChip,
          fadeAnimation: _fadeController,
        );
      case TravelStage.interestSelected:
        return DestinationOptionsStage(
          selectedInterest: _selectedInterest,
          travelOptions: _travelOptions,
          onSelectChip: _selectChip,
          slideAnimation: AiAnimations.createHorizontalSlideAnimation(_slideController),
          fadeAnimation: _fadeController,
        );
      case TravelStage.destinationSelected:
        return TimeSelectionStage(
          selectedDestination: _selectedDestination,
          fadeAnimation: _fadeController,
          onSelectChip: _selectChip,
        );
      case TravelStage.timeSelected:
        return ActivitySelectionStage(
          selectedDestination: _selectedDestination,
          travelTime: _travelTime,
          selectedInterest: _selectedInterest,
          slideAnimation: AiAnimations.createVerticalSlideAnimation(_slideController),
          fadeAnimation: _fadeController,
          onSelectChip: _selectChip,
        );
      case TravelStage.complete:
        return FinalRecommendationsStage(
          selectedDestination: _selectedDestination,
          travelTime: _travelTime,
          selectedInterest: _selectedInterest,
          slideAnimation: AiAnimations.createVerticalSlideAnimation(_slideController),
          fadeAnimation: _fadeController,
          onSelectChip: _selectChip,
          onResetPlanning: _resetPlanning,
        );
    }
  }
}