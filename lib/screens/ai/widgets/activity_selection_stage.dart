import 'package:flutter/material.dart';
import '../services/ai_conversation_service.dart';

/// Widget that displays the activity selection stage
class ActivitySelectionStage extends StatelessWidget {
  /// The selected destination
  final String selectedDestination;
  
  /// The selected travel time
  final String travelTime;
  
  /// The selected interest category
  final String selectedInterest;
  
  /// Animation for slide effect
  final Animation<Offset> slideAnimation;
  
  /// Animation for fade effect
  final Animation<double> fadeAnimation;
  
  /// Callback when an activity is selected
  final Function(String) onSelectChip;

  const ActivitySelectionStage({
    super.key,
    required this.selectedDestination,
    required this.travelTime,
    required this.selectedInterest,
    required this.slideAnimation,
    required this.fadeAnimation,
    required this.onSelectChip,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
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
                    "$selectedDestination in $travelTime",
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
            _buildActivityOptions(context),
            
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

  /// Builds the activity option chips
  Widget _buildActivityOptions(BuildContext context) {
    final activities = AiConversationService.getActivitiesForInterest(selectedInterest);
    
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: activities.map((activity) => _buildActivityChip(context, activity)).toList(),
    );
  }

  /// Builds an individual activity chip
  Widget _buildActivityChip(BuildContext context, String activity) {
    return GestureDetector(
      onTap: () => onSelectChip("I'm interested in $activity"),
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
}