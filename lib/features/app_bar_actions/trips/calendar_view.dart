import 'package:flutter/material.dart';

/// Shows a calendar view dialog with upcoming trips
void showCalendarView(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Your Trip Calendar'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Calendar header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      // Previous month
                    },
                  ),
                  const Text('May 2025'),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      // Next month
                    },
                  ),
                ],
              ),
              
              // Calendar grid (simplified representation)
              Container(
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1,
                  ),
                  itemCount: 31 + 4, // Days + offset for first day of month
                  itemBuilder: (context, index) {
                    if (index < 4) {
                      // Empty cells before month starts
                      return const SizedBox();
                    }
                    
                    final day = index - 3;
                    final hasTrip = day == 5 || day == 15 || (day >= 20 && day <= 25);
                    
                    return Container(
                      margin: const EdgeInsets.all(2),
                      alignment: Alignment.center,
                      decoration: hasTrip
                          ? BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            )
                          : null,
                      child: Text(
                        day.toString(),
                        style: TextStyle(
                          fontWeight: hasTrip ? FontWeight.bold : FontWeight.normal,
                          color: hasTrip ? Theme.of(context).colorScheme.primary : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Upcoming trips
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Upcoming Trips',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  width: 12,
                  height: double.infinity,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text('Beach Getaway'),
                subtitle: const Text('May 5-10, 2025'),
              ),
              ListTile(
                leading: Container(
                  width: 12,
                  height: double.infinity,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: const Text('Mountain Adventure'),
                subtitle: const Text('May 15-19, 2025'),
              ),
              ListTile(
                leading: Container(
                  width: 12,
                  height: double.infinity,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                title: const Text('City Exploration'),
                subtitle: const Text('May 20-25, 2025'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}