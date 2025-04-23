import 'package:flutter/material.dart';
import 'share_options.dart';
import 'ai_options.dart';

/// Returns the app bar actions for the AI screen
List<Widget> getAIActions(BuildContext context) {
  return [
    IconButton(
      icon: const Icon(Icons.share),
      tooltip: 'Share recommendations',
      onPressed: () {
        showShareOptions(context);
      },
    ),
    IconButton(
      icon: const Icon(Icons.more_vert),
      tooltip: 'More options',
      onPressed: () {
        showAIOptions(context);
      },
    ),
  ];
}