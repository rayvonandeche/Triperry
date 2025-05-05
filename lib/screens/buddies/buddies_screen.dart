import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:triperry/theme/app_theme.dart';
import 'package:triperry/services/pexels_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BuddiesScreen extends StatelessWidget {
  const BuddiesScreen({super.key});

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

                const SizedBox(height: 24),

                // Active trips section
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    'Active Trips',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                _buildActiveTrips(),

                const SizedBox(height: 24),

                // Buddies list
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    'Your Buddies',
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Add new buddy
      //   },
      //   backgroundColor: AppTheme.primaryColor,
      //   child: const Icon(Icons.person_add_rounded),
      // ),
    );
  }

  Widget _buildActiveTrips() {
    final pexelsService = PexelsService();
    final demoVideos = pexelsService.getDemoVideos();

    return SizedBox(
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
    );
  }

  Widget _buildBuddiesList() {
    final pexelsService = PexelsService();
    final demoVideos = pexelsService.getDemoVideos();

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
            leading: CircleAvatar(
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
            title: Text(
              ['Alex', 'Sarah', 'Mike', 'Emma', 'John'][index % 5],
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              video.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            isThreeLine: false,
            trailing: IconButton(
              icon: const Icon(Icons.message_rounded),
              color: AppTheme.primaryColor,
              onPressed: () {
                // Open chat
              },
            ),
          ),
        ).animate().fadeIn().slideX(
              begin: 0.2,
              duration: const Duration(milliseconds: 400),
              delay: Duration(milliseconds: 100 * index),
            );
      },
    );
  }
}