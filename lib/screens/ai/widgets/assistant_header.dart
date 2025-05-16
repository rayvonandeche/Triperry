import 'package:flutter/material.dart';

/// Widget that displays the AI assistant header
class AssistantHeader extends StatelessWidget {
  /// The message to display from the assistant
  final String assistantMessage;
  
  /// Animation for slide effect
  final Animation<Offset> slideAnimation;
  
  /// Animation for fade effect
  final Animation<double> fadeAnimation;
  
  /// Whether to show the toggle button
  final bool showToggleButton;
  
  /// Label for the toggle button
  final String toggleLabel;
  
  /// Callback when toggle button is tapped
  final VoidCallback? onToggleTap;
  
  /// Callback when back button is tapped
  final VoidCallback? onBackTap;
  
  /// Whether to show back button
  final bool showBackButton;

  const AssistantHeader({
    super.key,
    required this.assistantMessage,
    required this.slideAnimation,
    required this.fadeAnimation,
    this.showToggleButton = false,
    this.toggleLabel = "",
    this.onToggleTap,
    this.onBackTap,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Container(
          margin: const EdgeInsets.only(top: 8, bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.tertiary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  if (showBackButton)
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                        onPressed: onBackTap,
                        tooltip: 'Back to home',
                      ),
                    ),
                  
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 28, // Increased size for better visibility
                    child: Icon(
                      Icons.assistant_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32, // Increased icon size
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Triperry AI',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white.withOpacity(0.95), // Enhanced contrast
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          assistantMessage,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              if (showToggleButton && onToggleTap != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      onPressed: onToggleTap,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withOpacity(0.6), width: 0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(toggleLabel),
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