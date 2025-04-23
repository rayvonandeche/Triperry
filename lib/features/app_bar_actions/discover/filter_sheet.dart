import 'package:flutter/material.dart';

/// Shows a bottom sheet with filtering options for destinations
void showFilterSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          // This StatefulBuilder allows the bottom sheet to have its own state
          
          // Sample filter values
          double _priceRangeStart = 50;
          double _priceRangeEnd = 1000;
          String _selectedRegion = 'All Regions';
          List<String> _selectedTravelStyles = [];
          
          return DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            expand: false,
            builder: (_, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Filter sheet header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Filter Results',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          TextButton(
                            onPressed: () {
                              // Reset filters
                            },
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                      const Divider(),
                      
                      // Price Range Filter
                      const SizedBox(height: 16),
                      Text(
                        'Price Range',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      RangeSlider(
                        values: RangeValues(_priceRangeStart, _priceRangeEnd),
                        min: 0,
                        max: 2000,
                        divisions: 20,
                        labels: RangeLabels(
                          '\$${_priceRangeStart.round()}',
                          '\$${_priceRangeEnd.round()}',
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            _priceRangeStart = values.start;
                            _priceRangeEnd = values.end;
                          });
                        },
                      ),
                      
                      // Region Filter
                      const SizedBox(height: 16),
                      Text(
                        'Region',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          'All Regions',
                          'Europe',
                          'Asia',
                          'North America',
                          'South America',
                          'Africa',
                          'Oceania'
                        ].map((region) => ChoiceChip(
                          label: Text(region),
                          selected: _selectedRegion == region,
                          onSelected: (selected) {
                            setState(() {
                              _selectedRegion = selected ? region : _selectedRegion;
                            });
                          },
                        )).toList(),
                      ),
                      
                      // Travel Style Filter
                      const SizedBox(height: 16),
                      Text(
                        'Travel Style',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          'Adventure',
                          'Relaxation',
                          'Cultural',
                          'Family',
                          'Luxury',
                          'Budget',
                          'Solo'
                        ].map((style) => FilterChip(
                          label: Text(style),
                          selected: _selectedTravelStyles.contains(style),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedTravelStyles.add(style);
                              } else {
                                _selectedTravelStyles.remove(style);
                              }
                            });
                          },
                        )).toList(),
                      ),
                      
                      // Apply button
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Apply filters
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Filters applied'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text('Apply Filters'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}