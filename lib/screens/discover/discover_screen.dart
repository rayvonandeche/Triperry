import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:triperry/models/photo_response.dart';
import 'package:triperry/models/video_item.dart';
import 'package:triperry/screens/discover/widgets/image_carousel.dart';
import 'package:triperry/screens/discover/widgets/video_card.dart';
import 'package:triperry/providers/media_cache_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DiscoverPage extends StatefulWidget {
  final double toolbarHeight;
  final List<Animation<double>> scaleAnimations;
  final List<Animation<double>> fadeAnimations;
  final AnimationController containerController;

  const DiscoverPage({
    super.key,
    required this.toolbarHeight,
    required this.scaleAnimations,
    required this.fadeAnimations,
    required this.containerController,
  });

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  static const double containerPadding = 12.0;
  List<PhotoResponse> photos = [];
  bool isLoading = true;
  int _selectedCategoryIndex = 0;
  int _currentVideoPage = 0; // Track current video page
  final List<String> _categories = [
    "Popular Destinations",
    "Exotic Beaches",
    "Mountain Getaways",
    "City Adventures"
  ];

  // Travel data organization
  Map<String, List<PhotoResponse>> _categorizedPhotos = {};

  // Videos for short videos section
  List<VideoItem> _travelShorts = [];
  // Starting page for infinite scrolling - a large number
  static const int _initialVideoPage = 1000;
  late final PageController _videoPageController;
  Timer? _autoScrollTimer;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _fadeAnimations;
  late AnimationController _containerController;

  @override
  void initState() {
    super.initState();
    // Initialize PageController with a large initial page to allow "infinite" scrolling in both directions
    _videoPageController = PageController(initialPage: _initialVideoPage);
    
    // Check cache before loading data
    _loadCachedDataOrFetch();
    
    // Initialize auto-scroll timer for videos
    _startVideoAutoScroll();

    // Add listener to track current page
    _videoPageController.addListener(_videoPageListener);
    
    // Set initial current page
    _currentVideoPage = _initialVideoPage;

    _containerController = widget.containerController;

    _scaleAnimations = List.generate(5, (index) {
      final double startInterval = index * 0.08;
      final double endInterval = startInterval + 0.4;
      return Tween<double>(begin: 1, end: 1.03).animate(
        CurvedAnimation(
          parent: _containerController,
          curve: Interval(
            startInterval,
            endInterval,
            curve: Curves.easeOutQuint,
          ),
          reverseCurve: Interval(
            startInterval,
            endInterval,
            curve: Curves.easeOutQuint,
          ),
        ),
      );
    });

    _fadeAnimations = List.generate(5, (index) {
      final double startInterval = index * 0.12;
      final double endInterval = math.min(startInterval + 0.3, 1.0);
      return Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _containerController,
          curve: Interval(
            startInterval,
            endInterval,
            curve: Curves.fastEaseInToSlowEaseOut,
          ),
        ),
      );
    });
  }
  
  /// Load data from cache or fetch from network if not available
  void _loadCachedDataOrFetch() {
    final mediaCache = Provider.of<MediaCacheProvider>(context, listen: false);
    
    // Try to load photos from cache
    final cachedPhotos = mediaCache.getAllCachedPhotos();
    if (cachedPhotos != null && cachedPhotos.isNotEmpty) {
      // Photos are available in cache
      setState(() {
        photos = cachedPhotos;
        _setupCategorizedPhotos();
        isLoading = false;
      });
    } else {
      // No cached photos, load from network
      _loadImages().then((_) {
        if (mounted) {
          setState(() {
            _setupCategorizedPhotos();
            isLoading = false;
          });
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          debugPrint('Error loading images: $error');
        }
      });
    }
    
    // Try to load videos from cache
    final cachedVideos = mediaCache.getCachedVideos();
    if (cachedVideos != null && cachedVideos.isNotEmpty) {
      // Videos are available in cache
      setState(() {
        _travelShorts = cachedVideos;
      });
    } else {
      // No cached videos, load from network
      _loadVideos().catchError((error) {
        debugPrint('Error loading videos: $error');
      });
    }
  }
  
  /// Setup categorized photos from the main photo list
  void _setupCategorizedPhotos() {
    if (photos.isEmpty) return;
    
    // Organize photos by category
    _categorizedPhotos = {
      "Popular Destinations": photos,
      "Exotic Beaches": photos.where((p) => 
          p.alt.toLowerCase().contains("beach") || 
          p.alt.toLowerCase().contains("ocean") ||
          p.alt.toLowerCase().contains("sea") ||
          p.photographer.toLowerCase().contains("coastal")).toList(),
      "Mountain Getaways": photos.where((p) => 
          p.alt.toLowerCase().contains("mountain") || 
          p.alt.toLowerCase().contains("alps") ||
          p.alt.toLowerCase().contains("hill") ||
          p.alt.toLowerCase().contains("peak")).toList(),
      "City Adventures": photos.where((p) => 
          p.alt.toLowerCase().contains("city") || 
          p.alt.toLowerCase().contains("urban") ||
          p.alt.toLowerCase().contains("skyline")).toList(),
    };
    
    // Ensure each category has at least one photo
    for (final category in _categories) {
      if (_categorizedPhotos[category] == null || _categorizedPhotos[category]!.isEmpty) {
        _categorizedPhotos[category] = photos.take(2).toList();
      }
    }
  }

  void _videoPageListener() {
    if (_videoPageController.hasClients && _videoPageController.page != null) {
      final page = _videoPageController.page!.round();
      if (page != _currentVideoPage) {
        setState(() {
          _currentVideoPage = page;
        });
      }
    }
  }
  
  // Get the actual video index from infinite scrolling index
  int _getActualVideoIndex(int index) {
    if (_travelShorts.isEmpty) return 0;
    return index % _travelShorts.length;
  }

  void _startVideoAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (_videoPageController.hasClients && _travelShorts.length > 1) {
        final nextPage = _currentVideoPage + 1;
        _videoPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _videoPageController.removeListener(_videoPageListener);
    _videoPageController.dispose();
    super.dispose();
  }

  Future<void> _loadVideos() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      final videos = [
        VideoItem(
          id: 1,
          title: "Santorini Sunset Views",
          description:
              "Experience the breathtaking sunset views of Santorini, Greece",
          url: "https://example.com/video1",
          thumbnailUrl: "https://picsum.photos/id/135/800/450",
          uploadedBy: "Travel Inspo",
          duration: 45,
          views: 156000,
          uploadDate: DateTime.now().subtract(const Duration(days: 5)),
          tags: ["Greece", "Santorini", "Sunset"],
        ),
        VideoItem(
          id: 2,
          title: "Bali Beach Paradise",
          description: "Explore the pristine beaches of Bali, Indonesia",
          url: "https://example.com/video2",
          thumbnailUrl: "https://picsum.photos/id/143/800/450",
          uploadedBy: "Island Explorer",
          duration: 62,
          views: 235000,
          uploadDate: DateTime.now().subtract(const Duration(days: 8)),
          tags: ["Bali", "Beach", "Indonesia"],
        ),
        VideoItem(
          id: 3,
          title: "Tokyo Street Tour",
          description: "Walk through the vibrant streets of Tokyo at night",
          url: "https://example.com/video3",
          thumbnailUrl: "https://picsum.photos/id/164/800/450",
          uploadedBy: "Urban Adventures",
          duration: 58,
          views: 198000,
          uploadDate: DateTime.now().subtract(const Duration(days: 3)),
          tags: ["Tokyo", "Japan", "City"],
        ),
        VideoItem(
          id: 4,
          title: "Swiss Alps Hiking Guide",
          description: "Tips for hiking through the majestic Swiss Alps",
          url: "https://example.com/video4",
          thumbnailUrl: "https://picsum.photos/id/110/800/450",
          uploadedBy: "Mountain Expeditions",
          duration: 72,
          views: 127000,
          uploadDate: DateTime.now().subtract(const Duration(days: 12)),
          tags: ["Switzerland", "Alps", "Hiking"],
        ),
      ];

      // Cache the videos for future use
      final mediaCache = Provider.of<MediaCacheProvider>(context, listen: false);
      mediaCache.cacheVideos(videos);

      setState(() {
        _travelShorts = videos;
      });
    } catch (e) {
      debugPrint('Error loading videos: $e');
    }
  }

  Future<void> _loadImages() async {
    try {
      // Simulating loading a few sample images with different IDs
      await Future.delayed(const Duration(milliseconds: 800));
      final allPhotos = [
        PhotoResponse(
          id: 1,
          width: 1200,
          height: 800,
          url: "https://picsum.photos/id/10/1200/800",
          photographer: "Beautiful Destinations",
          photographerUrl: "https://unsplash.com/",
          photographerId: 123,
          avgColor: "#26547C",
          src: PhotoSrc(
              original: "https://picsum.photos/id/10/1200/800",
              large2x: "https://picsum.photos/id/10/1200/800",
              large: "https://picsum.photos/id/10/800/600",
              medium: "https://picsum.photos/id/10/500/400",
              small: "https://picsum.photos/id/10/300/200",
              portrait: "https://picsum.photos/id/10/800/1200",
              landscape: "https://picsum.photos/id/10/1200/800",
              tiny: "https://picsum.photos/id/10/200/200"),
          alt: "Swiss Alps Mountain Resort",
        ),
        PhotoResponse(
          id: 2,
          width: 1200,
          height: 800,
          url: "https://picsum.photos/id/15/1200/800",
          photographer: "Travel Insights",
          photographerUrl: "https://unsplash.com/",
          photographerId: 456,
          avgColor: "#58A4B0",
          src: PhotoSrc(
              original: "https://picsum.photos/id/15/1200/800",
              large2x: "https://picsum.photos/id/15/1200/800",
              large: "https://picsum.photos/id/15/800/600",
              medium: "https://picsum.photos/id/15/500/400",
              small: "https://picsum.photos/id/15/300/200",
              portrait: "https://picsum.photos/id/15/800/1200",
              landscape: "https://picsum.photos/id/15/1200/800",
              tiny: "https://picsum.photos/id/15/200/200"),
          alt: "Maldives Overwater Bungalows",
        ),
        PhotoResponse(
          id: 3,
          width: 1200,
          height: 800,
          url: "https://picsum.photos/id/28/1200/800",
          photographer: "Urban Adventures",
          photographerUrl: "https://unsplash.com/",
          photographerId: 789,
          avgColor: "#D8973C",
          src: PhotoSrc(
              original: "https://picsum.photos/id/28/1200/800",
              large2x: "https://picsum.photos/id/28/1200/800",
              large: "https://picsum.photos/id/28/800/600",
              medium: "https://picsum.photos/id/28/500/400",
              small: "https://picsum.photos/id/28/300/200",
              portrait: "https://picsum.photos/id/28/800/1200",
              landscape: "https://picsum.photos/id/28/1200/800",
              tiny: "https://picsum.photos/id/28/200/200"),
          alt: "Manhattan Skyline at Sunset",
        ),
        PhotoResponse(
          id: 4,
          width: 1200,
          height: 800,
          url: "https://picsum.photos/id/42/1200/800",
          photographer: "Nature Explorers",
          photographerUrl: "https://unsplash.com/",
          photographerId: 101,
          avgColor: "#64A6BD",
          src: PhotoSrc(
              original: "https://picsum.photos/id/42/1200/800",
              large2x: "https://picsum.photos/id/42/1200/800",
              large: "https://picsum.photos/id/42/800/600",
              medium: "https://picsum.photos/id/42/500/400",
              small: "https://picsum.photos/id/42/300/200",
              portrait: "https://picsum.photos/id/42/800/1200",
              landscape: "https://picsum.photos/id/42/1200/800",
              tiny: "https://picsum.photos/id/42/200/200"),
          alt: "Yosemite National Park Valley",
        ),
        // Additional beach destinations
        PhotoResponse(
          id: 5,
          width: 1200,
          height: 800,
          url: "https://picsum.photos/id/65/1200/800",
          photographer: "Coastal Dreams",
          photographerUrl: "https://unsplash.com/",
          photographerId: 202,
          avgColor: "#7DCFB6",
          src: PhotoSrc(
              original: "https://picsum.photos/id/65/1200/800",
              large2x: "https://picsum.photos/id/65/1200/800",
              large: "https://picsum.photos/id/65/800/600",
              medium: "https://picsum.photos/id/65/500/400",
              small: "https://picsum.photos/id/65/300/200",
              portrait: "https://picsum.photos/id/65/800/1200",
              landscape: "https://picsum.photos/id/65/1200/800",
              tiny: "https://picsum.photos/id/65/200/200"),
          alt: "Bora Bora Crystal Lagoon",
        ),
        PhotoResponse(
          id: 6,
          width: 1200,
          height: 800,
          url: "https://picsum.photos/id/87/1200/800",
          photographer: "Mountain Views",
          photographerUrl: "https://unsplash.com/",
          photographerId: 303,
          avgColor: "#3D5A80",
          src: PhotoSrc(
              original: "https://picsum.photos/id/87/1200/800",
              large2x: "https://picsum.photos/id/87/1200/800",
              large: "https://picsum.photos/id/87/800/600",
              medium: "https://picsum.photos/id/87/500/400",
              small: "https://picsum.photos/id/87/300/200",
              portrait: "https://picsum.photos/id/87/800/1200",
              landscape: "https://picsum.photos/id/87/1200/800",
              tiny: "https://picsum.photos/id/87/200/200"),
          alt: "Canadian Rockies in Spring",
        ),
        PhotoResponse(
          id: 7,
          width: 1200,
          height: 800,
          url: "https://picsum.photos/id/100/1200/800",
          photographer: "City Explorer",
          photographerUrl: "https://unsplash.com/",
          photographerId: 404,
          avgColor: "#FFA07A",
          src: PhotoSrc(
              original: "https://picsum.photos/id/100/1200/800",
              large2x: "https://picsum.photos/id/100/1200/800",
              large: "https://picsum.photos/id/100/800/600",
              medium: "https://picsum.photos/id/100/500/400",
              small: "https://picsum.photos/id/100/300/200",
              portrait: "https://picsum.photos/id/100/800/1200",
              landscape: "https://picsum.photos/id/100/1200/800",
              tiny: "https://picsum.photos/id/100/200/200"),
          alt: "Tokyo Night Skyline",
        ),
      ];

      if (!mounted) return;

      // Cache the photos for future use
      final mediaCache = Provider.of<MediaCacheProvider>(context, listen: false);
      mediaCache.cacheAllPhotos(allPhotos);
      
      // Update state with new photos
      setState(() {
        photos = allPhotos;
      });
      
      // Organize photos by category
      _setupCategorizedPhotos();

      // Also cache by category
      for (final category in _categories) {
        if (_categorizedPhotos[category] != null) {
          mediaCache.cachePhotos(_categorizedPhotos[category]!, category);
        }
      }
    } catch (e) {
      debugPrint('Error loading images: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      rethrow; // Re-throw to be caught by the caller
    }
  }

  String _formatDateRange(DateTime startDate, DateTime endDate) {
    final start = "${startDate.day}/${startDate.month}/${startDate.year}";
    final end = "${endDate.day}/${endDate.month}/${endDate.year}";
    return "$start - $end";
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(
        top: widget.toolbarHeight + 8.0,
        bottom: 80.0, // Adjusted for bottom navigation bar
      ),
      children: [
        // Packages carousel
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: AnimatedBuilder(
            animation: widget.containerController,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.scaleAnimations[0].value,
                child: Opacity(
                  opacity: widget.fadeAnimations[0].value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Packages for You',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      if (!isLoading && photos.isNotEmpty)
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.7,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (context, i) {
                              final photo = photos[i];
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Theme.of(context).colorScheme.surface,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: photo.src.medium,
                                        height: MediaQuery.of(context).size.width * 0.4,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                          height: MediaQuery.of(context).size.width * 0.4,
                                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                          child: const Center(child: CircularProgressIndicator()),
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          height: MediaQuery.of(context).size.width * 0.4,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.broken_image, size: 40),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Planned Trip: ${photo.alt}',
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Dates: ${_formatDateRange(DateTime.now().add(Duration(days: i * 5)), DateTime.now().add(Duration(days: i * 5 + 3)))}',
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Join your buddies for this trip!',
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: Theme.of(context).colorScheme.primary,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      else
                        Container(
                          height: MediaQuery.of(context).size.width * 0.6,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Travel categories horizontal list
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: AnimatedBuilder(
            animation: widget.containerController,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.scaleAnimations[0].value,
                child: Opacity(
                  opacity: widget.fadeAnimations[0].value,
                  child: SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final isSelected = _selectedCategoryIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategoryIndex = index;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                _categories[index],
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // Featured destination carousel
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: AnimatedBuilder(
            animation: widget.containerController,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.scaleAnimations[1].value,
                child: Opacity(
                  opacity: widget.fadeAnimations[1].value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Featured ${_categories[_selectedCategoryIndex]}',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('See All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (!isLoading &&
                          _categorizedPhotos[
                                  _categories[_selectedCategoryIndex]] !=
                              null)
                        ImageCarousel(
                          photos: _categorizedPhotos[
                              _categories[_selectedCategoryIndex]]!,
                          height: MediaQuery.of(context).size.width * 0.6,
                        )
                      else
                        Container(
                          height: MediaQuery.of(context).size.width * 0.6,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceVariant
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child:
                              const Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 24),

        // Trending travel experiences
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: AnimatedBuilder(
            animation: widget.containerController,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.scaleAnimations[2].value,
                child: Opacity(
                  opacity: widget.fadeAnimations[2].value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trending Travel Experiences',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (!isLoading && photos.isNotEmpty)
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (context, i) {
                            final photo = photos[i];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(containerPadding),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(24)),
                                border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.08)),
                                color: [
                                  Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                      .withOpacity(0.3),
                                  Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer
                                      .withOpacity(0.3),
                                  Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer
                                      .withOpacity(0.3),
                                ][i],
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedNetworkImage(
                                        imageUrl: photo.src.medium,
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        placeholder: (context, url) => Container(
                                          width: MediaQuery.of(context).size.width * 0.35,
                                          height: MediaQuery.of(context).size.width * 0.25,
                                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                          child: const Center(child: CircularProgressIndicator()),
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          width: MediaQuery.of(context).size.width * 0.35,
                                          height: MediaQuery.of(context).size.width * 0.25,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.broken_image, size: 40),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                photo.photographer,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                photo.alt,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                size: 16,
                                                color: Colors.amber,
                                              ),
                                              Text(
                                                " ${(4.5 + (i * 0.1)).toStringAsFixed(1)}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "• ${120 + (i * 50)}+ reviews",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: Colors.grey,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.1),
                                          ),
                                          child: Icon(
                                            Icons.bookmark_border,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      else
                        const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Travel inspiration
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: AnimatedBuilder(
            animation: widget.containerController,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.scaleAnimations[3].value,
                child: Opacity(
                  opacity: widget.fadeAnimations[3].value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Travel Inspiration',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      if (!isLoading && photos.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.7),
                                Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.7),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Personalized Travel Guides",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Discover destinations tailored to your preferences",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                          ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 10),
                                      ),
                                      child: const Text("Explore Now"),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: photos.last.src.medium,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                      child: const Center(child: CircularProgressIndicator()),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.broken_image, size: 40),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceVariant
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child:
                              const Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 24),

        // Short travel videos
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: AnimatedBuilder(
            animation: widget.containerController,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.scaleAnimations[0].value,
                child: Opacity(
                  opacity: widget.fadeAnimations[0].value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Short Travel Videos',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      if (!isLoading && _travelShorts.isNotEmpty)
                        SizedBox(
                          // Increase height to properly fit all content
                          height: MediaQuery.of(context).size.width * 0.75,
                          child: PageView.builder(
                            controller: _videoPageController,
                            // Set itemCount to null for unlimited/infinite items
                            itemCount: null,
                            itemBuilder: (context, index) {
                              // Get the actual video index using modulo
                              final actualIndex = _getActualVideoIndex(index);
                              if (actualIndex >= _travelShorts.length) {
                                return const SizedBox.shrink();
                              }
                              final video = _travelShorts[actualIndex];
                              
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: VideoCard(
                                  video: video,
                                  onTap: () {
                                    // Handle video tap
                                    Navigator.pushNamed(
                                      context,
                                      '/video',
                                      arguments: video,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        )
                      else
                        Container(
                          height: MediaQuery.of(context).size.width * 0.6,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceVariant
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child:
                              const Center(child: CircularProgressIndicator()),
                        ),
                      // Video page indicator dots
                      if (!isLoading && _travelShorts.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                List.generate(_travelShorts.length, (index) {
                              // Map the current infinite page to the visible page indicator 
                              final currentVisibleIndex = _getActualVideoIndex(_currentVideoPage);
                              
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index == currentVisibleIndex
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.3),
                                ),
                              );
                            }),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 24),

        // Packages section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: AnimatedBuilder(
            animation: widget.containerController,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.scaleAnimations[4].value,
                child: Opacity(
                  opacity: widget.fadeAnimations[4].value,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Packages for You',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (!isLoading && photos.isNotEmpty)
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 3,
                            itemBuilder: (context, i) {
                              final photo = photos[i];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(containerPadding),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                                  border: Border.all(
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.08)),
                                  color: Theme.of(context).colorScheme.surface,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedNetworkImage(
                                        imageUrl: photo.src.medium,
                                        fit: BoxFit.cover,
                                        width: MediaQuery.of(context).size.width * 0.35,
                                        height: MediaQuery.of(context).size.width * 0.25,
                                        placeholder: (context, url) => Container(
                                          width: MediaQuery.of(context).size.width * 0.35,
                                          height: MediaQuery.of(context).size.width * 0.25,
                                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                          child: const Center(child: CircularProgressIndicator()),
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          width: MediaQuery.of(context).size.width * 0.35,
                                          height: MediaQuery.of(context).size.width * 0.25,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.broken_image, size: 40),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Planned Trip: ${photo.alt}',
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Dates: ${_formatDateRange(DateTime.now().add(Duration(days: i * 5)), DateTime.now().add(Duration(days: i * 5 + 3)))}',
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Join your buddies for this trip!',
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: Theme.of(context).colorScheme.primary,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        else
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}
