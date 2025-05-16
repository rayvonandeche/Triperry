import 'package:flutter/material.dart';
import '../../../components/expandable_card.dart';

Widget buildActivitiesContent() {
    List<Map<String, dynamic>> activities = [
      {
        'title': 'Safari Adventures',
        'image': 'assets/images/savannah.png',
        'rating': 4.9,
      },
      {
        'title': 'Beach Activities',
        'image': 'assets/images/beach.jpeg',
        'rating': 4.7,
      },
      {
        'title': 'Mountain Hiking',
        'image': 'assets/images/hiking.jpeg',
        'rating': 4.8,
      },
      {
        'title': 'Cultural Tours',
        'image': 'assets/images/culture.jpeg',
        'rating': 4.5,
      },
      {
        'title': 'Food Experiences',
        'image': 'assets/images/food.jpeg',
        'rating': 4.6,
      },
      {
        'title': 'Adventure Sports',
        'image': 'assets/images/adventure.jpeg',
        'rating': 4.7,
      },
    ];
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return GestureDetector(
                  onTap: () {
                    // Show activity details inline with an expandable card
                    _showActivityDetails(context, index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            activity['image'],
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  activity['title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      activity['rating'].toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

void _showActivityDetails(BuildContext context, int index) {
  // Sample data
  final activityData = {
    'title': 'Wildlife Safari',
    'location': 'Maasai Mara, Kenya',
    'duration': '6 hours',
    'price': '\$120',
    'description': 'Experience the amazing wildlife of Kenya on this guided safari tour. See lions, elephants, giraffes and more in their natural habitat.',
    'rating': 4.8,
    'reviewCount': 245,
  };

  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              'https://source.unsplash.com/random/400x200/?safari,kenya',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activityData['title'] as String,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      Text(' ${activityData['rating']} (${activityData['reviewCount']} reviews)'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 18, color: Theme.of(context).colorScheme.primary),
                      Text(' ${activityData['location']}'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ExpandableCard(
                    title: 'Details',
                    expandedContent: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(activityData['description'] as String),
                        SizedBox(height: 8),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Duration: ${activityData['duration']}'),
                            Text('Price: ${activityData['price']} per person'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ExpandableCard(
                    title: 'What to Bring',
                    expandedContent: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Icon(Icons.camera_alt),
                          title: Text('Camera'),
                          dense: true,
                        ),
                        ListTile(
                          leading: Icon(Icons.wb_sunny),
                          title: Text('Sunscreen'),
                          dense: true,
                        ),
                        ListTile(
                          leading: Icon(Icons.local_drink),
                          title: Text('Water bottle'),
                          dense: true,
                        ),
                        ListTile(
                          leading: Icon(Icons.hiking),
                          title: Text('Comfortable shoes'),
                          dense: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {},
                      child: Text('Book Now'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
