import 'package:flutter/material.dart';
import 'dart:math';

class TripQueryIntakeStage extends StatefulWidget {
  final Function(Map<String, dynamic>) onFormComplete;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const TripQueryIntakeStage({
    super.key,
    required this.onFormComplete,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  State<TripQueryIntakeStage> createState() => _TripQueryIntakeStageState();
}

class _TripQueryIntakeStageState extends State<TripQueryIntakeStage> {
  int _currentStep = 0;
  final Map<String, dynamic> _tripData = {};
  final TextEditingController _textController = TextEditingController();
  final List<String> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  String? _currentAccessibilityRequirement;
  
  final List<Map<String, dynamic>> _steps = [
    {
      'question': 'Hi there! I\'m your travel assistant. Where would you like to go?',
      'field': 'destination',
      'suggestions': ['Paris', 'Tokyo', 'New York', 'Bali', 'Safari', 'Beach getaway'],
      'inputType': 'text'
    },
    {
      'question': 'Great choice! When are you planning to travel?',
      'field': 'travelDates',
      'suggestions': ['Next month', 'Summer vacation', 'Winter holidays', 'This weekend'],
      'inputType': 'date'
    },
    {
      'question': 'How many people will be traveling?',
      'field': 'travelers',
      'suggestions': ['Just me', 'Couple (2)', 'Family (3-5)', 'Group (6+)'],
      'inputType': 'number'
    },
    {
      'question': 'What\'s your approximate budget for this trip?',
      'field': 'budget',
      'suggestions': ['Budget friendly', 'Mid-range', 'Luxury', 'No budget limit'],
      'inputType': 'budget'
    },
    {
      'question': 'What type of experience are you looking for?',
      'field': 'activityType',
      'suggestions': ['Adventure', 'Relaxation', 'Cultural', 'Nature', 'Urban', 'Mixed'],
      'inputType': 'checkbox'
    },
    {
      'question': 'Do you have any specific accessibility requirements?',
      'field': 'accessibility',
      'suggestions': [
        'Wheelchair accessible', 
        'Limited mobility', 
        'Vision assistance',
        'Hearing assistance', 
        'No special requirements'
      ],
      'inputType': 'accessibility'
    }
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _processResponse(String response) {
    if (response.isEmpty) return;
    
    setState(() {
      _messages.add(response);
      _isTyping = true;
    });
    
    // Save response to trip data
    _tripData[_steps[_currentStep]['field']] = response;
    
    // Wait briefly to simulate typing
    Future.delayed(Duration(milliseconds: 800 + Random().nextInt(1000)), () {
      if (!mounted) return;
      
      setState(() {
        _isTyping = false;
        if (_currentStep < _steps.length - 1) {
          _currentStep++;
          _messages.add(_steps[_currentStep]['question']);
        } else {
          _messages.add("Perfect! I have all the information I need to plan your dream trip. Let me show you some great options based on your preferences!");
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              widget.onFormComplete(_tripData);
            }
          });
        }
      });
      
      _scrollToBottom();
    });
  }

  void _handleSuggestionTap(String suggestion) {
    _textController.clear();
    
    // For certain responses, we need additional processing
    if (_steps[_currentStep]['field'] == 'travelers') {
      final Map<String, int> peopleMap = {
        'Just me': 1,
        'Couple (2)': 2,
        'Family (3-5)': 4,
        'Group (6+)': 8
      };
      _processResponse(suggestion);
      _tripData[_steps[_currentStep]['field']] = peopleMap[suggestion] ?? 1;
      return;
    }
    
    if (_steps[_currentStep]['field'] == 'accessibility' && suggestion != 'No special requirements') {
      setState(() {
        _currentAccessibilityRequirement = suggestion;
      });
      return;
    }
    
    _processResponse(suggestion);
  }
  
  void _submitAccessibilityRequirements() {
    if (_currentAccessibilityRequirement != null) {
      _processResponse(_currentAccessibilityRequirement!);
      setState(() {
        _currentAccessibilityRequirement = null;
      });
    }
  }

  Widget _buildInputArea() {
    final currentInputType = _steps[_currentStep]['inputType'];
    
    if (currentInputType == 'checkbox') {
      return _buildMultiSelectOptions();
    }
    
    if (currentInputType == 'accessibility') {
      return _buildAccessibilityOptions();
    }
    
    // Default text input with suggestions
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input field
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Type your answer...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      _processResponse(value);
                      _textController.clear();
                    }
                  },
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.send_rounded,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  if (_textController.text.isNotEmpty) {
                    _processResponse(_textController.text);
                    _textController.clear();
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // Suggestion chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: (_steps[_currentStep]['suggestions'] as List<String>).map((suggestion) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ActionChip(
                  label: Text(suggestion),
                  onPressed: () => _handleSuggestionTap(suggestion),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMultiSelectOptions() {
    final options = _steps[_currentStep]['suggestions'] as List<String>;
    final selectedOptions = <String>[];
    
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...options.map((option) {
              final isSelected = selectedOptions.contains(option);
              return CheckboxListTile(
                title: Text(option),
                value: isSelected,
                onChanged: (selected) {
                  setState(() {
                    if (selected!) {
                      selectedOptions.add(option);
                    } else {
                      selectedOptions.remove(option);
                    }
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Theme.of(context).primaryColor,
              );
            }).toList(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedOptions.isEmpty
                    ? null
                    : () => _processResponse(selectedOptions.join(', ')),
                child: const Text('Confirm Selections'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAccessibilityOptions() {
    final options = _steps[_currentStep]['suggestions'] as List<String>;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Please select any accessibility requirements:',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        ...options.map((option) {
          final isSelected = _currentAccessibilityRequirement == option;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: InkWell(
              onTap: () => _handleSuggestionTap(option),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
                  border: Border.all(
                    color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade500,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(
                          color: isSelected ? Theme.of(context).primaryColor : null,
                          fontWeight: isSelected ? FontWeight.bold : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
        if (_currentAccessibilityRequirement != null && 
            _currentAccessibilityRequirement != 'No special requirements')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Any additional details about your accessibility needs?',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitAccessibilityRequirements,
                  child: const Text('Confirm Requirements'),
                ),
              ),
            ],
          ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    // Add initial message
    _messages.add(_steps[0]['question']);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.fadeAnimation,
      child: SlideTransition(
        position: widget.slideAnimation,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              // Chat bubbles
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _messages.length,
                  padding: const EdgeInsets.only(top: 8),
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final isUserMessage = index % 2 == 1; // Odd indices are user messages
                    
                    return Align(
                      alignment: isUserMessage 
                          ? Alignment.centerRight 
                          : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.8,
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isUserMessage 
                              ? Theme.of(context).primaryColor 
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          message,
                          style: TextStyle(
                            color: isUserMessage 
                                ? Colors.white 
                                : Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // AI typing indicator
              if (_isTyping)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildAnimatedDot(),
                        const SizedBox(width: 4),
                        buildAnimatedDot(delay: 200),
                        const SizedBox(width: 4),
                        buildAnimatedDot(delay: 400),
                      ],
                    ),
                  ),
                ),
              
              // Input area
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0, right: 12.0, bottom: 16.0, top: 8.0
                ),
                child: _buildInputArea(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget buildAnimatedDot({int delay = 0}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor
                .withOpacity(0.3 + (0.7 * sin((value * 2 * pi) + (delay / 1000 * 2 * pi)))),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}