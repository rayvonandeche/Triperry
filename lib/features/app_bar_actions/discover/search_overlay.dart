import 'package:flutter/material.dart';

/// Shows a search overlay dialog for finding destinations and experiences
void showSearchOverlay(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Search Destinations'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search for destinations, experiences...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Implement search functionality
              },
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Searches',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: 5),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Barcelona, Spain'),
              onTap: () {
                Navigator.pop(context);
                // Handle search selection
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Tokyo, Japan'),
              onTap: () {
                Navigator.pop(context);
                // Handle search selection
              },
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Trending Destinations',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: 5),
            ListTile(
              leading: const Icon(Icons.trending_up),
              title: const Text('Santorini, Greece'),
              onTap: () {
                Navigator.pop(context);
                // Handle search selection
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}