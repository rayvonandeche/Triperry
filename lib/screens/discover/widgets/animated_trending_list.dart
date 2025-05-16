import 'package:flutter/material.dart';
import 'package:triperry/theme/app_theme.dart';
import 'dart:async';

class AnimatedTrendingList extends StatefulWidget {
  const AnimatedTrendingList({Key? key}) : super(key: key);

  @override
  State<AnimatedTrendingList> createState() => _AnimatedTrendingListState();
}

class _AnimatedTrendingListState extends State<AnimatedTrendingList> {
  late List<Map<String, dynamic>> displayedCategories;
  int startIndex = 0;
  Timer? _timer;
  
  // Popular categories
  final List<Map<String, dynamic>> allCategories = [
    {
      'title': 'Business Travel',
      'description': 'Corporate travel planning and logistics',
      'image': 'assets/images/nairobi city skyline.png',
      'activities': [
        'Conference bookings',
        'Business hotels',
        'Transport arrangements'
      ],
    },
    {
      'title': 'Romantic Getaways',
      'description': 'Perfect date spots and couple retreats',
      'image': 'assets/images/tropical beach.jpeg',
      'activities': [
        'Intimate dinners',
        'Couples activities',
        'Beachfront lodges'
      ],
    },
    {
      'title': 'Family Adventures',
      'description': 'Kid-friendly destinations and activities',
      'image': 'assets/images/girraffe.png',
      'activities': [
        'Safari tours',
        'Educational visits',
        'Child-friendly resorts'
      ],
    },
    {
      'title': 'Solo Exploration',
      'description': 'Independent travel experiences',
      'image': 'assets/images/hiking.jpeg',
      'activities': [
        'Hiking trails',
        'Photography spots',
        'Cultural immersion'
      ],
    },
    {
      'title': 'Group Tours',
      'description': 'Social experiences with new people',
      'image': 'assets/images/fort jesus.png',
      'activities': [
        'Guide-led tours',
        'Group accommodations',
        'Shared experiences'
      ],
    },
  ];
  
  @override
  void initState() {
    super.initState();
    updateDisplayedCategories();
    
    // Set up a timer to rotate categories
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          startIndex = (startIndex + 1) % allCategories.length;
          updateDisplayedCategories();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  
  void updateDisplayedCategories() {
    displayedCategories = [];
    for (int i = 0; i < 3; i++) {
      int index = (startIndex + i) % allCategories.length;
      displayedCategories.add(allCategories[index]);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360, // Height for 3 items
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: ListView.builder(
          key: ValueKey<int>(startIndex), // Key changes trigger animation
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3, // Always showing 3 items
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final category = displayedCategories[index];
            return Container(
              height: 104,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Left image section
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.horizontal(left: Radius.circular(11)),
                    child: Image.asset(
                      category['image'],
                      width: 120,
                      height: 104,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Content section
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // Title with flexible width
                              Expanded(
                                child: Text(
                                  category['title'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              // Badge with fixed size
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.trending_up,
                                      size: 14,
                                      color: AppTheme.primaryColor,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Popular',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            category['description'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          // Auto-scrolling activities ticker
                          _buildActivitiesTicker(category['activities']),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Create an auto-scrolling ticker for activities within each category
  Widget _buildActivitiesTicker(List<dynamic> activities) {
    return SizedBox(
      height: 24,
      child: LayoutBuilder(builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(seconds: 10),
          curve: Curves.linear,
          builder: (context, value, child) {
            // Reset animation when complete
            if (value == 1) {
              Future.microtask(() {
                if (context.mounted) {
                  (context as Element).markNeedsBuild();
                }
              });
            }

            return Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRect(
                  child: SizedBox(
                    width: availableWidth,
                    child: Text(
                      activities[((activities.length) * value).floor() %
                          activities.length],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
