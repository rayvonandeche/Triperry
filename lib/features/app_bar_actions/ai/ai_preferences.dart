import 'package:flutter/material.dart';

/// Shows a dialog with AI assistant preferences settings
void showAIPreferences(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Local variables for preferences state
      bool rememberTravelHistory = true;
      bool personalizedSuggestions = true;
      double responseDetailLevel = 0.7;
      
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('AI Assistant Preferences'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Remember Travel History'),
                  subtitle: const Text('Allow AI to use your past trips for better recommendations'),
                  value: rememberTravelHistory,
                  onChanged: (bool value) {
                    setState(() {
                      rememberTravelHistory = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Personalized Suggestions'),
                  subtitle: const Text('Enable AI to learn your preferences over time'),
                  value: personalizedSuggestions,
                  onChanged: (bool value) {
                    setState(() {
                      personalizedSuggestions = value;
                    });
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text('Response Detail Level'),
                  subtitle: Slider(
                    value: responseDetailLevel,
                    divisions: 2,
                    label: responseDetailLevel < 0.4 
                        ? 'Brief' 
                        : responseDetailLevel < 0.8 
                            ? 'Standard' 
                            : 'Detailed',
                    onChanged: (double value) {
                      setState(() {
                        responseDetailLevel = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Save preferences
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Preferences saved'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          );
        }
      );
    },
  );
}