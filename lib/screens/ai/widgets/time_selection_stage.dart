import 'package:flutter/material.dart';

/// Widget that displays the time selection stage
class TimeSelectionStage extends StatelessWidget {
  /// The selected destination
  final String selectedDestination;
  
  /// Animation for fade effect
  final Animation<double> fadeAnimation;
  
  /// Callback when time is selected
  final Function(String) onSelectChip;

  const TimeSelectionStage({
    super.key,
    required this.selectedDestination,
    required this.fadeAnimation,
    required this.onSelectChip,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
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
                        selectedDestination,
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
            "When are you thinking of traveling to $selectedDestination?",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          
          // Season selection
          _buildSeasonCards(context),
          
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

  /// Builds the season selection chips
  Widget _buildSeasonCards(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildSeasonChip(context, "Spring (Mar-May)", "spring"),
        _buildSeasonChip(context, "Summer (Jun-Aug)", "summer"),
        _buildSeasonChip(context, "Fall (Sep-Nov)", "fall"),
        _buildSeasonChip(context, "Winter (Dec-Feb)", "winter"),
      ],
    );
  }

  /// Builds an individual season selection chip
  Widget _buildSeasonChip(BuildContext context, String label, String value) {
    return GestureDetector(
      onTap: () => onSelectChip("I'd like to travel in $value"),
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
}