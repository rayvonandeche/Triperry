import 'package:flutter/material.dart';
import 'search_overlay.dart';
import 'filter_sheet.dart';

/// Returns the app bar actions for the Discover screen
List<Widget> getDiscoverActions(BuildContext context) {
  return [
    IconButton(
      icon: const Icon(Icons.search),
      tooltip: 'Search destinations',
      onPressed: () {
        showSearchOverlay(context);
      },
    ),
    IconButton(
      icon: const Icon(Icons.filter_list),
      tooltip: 'Filter destinations',
      onPressed: () {
        showFilterSheet(context);
      },
    ),
  ];
}