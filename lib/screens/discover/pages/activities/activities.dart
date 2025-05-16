import 'package:flutter/material.dart';
import 'package:triperry/theme/app_theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';
import '../../../../services/kenya_activities_data.dart';
import 'activities_detail_screen.dart';

void showActivityTypeSheet(BuildContext context, String activityType) {
  // This would be implemented in a separate file similar to accommodation/restaurant
  // SnackBar removed as content already updates on category change
}

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> with SingleTickerProviderStateMixin {
  String _selectedCategory = 'All';
  final List<String> _categories = KenyaActivitiesData.activityCategories;
  
  // Search and filter fields
  final TextEditingController _searchController = TextEditingController();
  RangeValues _priceRange = const RangeValues(0, 25000);
  double _minRating = 4.0;
  
  // Filtered activities items
  late List<Map<String, dynamic>> _filteredActivities;
  
  late AnimationController _animationController;
    @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    // Initialize filtered activities with all activities
    _filteredActivities = KenyaActivitiesData.getAllActivities();
    
    // Auto-rotate animation to draw attention to the category selector
    Future.delayed(const Duration(seconds: 1), () {
      _animationController.repeat(reverse: true);
    });
  }
  
  // Filter activities based on selected category, search query and filters
  void _filterActivities() {
    List<Map<String, dynamic>> activities;
    
    // First filter by category
    if (_selectedCategory == 'All') {
      activities = KenyaActivitiesData.getAllActivities();
    } else {
      activities = KenyaActivitiesData.getAllActivities().where((item) => 
        item['category'] == _selectedCategory
      ).toList();
    }
    
    // Apply search filter if text is entered
    if (_searchController.text.isNotEmpty) {
      final searchQuery = _searchController.text.toLowerCase();
      activities = activities.where((item) => 
        item['title'].toString().toLowerCase().contains(searchQuery) ||
        item['description'].toString().toLowerCase().contains(searchQuery) ||
        item['location'].toString().toLowerCase().contains(searchQuery)
      ).toList();
    }
    
    // Filter by price range
    activities = activities.where((item) => 
      item['priceValue'] >= _priceRange.start && 
      item['priceValue'] <= _priceRange.end
    ).toList();
    
    // Filter by rating
    activities = activities.where((item) => 
      (item['rating'] as double) >= _minRating
    ).toList();
    
    setState(() {
      _filteredActivities = activities;
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildActivitiesContent();
  }

  Widget buildActivitiesContent() {
    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 80),
      children: [
        _buildSearchAndFilterSection(),
        const SizedBox(height: 16),
        _buildCarouselSection(),
        const SizedBox(height: 24),
        _buildSectionTitle('Activity Categories'),
        const SizedBox(height: 16),
        _buildCategoriesSection(),
        const SizedBox(height: 24),
        _buildSectionTitle('Popular Activities'),
        const SizedBox(height: 16),
        _buildPopularActivitiesSection(),
        const SizedBox(height: 24),
        _buildSectionTitle('Recommended For You'),
        const SizedBox(height: 16),
        _buildRecommendedSection(),
      ],
    );
  }
  
  // Build search and filter section at the top of the screen
  Widget _buildSearchAndFilterSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          // Search bar with location icon
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Icon(
                          Icons.search,
                          color: AppTheme.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search activities or locations',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            onChanged: (_) => _filterActivities(),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: _searchController.text.isEmpty ? Colors.transparent : Colors.grey.shade600,
                          ),
                          onPressed: () {
                            if (_searchController.text.isNotEmpty) {
                              setState(() {
                                _searchController.clear();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(color: Colors.grey.shade200),
          ),
          
          // Filter options
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                // Duration selector
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _showDurationOptions(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.grey.shade700,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Duration',
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                
                // Price range selector
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _showPriceRangeSelector(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.attach_money,
                            color: Colors.grey.shade700,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Price',
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                
                // Filter button
                InkWell(
                  onTap: () {
                    _showFilterOptions(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.filter_list,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Build featured activities carousel section
  Widget _buildCarouselSection() {
    final PageController _pageController = PageController(viewportFraction: 0.93);
    final List<Map<String, dynamic>> featuredActivities = KenyaActivitiesData.getFeaturedActivities();

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            itemCount: featuredActivities.length,
            itemBuilder: (context, index) {
              final activity = featuredActivities[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to detail screen - will be implemented later
                  _navigateToActivityDetail(activity);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        // Image
                        Image.asset(
                          activity['image'],
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                        ),
                        // Gradient overlay
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
                        // Content
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activity['title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  activity['description'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          activity['location'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'Book Now',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
        const SizedBox(height: 16),
        SmoothPageIndicator(
          controller: _pageController,
          count: featuredActivities.length,
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            type: WormType.thin,
            activeDotColor: AppTheme.primaryColor,
            dotColor: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Categories section with horizontal scrolling
  Widget _buildCategoriesSection() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          
          // Get icon based on category
          IconData icon;
          switch (category) {
            case 'Safari': icon = Icons.visibility; break;
            case 'Coastal': icon = Icons.waves; break;
            case 'Adventure': icon = Icons.terrain; break;
            case 'Cultural': icon = Icons.theater_comedy; break;
            case 'Urban': icon = Icons.location_city; break;
            case 'Nature': icon = Icons.park; break;
            default: icon = Icons.explore; break;
          }
            return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
                _filterActivities(); // Apply filter when category changes
              });
                // Category filtering happens automatically via _filterActivities()
            },
            child: Container(
              width: 100,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryColor : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 8,
                        )
                      ] : null,
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? AppTheme.primaryColor : Colors.grey.shade700,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
    // Popular activities section
  Widget _buildPopularActivitiesSection() {
    // Use filtered activities if category is selected, otherwise show popular activities
    final List<Map<String, dynamic>> popularActivities = 
      _selectedCategory != 'All' ? _filteredActivities : KenyaActivitiesData.getPopularActivities();
    
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: popularActivities.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final activity = popularActivities[index];
          return GestureDetector(
            onTap: () {
              _navigateToActivityDetail(activity);
            },
            child: Container(
              width: 200,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    spreadRadius: 1,
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(
                      activity['image'],
                      width: 200,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          activity['location'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              activity['price'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 14,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  activity['rating'].toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
    // Recommended activities section
  Widget _buildRecommendedSection() {
    // Use filtered activities if category is selected, otherwise show recommended activities
    final List<Map<String, dynamic>> recommendedActivities = 
      _selectedCategory != 'All' ? _filteredActivities : KenyaActivitiesData.getRecommendedActivities();

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: recommendedActivities.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final activity = recommendedActivities[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              _navigateToActivityDetail(activity);
            },
            child: Row(
              children: [
                // Image
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                  child: Image.asset(
                    activity['image'],
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          activity['location'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          activity['duration'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              activity['price'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 14),
                                const SizedBox(width: 2),
                                Text(
                                  activity['rating'].toString(),
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ' (${activity['reviews']})',
                                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // Show duration options
  void _showDurationOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Duration',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Less than 2 hours'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Selected: Less than 2 hours')),
                );
              },
            ),
            ListTile(
              title: const Text('2-4 hours'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Selected: 2-4 hours')),
                );
              },
            ),
            ListTile(
              title: const Text('Half-day (4-6 hours)'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Selected: Half-day')),
                );
              },
            ),
            ListTile(
              title: const Text('Full-day'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Selected: Full-day')),
                );
              },
            ),
            ListTile(
              title: const Text('Multi-day'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Selected: Multi-day')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  // Show price range selector
  void _showPriceRangeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Price Range',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: 25000,
                  divisions: 25,
                  labels: RangeLabels(
                    'KSh ${_priceRange.start.toInt()}',
                    'KSh ${_priceRange.end.toInt()}',
                  ),
                  onChanged: (values) {
                    setModalState(() {
                      _priceRange = values;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('KSh ${_priceRange.start.toInt()}'),
                    Text('KSh ${_priceRange.end.toInt()}'),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(                    onPressed: () {
                      Navigator.pop(context);
                      _filterActivities(); // Apply filter when price range changes
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Price range set: KSh ${_priceRange.start.toInt()} - KSh ${_priceRange.end.toInt()}')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  // Show filter options
  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter Activities',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          _minRating = 4.0;
                          _priceRange = const RangeValues(0, 25000);
                        });
                      },
                      child: Text(
                        'Reset',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Minimum Rating',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Slider(
                  value: _minRating,
                  min: 0,
                  max: 5,
                  divisions: 10,
                  label: _minRating.toStringAsFixed(1),
                  activeColor: AppTheme.primaryColor,
                  inactiveColor: Colors.grey.shade300,
                  onChanged: (value) {
                    setModalState(() {
                      _minRating = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Price Range',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: 25000,
                  divisions: 25,
                  labels: RangeLabels(
                    'KSh ${_priceRange.start.toInt()}',
                    'KSh ${_priceRange.end.toInt()}',
                  ),
                  activeColor: AppTheme.primaryColor,
                  inactiveColor: Colors.grey.shade300,
                  onChanged: (values) {
                    setModalState(() {
                      _priceRange = values;
                    });
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Amenities',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    'Transport',
                    'Guide',
                    'Meals',
                    'Equipment',
                    'Entrance Fees',
                  ]
                      .map((amenity) => FilterChip(
                            label: Text(amenity),
                            selected: false,
                            onSelected: (selected) {
                              // Implement amenity filter
                            },
                            selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                            checkmarkColor: AppTheme.primaryColor,
                          ))
                      .toList(),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(                    onPressed: () {
                      Navigator.pop(context);
                      _filterActivities(); // Apply filter when filters are applied
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
    void _navigateToActivityDetail(Map<String, dynamic> activity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivityDetailScreen(
          activity: activity,
        ),
      ),
    );
  }
}
