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
    final activities = AiConversationService.getActivitiesForInterest(selectedInterest);
    
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What activities interest you for your $travelTime trip to $selectedDestination?",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: activities.map((activity) {
                return ActionChip(
                  label: Text(
                    activity,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onPressed: () => onSelectChip(activity),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Popular Activities",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Based on your interest in $selectedInterest, these activities are highly recommended for $selectedDestination during $travelTime.",
                      style: Theme.of(context).textTheme.bodyMedium,
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
}