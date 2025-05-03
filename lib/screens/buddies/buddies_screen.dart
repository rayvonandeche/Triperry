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
          // App bar
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
                    ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.primaryColor.withOpacity(0.8),
                    ],
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
                          color: Colors.white.withOpacity(0.1),
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
                          color: Colors.white.withOpacity(0.1),
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
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Search bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search buddies...',
                            border: InputBorder.none,
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
                Text(
                  'Active Trips',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                _buildActiveTrips(),

                const SizedBox(height: 24),

                // Buddies list
                Text(
                  'Your Buddies',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                _buildBuddiesList(),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new buddy
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.person_add_rounded),
      ),
    );
  }

  Widget _buildActiveTrips() {
    final pexelsService = PexelsService();
    final demoVideos = pexelsService.getDemoVideos();

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: demoVideos.length,
        itemBuilder: (context, index) {
          final video = demoVideos[index];
          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Trip image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: video.thumbnailUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 120,
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Image.network(
                      'https://picsum.photos/id/${(index + 1) * 10}/800/450',
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 120,
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        child: Icon(Icons.error_outline, color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ),
                // Trip details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), // Further reduced vertical padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          video.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${['3', '5', '2'][index % 3]} buddies',
                          
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
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
    );
  }

  Widget _buildBuddiesList() {
    final pexelsService = PexelsService();
    final demoVideos = pexelsService.getDemoVideos();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: demoVideos.length,
      itemBuilder: (context, index) {
        final video = demoVideos[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
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
                    color: Colors.grey[600],
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