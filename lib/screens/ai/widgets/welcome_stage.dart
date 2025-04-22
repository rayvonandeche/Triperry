import 'package:flutter/material.dart';

/// Widget that displays the welcome stage with interest categories
class WelcomeStage extends StatelessWidget {
  /// Callback when user selects an interest
  final Function(String) onSelectChip;
  
  /// Animation controller for fade effects
  final Animation<double> fadeAnimation;

  const WelcomeStage({
    super.key,
    required this.onSelectChip,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "I can help you plan the perfect getaway! What kind of experience are you looking for?",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          _buildInterestCategories(context),
        ],
      ),
    );
  }

  /// Builds the grid of interest category cards
  Widget _buildInterestCategories(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildInterestCard(
          context,
          "Beach Getaway",
          "Relax on stunning shores",
          Icons.beach_access,
          Colors.blue,
          () => onSelectChip("I'm interested in beach destinations"),
        ),
        _buildInterestCard(
          context,
          "Mountain Escape",
          "Adventure in the heights",
          Icons.landscape,
          Colors.green,
          () => onSelectChip("I'd like to explore mountain destinations"),
        ),
        _buildInterestCard(
          context,
          "City Exploration",
          "Discover urban wonders",
          Icons.location_city,
          Colors.amber,
          () => onSelectChip("I want to visit city destinations"),
        ),
        _buildInterestCard(
          context,
          "Culinary Journey",
          "Taste global flavors",
          Icons.restaurant,
          Colors.red,
          () => onSelectChip("I'm interested in food tourism"),
        ),
      ],
    );
  }

  /// Builds an individual interest category card
  Widget _buildInterestCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}