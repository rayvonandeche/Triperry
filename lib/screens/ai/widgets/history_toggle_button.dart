import 'package:flutter/material.dart';

/// Widget that displays a toggle button for showing conversation history or travel plan
class HistoryToggleButton extends StatelessWidget {
  /// Whether the history view is currently shown
  final bool showHistory;
  
  /// Whether the button should be visible (based on if there's conversation history)
  final bool isVisible;
  
  /// Callback when button is pressed
  final VoidCallback onToggle;

  const HistoryToggleButton({
    super.key,
    required this.showHistory,
    required this.isVisible,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isVisible ? onToggle : null,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: showHistory 
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surface.withOpacity(0.7),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  showHistory ? Icons.map : Icons.history,
                  size: 20,
                  color: showHistory 
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(width: 4),
                Text(
                  showHistory ? 'Travel Plan' : 'History',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: showHistory 
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}