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
    required this.slideAnimation,
    required this.fadeAnimation,
    required this.onSelectChip,
    required this.onResetPlanning,
  });

  @override
  Widget build(BuildContext context) {
    final itineraryDays = AiConversationService.generateSampleItinerary(selectedInterest);

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTripHeader(context),
            const SizedBox(height: 24),
            Text(
              "Sample Itinerary",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < itineraryDays.length; i++)
              AnimatedContainer(
                duration: Duration(milliseconds: 600 + (i * 150)), // Staggered animation
                curve: Curves.easeOutQuint,
                transform: Matrix4.translationValues(0, 0, 0)..scale(1.0),
                margin: const EdgeInsets.only(bottom: 16),
                child: _buildItineraryDay(context, itineraryDays[i]),
              ),
            // const SizedBox(height: 24),
            Text(
              "Plan Your Trip",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            // const SizedBox(height: 16),
            // Planning options with staggered animations
            _buildPlanningOptions(context),
            const SizedBox(height: 24),
            // New trip button with scale animation
            _buildNewTripButton(context),
            const SizedBox(height: 16),
            // Tip container with slide animation
            _buildTipContainer(context),
          ],
        ),
      ),
    );
  }

  /// Builds the trip header with image and destination
  Widget _buildTripHeader(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            AiConversationService.getTripImageUrl(selectedInterest),
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
                  "Your $travelTime Trip to",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  selectedDestination,
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
    );
  }

  /// Builds an itinerary day card
  Widget _buildItineraryDay(BuildContext context, ItineraryDay day) {
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

  /// Builds the planning options grid
  Widget _buildPlanningOptions(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.0,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 700),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: _buildPlanningButton(
                context,
                "Modify",
                Icons.edit,
                Theme.of(context).colorScheme.primary,
                () => onSelectChip("I want to modify my itinerary"),
              ),
            );
          },
        ),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: _buildPlanningButton(
                context,
                "Restaurants",
                Icons.restaurant,
                Colors.orange,
                () => onSelectChip("Show me restaurant recommendations"),
              ),
            );
          },
        ),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 900),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: _buildPlanningButton(
                context,
                "Hotels",
                Icons.hotel,
                Colors.blue,
                () => onSelectChip("I need hotel suggestions"),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Builds a button for the planning options grid
  Widget _buildPlanningButton(
      BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
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

  /// Builds the "Start New Trip" button
  Widget _buildNewTripButton(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutQuad,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: OutlinedButton.icon(
            onPressed: onResetPlanning,
            icon: const Icon(Icons.refresh),
            label: const Text("Start New Trip Planning"),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
          ),
        );
      },
    );
  }
  
  /// Builds the tip container
  Widget _buildTipContainer(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.2),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: fadeAnimation as AnimationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOutQuad),
      )),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "You can ask me any questions about $selectedDestination or your itinerary!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}