import 'package:flutter/material.dart';
import 'add_trip_form.dart';
import 'calendar_view.dart';

/// Returns the app bar actions for the Trips screen
List<Widget> getTripsActions(BuildContext context) {
  return [
    IconButton(
      icon: const Icon(Icons.add),
      tooltip: 'Add a new trip',
      onPressed: () {
        showAddTripForm(context);
      },
    ),
    IconButton(
      icon: const Icon(Icons.calendar_today),
      tooltip: 'View calendar',
      onPressed: () {
        showCalendarView(context);
      },
    ),
  ];
}