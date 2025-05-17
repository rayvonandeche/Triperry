import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:triperry/theme/app_theme.dart';
import 'package:triperry/services/pexels_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BuddiesScreen extends StatefulWidget {
  const BuddiesScreen({super.key});
  
  @override
  State<BuddiesScreen> createState() => _BuddiesScreenState();
}

class _BuddiesScreenState extends State<BuddiesScreen> {
  int _selectedCategoryIndex = 0;
  
  final List<Map<String, dynamic>> _buddyCategories = [
    {'name': 'All', 'icon': Icons.people_alt_rounded},
    {'name': 'Business', 'icon': Icons.business_center_rounded},
    {'name': 'Students', 'icon': Icons.school_rounded},
    {'name': 'Couples', 'icon': Icons.favorite_rounded},
    {'name': 'Adventure', 'icon': Icons.hiking_rounded},
    {'name': 'Family', 'icon': Icons.family_restroom_rounded},
    {'name': 'Solo', 'icon': Icons.person_rounded},
  ];
  
  Widget _buildBuddyCategories() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _buddyCategories.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedCategoryIndex;
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: isSelected ? 
                  AppTheme.primaryColor : 
                  (Theme.of(context).brightness == Brightness.dark ? 
                    Colors.grey[800] : Theme.of(context).scaffoldBackgroundColor),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppTheme.primaryColor : 
                    (Theme.of(context).brightness == Brightness.dark ? 
                      Colors.grey[700]! : Colors.grey[300]!),
                  width: 1,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  )
                ] : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          _buddyCategories[index]['icon'],
                          size: 20,
                          color: isSelected ? 
                            Colors.white : 
                            Theme.of(context).brightness == Brightness.dark ? 
                              Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.7),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _buddyCategories[index]['name'],
                          style: TextStyle(
                            color: isSelected ? 
                              Colors.white : 
                              Theme.of(context).brightness == Brightness.dark ? 
                                Colors.white : Colors.black,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: 100 * index));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with enhanced gradients
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Travel Buddies',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryColor.withBlue(AppTheme.primaryColor.blue + 30).withOpacity(0.95),
                      AppTheme.primaryColor.withOpacity(0.9),
                      AppTheme.primaryColor.withRed(AppTheme.primaryColor.red + 30).withOpacity(0.8),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -50,
                      bottom: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Search bar with improved visuals
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).cardColor.withOpacity(0.97),
                        Theme.of(context).cardColor.withOpacity(0.87),
                      ],
                      stops: const [0.3, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.black.withOpacity(0.05),
                      width: 0.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search buddies...',
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                          ),
                          onChanged: (value) {
                            // Handle search
                          },
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(
                      begin: 0.2,
                      duration: const Duration(milliseconds: 400),
                    ),

                const SizedBox(height: 16),
                
                // Buddy categories (horizontal scrollable tabs)
                _buildBuddyCategories(),
                
                const SizedBox(height: 24),

                // Active trips section
                _buildActiveTrips(),

                const SizedBox(height: 24),

                // Trip planner section
                _buildTripPlanner(),

                const SizedBox(height: 24),

                // Buddies list
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    _getBuddiesSectionTitle(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                _buildBuddiesList(),
                
                // Add bottom padding to ensure content isn't covered by FAB
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show find buddy modal
          _showFindBuddyModal();
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.person_add_rounded),
      ),
    );
  }

  Widget _buildActiveTrips() {
    final pexelsService = PexelsService();
    final demoVideos = pexelsService.getDemoVideos();
    
    // Filter trips based on selected category
    final String categoryFilter = _buddyCategories[_selectedCategoryIndex]['name'];
    final Map<String, String> categoryTrips = {
      'All': 'All Active Trips',
      'Business': 'Business Trips',
      'Students': 'Student Group Trips',
      'Couples': 'Romantic Getaways',
      'Adventure': 'Adventure Expeditions',
      'Family': 'Family Vacations',
      'Solo': 'Solo Traveler Groups',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(
            categoryTrips[categoryFilter] ?? 'Active Trips',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        SizedBox(
          height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: demoVideos.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final video = demoVideos[index];
          return Container(
            width: 260, // Slightly narrower for better visuals
            margin: EdgeInsets.only(
              right: index == demoVideos.length - 1 ? 0 : 16
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).cardColor.withOpacity(0.97),
                  Theme.of(context).cardColor.withOpacity(0.87),
                ],
                stops: const [0.3, 1.0],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.black.withOpacity(0.04),
                width: 0.8,
              ),
              // boxShadow: [
              //   BoxShadow(
              //     color: Theme.of(context).shadowColor.withOpacity(0.15),
              //     blurRadius: 15,
              //     offset: const Offset(0, 6),
              //     spreadRadius: 0.5,
              //   ),
              // ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trip image - consistent height
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: video.thumbnailUrl,
                    height: 130, // Fixed height for consistency
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 130,
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Image.network(
                      'https://picsum.photos/id/${(index + 1) * 10}/800/450',
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 130,
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        child: Icon(Icons.error_outline, color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ),
                // Trip details - consistent padding
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.people,
                            size: 16,
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${['3', '5', '2'][index % 3]} buddies',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideX(
                begin: 0.2,
                duration: const Duration(milliseconds: 400),
                delay: Duration(milliseconds: 100 * index),
              );
        },
      ),
    ),
      ],
    );
  }

  Widget _buildTripPlanner() {
    // Trip suggestions based on buddy category
    final Map<String, List<Map<String, dynamic>>> categoryTrips = {
      'All': [
        {
          'title': 'Weekend Getaway', 
          'location': 'Diani Beach', 
          'image': 'https://images.pexels.com/photos/1591373/pexels-photo-1591373.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
          'participants': 4,
        },
        {
          'title': 'City Exploration', 
          'location': 'Nairobi', 
          'image': 'https://images.pexels.com/photos/2404046/pexels-photo-2404046.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
          'participants': 3,
        },
      ],
      'Business': [
        {
          'title': 'Tech Conference', 
          'location': 'Nairobi Tech Week', 
          'image': 'https://images.pexels.com/photos/2182973/pexels-photo-2182973.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
          'participants': 5,
        },
        {
          'title': 'Professional Retreat', 
          'location': 'Mombasa Convention', 
          'image': 'https://images.pexels.com/photos/1181406/pexels-photo-1181406.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
          'participants': 8,
        },
      ],
      'Students': [
        {
          'title': 'Field Research Trip', 
          'location': 'Masai Mara', 
          'image': 'https://images.pexels.com/photos/36717/amazing-animal-beautiful-beautifull.jpg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
          'participants': 12,
        },
        {
          'title': 'Cultural Exchange', 
          'location': 'Lamu Island', 
          'image': 'https://images.pexels.com/photos/3935702/pexels-photo-3935702.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
          'participants': 6,
        },
      ],
      'Couples': [
        {
          'title': 'Romantic Beach Trip', 
          'location': 'Watamu', 
          'image': 'https://images.pexels.com/photos/1024960/pexels-photo-1024960.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
          'participants': 4,
        },
        {
          'title': 'Couple\'s Safari', 
          'location': 'Amboseli', 
          'image': 'https://images.pexels.com/photos/34098/south-africa-hluhluwe-imfolozi-park-south-african-safari.jpg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
          'participants': 6,
        },
      ],
      'Adventure': [
        {
          'title': 'Mount Kenya Expedition', 
          'location': 'Mount Kenya', 
          'image': 'https://images.pexels.com/photos/2335126/pexels-photo-2335126.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
          'participants': 8,
        },
        {
          'title': 'White Water Rafting', 
          'location': 'Sagana', 
          'image': 'https://images.pexels.com/photos/1732278/pexels-photo-1732278.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
          'participants': 10,
        },
      ],
      'Family': [
        {
          'title': 'Kid-friendly Safari', 
          'location': 'Nairobi National Park', 
          'image': 'https://images.pexels.com/photos/33045/lion-wild-africa-african.jpg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
          'participants': 14,
        },
        {
          'title': 'Beach Family Fun', 
          'location': 'Diani', 
          'image': 'https://images.pexels.com/photos/1470405/pexels-photo-1470405.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
          'participants': 12,
        },
      ],
      'Solo': [
        {
          'title': 'Backpacking Trip', 
          'location': 'Meru National Park', 
          'image': 'https://images.pexels.com/photos/1666021/pexels-photo-1666021.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
          'participants': 5,
        },
        {
          'title': 'Solo Travel Meetup', 
          'location': 'Nairobi', 
          'image': 'https://images.pexels.com/photos/2422290/pexels-photo-2422290.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
          'participants': 10,
        },
      ],
    };

    // Get trips for selected category or default
    final currentCategory = _buddyCategories[_selectedCategoryIndex]['name'];
    final trips = categoryTrips[currentCategory] ?? categoryTrips['All']!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getTripSectionTitle(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all trips
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 20, right: 10),
            scrollDirection: Axis.horizontal,
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 16, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Background image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: trip['image'] as String,
                        height: 220,
                        width: 280,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          child: Icon(Icons.error_outline, color: AppTheme.primaryColor),
                        ),
                      ),
                    ),
                    // Gradient overlay
                    Container(
                      height: 220,
                      width: 280,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                    ),
                    // Content
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trip['title'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    trip['location'] as String,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.people,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${trip['participants']} joined',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                    // Join trip
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                    minimumSize: const Size(60, 30),
                                  ),
                                  child: const Text('Join'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideX(
                    begin: 0.2,
                    duration: const Duration(milliseconds: 400),
                    delay: Duration(milliseconds: 100 * index),
                  );
            },
          ),
        ),
      ],
    );
  }

  String _getTripSectionTitle() {
    final category = _buddyCategories[_selectedCategoryIndex]['name'];
    switch (category) {
      case 'Business':
        return 'Business Travel & Networking';
      case 'Students':
        return 'Student Trips & Exchange Programs';
      case 'Couples':
        return 'Romantic Getaways';
      case 'Adventure':
        return 'Adventure Expeditions';
      case 'Family':
        return 'Family-Friendly Trips';
      case 'Solo':
        return 'Solo Traveler Meetups';
      default:
        return 'Popular Group Trips';
    }
  }

  Widget _buildBuddiesList() {
    final pexelsService = PexelsService();
    final demoVideos = pexelsService.getDemoVideos();

    // Get names based on category
    List<String> names;
    switch (_buddyCategories[_selectedCategoryIndex]['name']) {
      case 'Business':
        names = ['James (Consultant)', 'Lisa (Tech CEO)', 'Robert (Marketing)', 'Michelle (Finance)', 'David (Startup)'];
        break;
      case 'Students':
        names = ['Taylor (University)', 'Kevin (Exchange)', 'Zoe (Grad School)', 'Ryan (Study Abroad)', 'Mia (College)'];
        break;
      case 'Couples':
        names = ['Alex & Jamie', 'Chris & Morgan', 'Jordan & Casey', 'Sam & Riley', 'Taylor & Avery'];
        break;
      case 'Adventure':
        names = ['Mike (Climber)', 'Sophia (Hiker)', 'Ethan (Kayaker)', 'Olivia (Explorer)', 'Lucas (Guide)'];
        break;
      case 'Family':
        names = ['The Smiths', 'Johnson Family', 'Wang Family', 'Garcia Family', 'Miller Family'];
        break;
      case 'Solo':
        names = ['Alex (Backpacker)', 'Sarah (Nomad)', 'Mike (Adventurer)', 'Emma (Explorer)', 'John (Traveler)'];
        break;
      default:
        names = ['Alex', 'Sarah', 'Mike', 'Emma', 'John'];
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: demoVideos.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final video = demoVideos[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).cardColor.withOpacity(0.97),
                Theme.of(context).cardColor.withOpacity(0.87),
              ],
              stops: const [0.3, 1.0],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.04),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: video.thumbnailUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Image.network(
                        'https://picsum.photos/id/${(index + 1) * 20}/200/200',
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          child: Icon(Icons.error_outline, color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ),
                ),
                if (_selectedCategoryIndex != 0)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        _buddyCategories[_selectedCategoryIndex]['icon'],
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            title: Text(
              names[index % names.length],
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              _getBuddySubtitle(index),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.message_rounded),
                  color: AppTheme.primaryColor,
                  onPressed: () {
                    // Open chat
                  },
                  tooltip: 'Chat',
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today_outlined),
                  color: Colors.grey[700],
                  onPressed: () {
                    // Plan trip
                  },
                  tooltip: 'Plan Trip',
                ),
              ],
            ),
            onTap: () {
              // View buddy profile
            },
          ),
        ).animate().fadeIn().slideX(
              begin: 0.2,
              duration: const Duration(milliseconds: 400),
              delay: Duration(milliseconds: 100 * index),
            );
      },
    );
  }

  String _getBuddiesSectionTitle() {
    final String category = _buddyCategories[_selectedCategoryIndex]['name'];
    
    switch (category) {
      case 'All':
        return 'Your Buddies';
      case 'Business':
        return 'Business Contacts';
      case 'Students':
        return 'Student Groups';
      case 'Couples':
        return 'Romantic Partners';
      case 'Adventure':
        return 'Adventure Seekers';
      case 'Family':
        return 'Family Companions';
      case 'Solo':
        return 'Solo Travelers';
      default:
        return 'Your Buddies';
    }
  }

  void _showFindBuddyModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle indicator
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Find Travel Buddies',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Content goes here
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Connect with fellow travelers who share your interests!',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  
                  // Category filter tabs
                  _buildCategoryFilterTabs(),
                  
                  const SizedBox(height: 24),
                  
                  // Recommended buddies
                  _buildRecommendedBuddies(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategoryFilterTabs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
          child: Text(
            'I\'m looking for:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _buddyCategories.map((category) {
            final isSelected = category['name'] == _buddyCategories[_selectedCategoryIndex]['name'];
            final index = _buddyCategories.indexOf(category);
            if (index == 0) return const SizedBox.shrink(); // Skip "All" category
            
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedCategoryIndex = index;
                  Navigator.pop(context);
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryColor : 
                    (Theme.of(context).brightness == Brightness.dark ? 
                      Colors.grey[800] : Colors.grey[200]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppTheme.primaryColor : 
                      (Theme.of(context).brightness == Brightness.dark ? 
                        Colors.grey[700]! : Colors.grey[300]!),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category['icon'],
                      size: 18,
                      color: isSelected ? Colors.white : 
                        (Theme.of(context).brightness == Brightness.dark ? 
                          Colors.white : Colors.black87),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category['name'],
                      style: TextStyle(
                        color: isSelected ? Colors.white : 
                          (Theme.of(context).brightness == Brightness.dark ? 
                            Colors.white : Colors.black87),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: Duration(milliseconds: 50 * index));
          }).toList(),
        ),
      ],
    );
  }
  
  Widget _buildRecommendedBuddies() {
    final pexelsService = PexelsService();
    final demoVideos = pexelsService.getDemoVideos().take(3).toList();
    
    // Define recommended buddy profiles based on category
    final Map<String, List<Map<String, dynamic>>> categoryProfiles = {
      'Business': [
        {'name': 'James (Tech CEO)', 'interest': 'Conference networking'},
        {'name': 'Lisa (Consultant)', 'interest': 'Business retreats'},
        {'name': 'Robert (Marketing)', 'interest': 'International meetings'},
      ],
      'Students': [
        {'name': 'Taylor (Exchange)', 'interest': 'Language learning tours'},
        {'name': 'Kevin (Grad School)', 'interest': 'Research expeditions'},
        {'name': 'Zoe (University)', 'interest': 'Study abroad programs'},
      ],
      'Couples': [
        {'name': 'Alex & Jamie', 'interest': 'Honeymoon destinations'},
        {'name': 'Chris & Morgan', 'interest': 'Romantic getaways'},
        {'name': 'Jordan & Casey', 'interest': 'Adventure for two'},
      ],
      'Adventure': [
        {'name': 'Mike (Guide)', 'interest': 'Mountain climbing'},
        {'name': 'Sophia (Explorer)', 'interest': 'Safari photography'},
        {'name': 'Ethan (Kayaker)', 'interest': 'White water rafting'},
      ],
      'Family': [
        {'name': 'The Smiths', 'interest': 'Kid-friendly safaris'},
        {'name': 'Johnson Family', 'interest': 'Educational holidays'},
        {'name': 'Wang Family', 'interest': 'Cultural experiences'},
      ],
      'Solo': [
        {'name': 'Alex (Backpacker)', 'interest': 'Budget travel tips'},
        {'name': 'Sarah (Nomad)', 'interest': 'Solo female travel'},
        {'name': 'John (Adventurer)', 'interest': 'Off-grid experiences'},
      ],
    };
    
    // Get profiles for selected category or default
    final currentCategory = _buddyCategories[_selectedCategoryIndex]['name'];
    final profiles = categoryProfiles[currentCategory] ?? categoryProfiles['Solo']!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
          child: Text(
            'Recommended for you',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: profiles.length,
          itemBuilder: (context, index) {
            final video = demoVideos[index % demoVideos.length];
            final profile = profiles[index];
            
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // Show buddy profile
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: video.thumbnailUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Container(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              child: Icon(
                                _buddyCategories[_selectedCategoryIndex]['icon'],
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile['name']!,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Interest: ${profile['interest']}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Send connection request
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Connection request sent to ${profile['name']}'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text('Connect'),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(delay: Duration(milliseconds: 100 * index))
              .slideY(begin: 0.1, end: 0, delay: Duration(milliseconds: 100 * index));
          },
        ),
      ],
    );
  }

  String _getBuddySubtitle(int index) {
    final category = _buddyCategories[_selectedCategoryIndex]['name'];
    
    final Map<String, List<String>> subtitles = {
      'All': ['Last trip: Kenya Safari', 'Next trip: Beach getaway', 'Planning a city tour', 'Looking for weekend plans'],
      'Business': ['Tech Conference attendee', 'Looking for networking events', 'Corporate retreat planner', 'Business trip to Nairobi'],
      'Students': ['Exchange program to Kenya', 'University field trip', 'Studying abroad', 'Educational tour organizer'],
      'Couples': ['Planning anniversary trip', 'Honeymoon safari', 'Weekend getaway planners', 'Looking for romantic spots'],
      'Adventure': ['Mountain climbing enthusiast', 'White water rafting expert', 'Safari adventure guide', 'Hiking trip planner'],
      'Family': ['Planning family safari', 'Family of 4 - kid-friendly trips', 'Family beach vacation', 'Educational trips for kids'],
      'Solo': ['Solo traveler since 2020', 'Backpacker - 15 countries', 'Digital nomad exploring Kenya', 'Looking for group tours'],
    };
    
    final options = subtitles[category] ?? subtitles['All']!;
    return options[index % options.length];
  }
}