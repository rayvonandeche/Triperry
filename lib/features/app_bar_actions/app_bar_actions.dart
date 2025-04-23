import 'package:flutter/material.dart';

import 'discover/discover_actions.dart';
import 'trips/trips_actions.dart';
import 'ai/ai_actions.dart';

/// Returns a list of app bar actions specific to the current screen
List<Widget> getScreenSpecificActions(BuildContext context, {
  required int currentIndex,
  required bool showAI,
}) {
  if (showAI) {
    return getAIActions(context);
  } else if (currentIndex == 0) {
    return getDiscoverActions(context);
  } else {
    return getTripsActions(context);
  }
}