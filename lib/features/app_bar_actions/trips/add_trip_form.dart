import 'package:flutter/material.dart';

/// Shows a form to add a new trip
void showAddTripForm(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allow the sheet to be full screen
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          // Local state for the form
          String selectedTripType = '';

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 16,
              left: 16,
              right: 16
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add New Trip',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Trip name input
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Trip Name',
                    hintText: 'e.g., Summer Adventure 2025',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Destination input
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Destination',
                    hintText: 'Where are you going?',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Date range
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Start Date',
                          hintText: 'May 1, 2025',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                          );
                          // Handle date selection
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'End Date',
                          hintText: 'May 10, 2025',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().add(const Duration(days: 7)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                          );
                          // Handle date selection
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Trip type
                Text(
                  'Trip Type',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    'Vacation',
                    'Business',
                    'Weekend Getaway',
                    'Family Visit',
                    'Adventure'
                  ].map((type) => ChoiceChip(
                    label: Text(type),
                    selected: selectedTripType == type,
                    onSelected: (selected) {
                      setState(() {
                        selectedTripType = selected ? type : selectedTripType;
                      });
                    },
                  )).toList(),
                ),
                const SizedBox(height: 24),
                
                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Save trip
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Trip added successfully!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text('Create Trip'),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      );
    },
  );
}