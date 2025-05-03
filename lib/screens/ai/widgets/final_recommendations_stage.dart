import 'package:flutter/material.dart';
import '../services/ai_conversation_service.dart';
import '../models/ai_models.dart';

/// Widget that displays the final recommendations stage
class FinalRecommendationsStage extends StatelessWidget {
  /// The selected destination
  final String selectedDestination;
  
  /// The selected travel time
  final String travelTime;
  
  /// The selected interest category
  final String selectedInterest;
  
  /// The selected budget range
  final BudgetRange? selectedBudget;
  
  /// Animation for slide effect
  final Animation<Offset> slideAnimation;
  
  /// Animation for fade effect
  final Animation<double> fadeAnimation;
  
  /// Callback when a recommendation action is selected
  final Function(String) onSelectChip;
  
  /// Callback to reset planning
  final VoidCallback onResetPlanning;

  const FinalRecommendationsStage({
    super.key,
    required this.selectedDestination,
    required this.travelTime,
    required this.selectedInterest,
    this.selectedBudget,
    required this.slideAnimation,
    required this.fadeAnimation,
    required this.onSelectChip,
    required this.onResetPlanning,
  });

  @override
  Widget build(BuildContext context) {
    final itineraryDays = AiConversationService.generateSampleItinerary(selectedInterest);
    
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Personalized Trip Plan",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Destination Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedDestination,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Travel Time: $travelTime",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (selectedBudget != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        "Budget Range: ${selectedBudget!.label} (${selectedBudget!.currency} ${selectedBudget!.min}-${selectedBudget!.max})",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Itinerary
            Text(
              "Suggested Itinerary",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ...itineraryDays.map((day) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (day.weather != null && day.temperature != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        "Weather: ${day.weather} (${day.temperature}°C)",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                    const SizedBox(height: 16),
                    ...day.activities.map((activity) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                activity.time,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  activity.title,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (activity.price != null)
                                Text(
                                  "${activity.price!.toStringAsFixed(2)} ${selectedBudget?.currency ?? 'USD'}",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            activity.description,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (activity.location != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              "Location: ${activity.location}",
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            )),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onSelectChip("Book Now"),
                    child: const Text("Book Now"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onResetPlanning,
                    child: const Text("Start Over"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}