import 'package:flutter/material.dart';
import '../models/ai_models.dart';

/// Widget that displays the budget selection stage
class BudgetSelectionStage extends StatelessWidget {
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
  
  /// Callback when a budget range is selected
  final Function(String) onSelectChip;

  const BudgetSelectionStage({
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
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What's your budget range for this trip?",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: budgetRanges.map((budget) {
                return ActionChip(
                  label: Text(
                    "${budget.label} (${budget.currency} ${budget.min}-${budget.max})",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onPressed: () => onSelectChip(budget.label),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
} 