import 'package:flutter/material.dart';
import '../models/ai_models.dart';

/// Widget that displays the destination options stage
class DestinationOptionsStage extends StatelessWidget {
  /// The selected interest category
  final String selectedInterest;
  
  /// List of travel destination options to display
  final List<TravelOption> travelOptions;
  
  /// Callback when a destination is selected
  final Function(String) onSelectChip;
  
  /// Animation for slide effect
  final Animation<Offset> slideAnimation;
  
  /// Animation for fade effect
  final Animation<double> fadeAnimation;

  const DestinationOptionsStage({
    super.key,
    required this.selectedInterest,
    required this.travelOptions,
    required this.onSelectChip,
    required this.slideAnimation,
    required this.fadeAnimation,
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
            Text(
              "Based on your interest in ${selectedInterest.isEmpty ? 'travel' : selectedInterest} experiences, here are some destinations you might love:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < travelOptions.length && i < 3; i++)
              AnimatedContainer(
                duration: Duration(milliseconds: 600 + (i * 100)), // Staggered animation
                curve: Curves.easeOutQuint,
                transform: Matrix4.translationValues(0, 0, 0)..scale(1.0),
                margin: const EdgeInsets.only(bottom: 16),
                child: _buildDestinationCard(context, travelOptions[i], i),
              ),
            const SizedBox(height: 16),
            Text(
              "Which destination would you like to explore?",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a card for a destination option
  Widget _buildDestinationCard(BuildContext context, TravelOption option, int index) {
    return GestureDetector(
      onTap: () => onSelectChip("I'd like to explore ${option.name}"),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          height: 180,
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
      ),
    );
  }
}