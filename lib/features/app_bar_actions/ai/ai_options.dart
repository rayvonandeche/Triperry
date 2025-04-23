import 'package:flutter/material.dart';
import 'ai_preferences.dart';
import 'saved_recommendations.dart';

/// Shows a bottom sheet with AI-related options
void showAIOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            title: const Text('Save Conversation'),
            leading: const Icon(Icons.bookmark),
            onTap: () {
              Navigator.pop(context);
              // Implement save conversation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Conversation saved!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Start New Conversation'),
            leading: const Icon(Icons.refresh),
            onTap: () {
              Navigator.pop(context);
              // Implement new conversation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Starting new conversation...'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          ListTile(
            title: const Text('AI Preferences'),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              // Show AI preferences
              showAIPreferences(context);
            },
          ),
          ListTile(
            title: const Text('Report Issue'),
            leading: const Icon(Icons.flag),
            onTap: () {
              Navigator.pop(context);
              // Implement report issue
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reporting issue...'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Saved Recommendations'),
            leading: const Icon(Icons.favorite),
            onTap: () {
              Navigator.pop(context);
              // Show saved recommendations
              showSavedRecommendations(context);
            },
          ),
        ],
      );
    },
  );
}