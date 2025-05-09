import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:triperry/models/photo_response.dart';
import 'package:triperry/models/video_item.dart';
import 'package:triperry/screens/discover/widgets/featured_carousel.dart';
import 'package:triperry/screens/discover/widgets/video_card.dart';
import 'package:triperry/screens/discover/widgets/category_details.dart';
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

class _DiscoverPageState extends State<DiscoverPage> with TickerProviderStateMixin {
  List<PhotoResponse> photos = [];
  bool isLoading = true;
  int _selectedCategoryIndex = 0;
  int _currentVideoPage = 0;
  // Updated categories list to include "Featured"
  final List<String> _categories = [
    "Featured",
    "Activities",
    "Accommodation",
    "Transport",
    "Packages",
  ];

  // Travel data organization
  Map<String, List<PhotoResponse>> _categorizedPhotos = {};

  // Videos for short videos section
  List<VideoItem> _travelShorts = [];
  static const int _initialVideoPage = 1000;
  late final PageController _videoPageController;
  Timer? _autoScrollTimer;
  late AnimationController _containerController;
  int _selectedTabIndex = 0; // Track the selected tab index

  @override
  void initState() {
    super.initState();
    _videoPageController = PageController(initialPage: _initialVideoPage);
    
    // Check cache before loading data
    _loadCachedDataOrFetch();
    
    _startVideoAutoScroll();
    _videoPageController.addListener(_videoPageListener);
    _currentVideoPage = _initialVideoPage;
    _containerController = widget.containerController;
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
    
    // Organize photos by category including Kenyan-specific categories
    _categorizedPhotos = {
      "Featured": photos,
      "Activities": photos.where((p) => 
          p.alt.toLowerCase().contains("safari") || 
          p.alt.toLowerCase().contains("adventure") ||
          p.alt.toLowerCase().contains("explore")).toList(),
      "Accommodation": _buildAccommodationItems(photos),
      "Transport": _buildTransportItems(photos),
      "Packages": photos.where((p) => 
          p.alt.toLowerCase().contains("package") || 
          p.alt.toLowerCase().contains("tour") ||
          p.alt.toLowerCase().contains("getaway") ||
          p.alt.toLowerCase().contains("experience")).toList(),
    };
    
    // Ensure each category has at least some photos
    for (final category in _categories) {
      if (_categorizedPhotos[category] == null || _categorizedPhotos[category]!.isEmpty) {
        _categorizedPhotos[category] = photos.take(2).toList();
      }
    }
  }
  
  // New specialized functions for improved category data
  List<PhotoResponse> _buildAccommodationItems(List<PhotoResponse> basedPhotos) {
    // Add specialized metadata for accommodation items
    final accommodationTypes = ["Hotel", "Resort", "Apartment", "Airbnb", "Lodge", "Villa"];
    final accommodationAmenities = [
      ["Swimming Pool", "Wi-Fi", "Room Service", "Gym", "Restaurant"],
      ["Beachfront", "Breakfast Included", "Bar", "Spa", "Air Conditioning"],
      ["Kitchen", "Washing Machine", "Private Parking", "Balcony", "Wi-Fi"],
      ["Entire Home", "Self Check-in", "Free Cancellation", "Wi-Fi", "Kitchen"],
      ["Wildlife View", "All-Inclusive", "Safari Tours", "Restaurant", "Pool"],
      ["Private Pool", "Ocean View", "Chef Service", "Garden", "Beach Access"],
    ];
    
    return basedPhotos
        .where((p) => 
            p.alt.toLowerCase().contains("hotel") || 
            p.alt.toLowerCase().contains("lodge") ||
            p.alt.toLowerCase().contains("resort"))
        .map((photo) {
          // Clone the photo but add accommodation-specific data
          // We need to do this in a production app, but for demo it's fine to reuse the same photos
          final typeIndex = photo.id % accommodationTypes.length;
          final amenities = accommodationAmenities[photo.id % accommodationAmenities.length];
          photo.additionalInfo = {
            "type": accommodationTypes[typeIndex],
            "amenities": amenities,
            "rating": (4.0 + ((photo.id * 7) % 10) / 10).toStringAsFixed(1),
            "reviewCount": 50 + (photo.id * 12),
            "pricePerNight": 5000 + (photo.id * 1500),
            "availableRooms": 1 + (photo.id % 5),
            "distanceFromCenter": (0.5 + (photo.id % 5) * 0.3).toStringAsFixed(1)
          };
          return photo;
        })
        .toList();
  }

  List<PhotoResponse> _buildTransportItems(List<PhotoResponse> basedPhotos) {
    // Add specialized metadata for transport items
    final transportTypes = ["Flight", "Car Rental", "Safari Van", "Matatu", "Tour Bus", "Boat"];
    final transportFeatures = [
      ["Direct", "Wi-Fi Onboard", "Meals", "Entertainment", "Flexible Dates"],
      ["Unlimited Mileage", "Insurance", "GPS", "Child Seat", "24/7 Support"],
      ["Experienced Driver", "Game Drive", "Roof Hatch", "Comfortable Seats", "Air Conditioning"],
      ["Local Experience", "Affordable", "Frequent Routes", "Urban Transport", "Cultural"],
      ["Guided Tour", "Air Conditioning", "Comfortable Seats", "Wi-Fi", "Water Provided"],
      ["Sunset Cruise", "Snorkeling Gear", "Refreshments", "Life Jackets", "Expert Captain"],
    ];
    
    return basedPhotos
        .where((p) => 
            p.alt.toLowerCase().contains("flight") || 
            p.alt.toLowerCase().contains("safari van") ||
            p.alt.toLowerCase().contains("matatu") ||
            p.alt.toLowerCase().contains("transport"))
        .map((photo) {
          final typeIndex = photo.id % transportTypes.length;
          final features = transportFeatures[photo.id % transportFeatures.length];
          photo.additionalInfo = {
            "type": transportTypes[typeIndex],
            "features": features,
            "rating": (4.0 + ((photo.id * 13) % 10) / 10).toStringAsFixed(1),
            "reviewCount": 35 + (photo.id * 15),
            "price": 3000 + (photo.id * 2500),
            "duration": "${1 + (photo.id % 8)}h ${(photo.id * 15) % 60}m",
            "departsFrom": ["JKIA", "Wilson Airport", "CBD", "Karen", "Westlands"][photo.id % 5]
          };
          return photo;
        })
        .toList();
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
          title: "Maasai Mara Wildebeest Migration",
          description:
              "Experience the incredible Great Migration across the Mara River in Kenya",
          url: "https://example.com/video1",
          thumbnailUrl: "https://images.unsplash.com/photo-1516426122078-c23e76319801",
          uploadedBy: "Kenya Safari Adventures",
          duration: 45,
          views: 156000,
          uploadDate: DateTime.now().subtract(const Duration(days: 5)),
          tags: ["Kenya", "Maasai Mara", "Wildlife"],
        ),
        VideoItem(
          id: 2,
          title: "Diani Beach Paradise",
          description: "Explore the pristine white sand beaches of Diani along Kenya's coast",
          url: "https://example.com/video2",
          thumbnailUrl: "https://images.unsplash.com/photo-1590523741831-ab7e8b8f9c7f",
          uploadedBy: "Coastal Kenya Explorer",
          duration: 62,
          views: 235000,
          uploadDate: DateTime.now().subtract(const Duration(days: 8)),
          tags: ["Kenya", "Diani", "Beach"],
        ),
        VideoItem(
          id: 3,
          title: "Nairobi City Tour",
          description: "Tour through Kenya's vibrant capital city with its unique urban wildlife",
          url: "https://example.com/video3",
          thumbnailUrl: "https://images.unsplash.com/photo-1611348524140-53c9a25263d6",
          uploadedBy: "Urban Kenya Adventures",
          duration: 58,
          views: 198000,
          uploadDate: DateTime.now().subtract(const Duration(days: 3)),
          tags: ["Nairobi", "Kenya", "City"],
        ),
        VideoItem(
          id: 4,
          title: "Mount Kenya Climbing Guide",
          description: "Tips for climbing Africa's second-highest mountain in central Kenya",
          url: "https://example.com/video4",
          thumbnailUrl: "https://images.unsplash.com/photo-1573998615946-de94d29fbc57",
          uploadedBy: "Kenya Mountain Trekkers",
          duration: 72,
          views: 127000,
          uploadDate: DateTime.now().subtract(const Duration(days: 12)),
          tags: ["Kenya", "Mount Kenya", "Hiking"],
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
          url: "https://images.unsplash.com/photo-1516426122078-c23e76319801",
          photographer: "Kenya Wildlife Service",
          photographerUrl: "https://unsplash.com/",
          photographerId: 123,
          avgColor: "#26547C",
          src: PhotoSrc(
              original: "https://images.unsplash.com/photo-1516426122078-c23e76319801",
              large2x: "https://images.unsplash.com/photo-1516426122078-c23e76319801",
              large: "https://images.unsplash.com/photo-1516426122078-c23e76319801",
              medium: "https://images.unsplash.com/photo-1516426122078-c23e76319801",
              small: "https://images.unsplash.com/photo-1516426122078-c23e76319801",
              portrait: "https://images.unsplash.com/photo-1516426122078-c23e76319801",
              landscape: "https://images.unsplash.com/photo-1516426122078-c23e76319801",
              tiny: "https://images.unsplash.com/photo-1516426122078-c23e76319801"),
          alt: "Maasai Mara Safari Experience",
        ),
        PhotoResponse(
          id: 2,
          width: 1200,
          height: 800,
          url: "https://images.unsplash.com/photo-1590523741831-ab7e8b8f9c7f",
          photographer: "Coastal Ventures",
          photographerUrl: "https://unsplash.com/",
          photographerId: 456,
          avgColor: "#58A4B0",
          src: PhotoSrc(
              original: "https://images.unsplash.com/photo-1590523741831-ab7e8b8f9c7f",
              large2x: "https://images.unsplash.com/photo-1590523741831-ab7e8b8f9c7f",
              large: "https://images.unsplash.com/photo-1590523741831-ab7e8b8f9c7f",
              medium: "https://images.unsplash.com/photo-1590523741831-ab7e8b8f9c7f",
              small: "https://images.unsplash.com/photo-1590523741831-ab7e8b8f9c7f",
              portrait: "https://images.unsplash.com/photo-1590523741831-ab7e8b8f9c7f",
              landscape: "https://images.unsplash.com/photo-1590523741831-ab7e8b8f9c7f",
              tiny: "https://images.unsplash.com/photo-1590523741831-ab7e8b8f9c7f"),
          alt: "Diani Beach Resort Getaway",
        ),
        PhotoResponse(
          id: 3,
          width: 1200,
          height: 800,
          url: "https://images.unsplash.com/photo-1611348524140-53c9a25263d6",
          photographer: "Nairobi City Tours",
          photographerUrl: "https://unsplash.com/",
          photographerId: 789,
          avgColor: "#D8973C",
          src: PhotoSrc(
              original: "https://images.unsplash.com/photo-1611348524140-53c9a25263d6",
              large2x: "https://images.unsplash.com/photo-1611348524140-53c9a25263d6",
              large: "https://images.unsplash.com/photo-1611348524140-53c9a25263d6",
              medium: "https://images.unsplash.com/photo-1611348524140-53c9a25263d6",
              small: "https://images.unsplash.com/photo-1611348524140-53c9a25263d6",
              portrait: "https://images.unsplash.com/photo-1611348524140-53c9a25263d6",
              landscape: "https://images.unsplash.com/photo-1611348524140-53c9a25263d6",
              tiny: "https://images.unsplash.com/photo-1611348524140-53c9a25263d6"),
          alt: "Nairobi City Skyline View",
        ),
        PhotoResponse(
          id: 4,
          width: 1200,
          height: 800,
          url: "https://images.unsplash.com/photo-1573998615946-de94d29fbc57",
          photographer: "Mountain Trekkers",
          photographerUrl: "https://unsplash.com/",
          photographerId: 101,
          avgColor: "#64A6BD",
          src: PhotoSrc(
              original: "https://images.unsplash.com/photo-1573998615946-de94d29fbc57",
              large2x: "https://images.unsplash.com/photo-1573998615946-de94d29fbc57",
              large: "https://images.unsplash.com/photo-1573998615946-de94d29fbc57",
              medium: "https://images.unsplash.com/photo-1573998615946-de94d29fbc57",
              small: "https://images.unsplash.com/photo-1573998615946-de94d29fbc57",
              portrait: "https://images.unsplash.com/photo-1573998615946-de94d29fbc57",
              landscape: "https://images.unsplash.com/photo-1573998615946-de94d29fbc57",
              tiny: "https://images.unsplash.com/photo-1573998615946-de94d29fbc57"),
          alt: "Mount Kenya Climbing Adventure",
        ),
        // Additional beach destinations
        PhotoResponse(
          id: 5,
          width: 1200,
          height: 800,
          url: "https://images.unsplash.com/photo-1506953823976-52e1fdc0149a",
          photographer: "Lamu Explorer",
          photographerUrl: "https://unsplash.com/",
          photographerId: 202,
          avgColor: "#7DCFB6",
          src: PhotoSrc(
              original: "https://images.unsplash.com/photo-1506953823976-52e1fdc0149a",
              large2x: "https://images.unsplash.com/photo-1506953823976-52e1fdc0149a",
              large: "https://images.unsplash.com/photo-1506953823976-52e1fdc0149a",
              medium: "https://images.unsplash.com/photo-1506953823976-52e1fdc0149a",
              small: "https://images.unsplash.com/photo-1506953823976-52e1fdc0149a",
              portrait: "https://images.unsplash.com/photo-1506953823976-52e1fdc0149a",
              landscape: "https://images.unsplash.com/photo-1506953823976-52e1fdc0149a",
              tiny: "https://images.unsplash.com/photo-1506953823976-52e1fdc0149a"),
          alt: "Lamu Island Cultural Heritage",
        ),
        PhotoResponse(
          id: 6,
          width: 1200,
          height: 800,
          url: "https://images.unsplash.com/photo-1608369511685-628aa2a1df4e",
          photographer: "Rift Valley Safaris",
          photographerUrl: "https://unsplash.com/",
          photographerId: 303,
          avgColor: "#3D5A80",
          src: PhotoSrc(
              original: "https://images.unsplash.com/photo-1608369511685-628aa2a1df4e",
              large2x: "https://images.unsplash.com/photo-1608369511685-628aa2a1df4e",
              large: "https://images.unsplash.com/photo-1608369511685-628aa2a1df4e",
              medium: "https://images.unsplash.com/photo-1608369511685-628aa2a1df4e",
              small: "https://images.unsplash.com/photo-1608369511685-628aa2a1df4e",
              portrait: "https://images.unsplash.com/photo-1608369511685-628aa2a1df4e",
              landscape: "https://images.unsplash.com/photo-1608369511685-628aa2a1df4e",
              tiny: "https://images.unsplash.com/photo-1608369511685-628aa2a1df4e"),
          alt: "Hell's Gate National Park Adventure",
        ),
        PhotoResponse(
          id: 7,
          width: 1200,
          height: 800,
          url: "https://images.unsplash.com/photo-1609910696986-7869c7a15a34",
          photographer: "Lake Victoria Tours",
          photographerUrl: "https://unsplash.com/",
          photographerId: 404,
          avgColor: "#FFA07A",
          src: PhotoSrc(
              original: "https://images.unsplash.com/photo-1609910696986-7869c7a15a34",
              large2x: "https://images.unsplash.com/photo-1609910696986-7869c7a15a34",
              large: "https://images.unsplash.com/photo-1609910696986-7869c7a15a34",
              medium: "https://images.unsplash.com/photo-1609910696986-7869c7a15a34",
              small: "https://images.unsplash.com/photo-1609910696986-7869c7a15a34",
              portrait: "https://images.unsplash.com/photo-1609910696986-7869c7a15a34",
              landscape: "https://images.unsplash.com/photo-1609910696986-7869c7a15a34",
              tiny: "https://images.unsplash.com/photo-1609910696986-7869c7a15a34"),
          alt: "Kisumu Lake Victoria Experience",
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

  // Navigate to category detail page
  void _navigateToCategoryDetail(String category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CategoryDetailPage(
          category: category,
          photos: _categorizedPhotos[category] ?? [],
        ),
      ),
    );
  }

  // Method to build complete page content based on selected tab
  Widget _buildTabPageContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Build different page layouts based on selected tab
    switch (_selectedTabIndex) {
      case 0:
        return _buildFeaturedPageContent();
      case 1:
        return _buildActivitiesPageContent();
      case 2:
        return _buildAccommodationPageContent();
      case 3:
        return _buildTransportPageContent();
      case 4:
        return _buildPackagesPageContent();
      default:
        return const Center(child: Text("No content available"));
    }
  }

  // Featured tab content
  Widget _buildFeaturedPageContent() {
    final categoryName = _categories[0];
    final items = _categorizedPhotos[categoryName] ?? [];
    
    if (items.isEmpty) {
      return const Center(child: Text("No featured items available"));
    }
    
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Trending experiences section
        _buildSection(
          context: context, 
          title: 'Trending Experiences',
          index: 2,
          contentBuilder: (context) => SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length > 5 ? 5 : items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () => _navigateToItemDetailPage(item, categoryName),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    width: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: item.src.large,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.8),
                                ],
                                stops: const [0.6, 1.0],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 12,
                            right: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.alt,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "By ${item.photographer}",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.star, color: Colors.white, size: 12),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${4.0 + (item.id % 10) / 10}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
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
        ),

        const SizedBox(height: 24),
        
        // Popular destinations
        _buildSection(
          context: context,
          title: 'Popular Destinations',
          index: 3,
          contentBuilder: (context) => GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: items.length > 4 ? 4 : items.length,
            itemBuilder: (context, index) {
              final item = items[index + 1 >= items.length ? 0 : index + 1];
              return GestureDetector(
                onTap: () => _navigateToItemDetailPage(item, categoryName),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: item.src.large,
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
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 12,
                        right: 12,
                        child: Text(
                          item.alt,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
        
        // Travel videos
        _buildSection(
          context: context,
          title: 'Explore Kenya',
          index: 4,
          contentBuilder: (context) => _travelShorts.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                  height: 220,
                  child: PageView.builder(
                    controller: _videoPageController,
                    itemBuilder: (context, index) {
                      final actualIndex = _getActualVideoIndex(index);
                      final video = _travelShorts[actualIndex];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: VideoCard(
                          video: video,
                          onTap: () {
                            // handle video tap if needed
                          },
                        ),
                      );
                    },
                  ),
                ),
        ),
        
        const SizedBox(height: 24),

        // Recommendation section
        _buildSection(
          context: context,
          title: 'Recommended For You',
          index: 5,
          contentBuilder: (context) => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length > 3 ? 3 : items.length,
            itemBuilder: (context, index) {
              final item = items[items.length - index - 1];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: InkWell(
                  onTap: () => _navigateToItemDetailPage(item, categoryName),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: item.src.medium,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.alt,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text("${4.0 + (item.id % 10) / 10}"),
                                  const SizedBox(width: 8),
                                  Text("(${50 + (item.id * 5)} reviews)"),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "KES ${12000 + (item.id * 500)}",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
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
            },
          ),
        ),

        const SizedBox(height: 80), // Bottom padding
      ],
    );
  }

  // Activities tab content
  Widget _buildActivitiesPageContent() {
    final categoryName = _categories[1];
    final items = _categorizedPhotos[categoryName] ?? [];
    
    if (items.isEmpty) {
      return const Center(child: Text("No activities available"));
    }
    
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Featured activities
        _buildSection(
          context: context,
          title: 'Featured Activities',
          index: 2,
          contentBuilder: (context) => SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () => _navigateToItemDetailPage(item, categoryName),
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: item.src.large,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.8),
                                ],
                                stops: const [0.6, 1.0],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.alt,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade700,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "Adventure",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
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
              },
            ),
          ),
        ),

        const SizedBox(height: 24),
        
        // Activity Categories
        _buildSection(
          context: context,
          title: 'Activity Categories',
          index: 3,
          contentBuilder: (context) => SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildActivityCategory(context, 'Safari', Icons.forest, Colors.amber.shade800),
                _buildActivityCategory(context, 'Hiking', Icons.terrain, Colors.green.shade700),
                _buildActivityCategory(context, 'Beach', Icons.beach_access, Colors.blue.shade600),
                _buildActivityCategory(context, 'Cultural', Icons.museum, Colors.purple.shade600),
                _buildActivityCategory(context, 'City Tours', Icons.location_city, Colors.teal.shade700),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),
        
        // All Activities list
        _buildSection(
          context: context,
          title: 'All Activities',
          index: 4,
          contentBuilder: (context) => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: InkWell(
                  onTap: () => _navigateToItemDetailPage(item, categoryName),
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: CachedNetworkImage(
                          imageUrl: item.src.large,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.alt,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text("By ${item.photographer}"),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.schedule, size: 16),
                                const SizedBox(width: 4),
                                Text("Duration: ${(item.id % 8) + 1} hours"),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 16),
                                    const SizedBox(width: 4),
                                    Text("${4.0 + (item.id % 10) / 10} (${50 + (item.id * 5)})"),
                                  ],
                                ),
                                Text(
                                  "KES ${9500 + (item.id * 500)}",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
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
              );
            },
          ),
        ),
        
        const SizedBox(height: 80), // Bottom padding
      ],
    );
  }

  Widget _buildActivityCategory(BuildContext context, String title, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Accommodation tab content
  Widget _buildAccommodationPageContent() {
    final categoryName = _categories[2];
    final items = _categorizedPhotos[categoryName] ?? [];
    
    if (items.isEmpty) {
      return const Center(child: Text("No accommodation available"));
    }
    
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Popular accommodations carousel
        _buildSection(
          context: context,
          title: 'Top-rated Accommodations',
          index: 2,
          contentBuilder: (context) => SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final additionalInfo = item.additionalInfo ?? {};
                final type = additionalInfo["type"] as String? ?? "Hotel";
                final rating = additionalInfo["rating"] as String? ?? "4.5";
                final price = additionalInfo["pricePerNight"] as int? ?? 5000;
                
                return GestureDetector(
                  onTap: () => _navigateToItemDetailPage(item, categoryName),
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: item.src.large,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.8),
                                ],
                                stops: const [0.6, 1.0],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                type,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 12,
                            right: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.alt,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      rating,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "KES $price / night",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
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
              },
            ),
          ),
        ),

        const SizedBox(height: 24),
        
        // Accommodation types
        _buildSection(
          context: context,
          title: 'Browse by Property Type',
          index: 3,
          contentBuilder: (context) => SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildAccommodationType(context, 'Hotels', Icons.hotel, Colors.blue.shade700),
                _buildAccommodationType(context, 'Resorts', Icons.beach_access, Colors.orange.shade700),
                _buildAccommodationType(context, 'Villas', Icons.house, Colors.green.shade700),
                _buildAccommodationType(context, 'Apartments', Icons.apartment, Colors.purple.shade700),
                _buildAccommodationType(context, 'Safari Lodges', Icons.forest, Colors.brown.shade700),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),
        
        // All accommodations list
        _buildSection(
          context: context,
          title: 'All Accommodations',
          index: 4,
          contentBuilder: (context) => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final additionalInfo = item.additionalInfo ?? {};
              final type = additionalInfo["type"] as String? ?? "Hotel";
              final rating = additionalInfo["rating"] as String? ?? "4.5";
              final reviewCount = additionalInfo["reviewCount"] as int? ?? 120;
              final price = additionalInfo["pricePerNight"] as int? ?? 5000;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: InkWell(
                  onTap: () => _navigateToItemDetailPage(item, categoryName),
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: CachedNetworkImage(
                              imageUrl: item.src.large,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                type,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.alt,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text("By ${item.photographer}"),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text("$rating ($reviewCount reviews)"),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.location_on, size: 16),
                                    const SizedBox(width: 4),
                                    Text(additionalInfo["distanceFromCenter"] != null
                                        ? "${additionalInfo["distanceFromCenter"]} km from center"
                                        : "Near city center"),
                                  ],
                                ),
                                Text(
                                  "KES $price / night",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
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
              );
            },
          ),
        ),
        
        const SizedBox(height: 80), // Bottom padding
      ],
    );
  }

  Widget _buildAccommodationType(BuildContext context, String title, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Transport tab content
  Widget _buildTransportPageContent() {
    final categoryName = _categories[3];
    final items = _categorizedPhotos[categoryName] ?? [];
    
    if (items.isEmpty) {
      return const Center(child: Text("No transport options available"));
    }
    
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Transport search box
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Find Transport",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "From",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "To",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Search"),
              ),
            ],
          ),
        ),

        // Transport categories
        _buildSection(
          context: context,
          title: 'Transport Options',
          index: 2,
          contentBuilder: (context) => SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildTransportOption(context, 'Flights', Icons.flight, Colors.blue.shade700),
                _buildTransportOption(context, 'Cars', Icons.directions_car, Colors.green.shade700),
                _buildTransportOption(context, 'Safari Vans', Icons.airport_shuttle, Colors.amber.shade800),
                _buildTransportOption(context, 'Matatus', Icons.directions_bus, Colors.purple.shade700),
                _buildTransportOption(context, 'Boats', Icons.directions_boat, Colors.cyan.shade700),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),
        
        // Available transport list
        _buildSection(
          context: context,
          title: 'Available Transport',
          index: 3,
          contentBuilder: (context) => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final additionalInfo = item.additionalInfo ?? {};
              final type = additionalInfo["type"] as String? ?? "Car Rental";
              final features = additionalInfo["features"] as List<dynamic>? ?? [];
              final rating = additionalInfo["rating"] as String? ?? "4.5";
              final price = additionalInfo["price"] as int? ?? 5000;
              final departsFrom = additionalInfo["departsFrom"] as String? ?? "Nairobi";
              
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: InkWell(
                  onTap: () => _navigateToItemDetailPage(item, categoryName),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: item.src.medium,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8, 
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getTransportColor(type),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          type,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.star, color: Colors.amber, size: 16),
                                          const SizedBox(width: 4),
                                          Text(rating),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item.alt,
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on, 
                                        size: 16,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text("From: $departsFrom"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (features.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: features.take(3).map((feature) => Chip(
                              label: Text(
                                feature.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                              padding: EdgeInsets.zero,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            )).toList(),
                          ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "By ${item.photographer}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "KES $price",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 80), // Bottom padding
      ],
    );
  }

  Color _getTransportColor(String type) {
    switch (type.toLowerCase()) {
      case 'flight':
        return Colors.blue.shade700;
      case 'car rental':
        return Colors.green.shade700;
      case 'safari van':
        return Colors.amber.shade800;
      case 'matatu':
        return Colors.purple.shade700;
      case 'tour bus':
        return Colors.teal.shade700;
      case 'boat':
        return Colors.cyan.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  Widget _buildTransportOption(BuildContext context, String title, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Packages tab content
  Widget _buildPackagesPageContent() {
    final categoryName = _categories[4];
    final items = _categorizedPhotos[categoryName] ?? [];
    
    if (items.isEmpty) {
      return const Center(child: Text("No packages available"));
    }
    
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Special offers carousel
        _buildSection(
          context: context,
          title: 'Special Offers',
          index: 2,
          contentBuilder: (context) => SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length > 3 ? 3 : items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final discount = 15 + (index * 5);
                
                return GestureDetector(
                  onTap: () => _navigateToItemDetailPage(item, categoryName),
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: item.src.large,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.8),
                                ],
                                stops: const [0.6, 1.0],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "$discount% OFF",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 12,
                            right: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.alt,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "By ${item.photographer}",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "KES ${20000 + (item.id * 1000)}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
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
        ),

        const SizedBox(height: 24),
        
        // Package types
        _buildSection(
          context: context,
          title: 'Package Types',
          index: 3,
          contentBuilder: (context) => SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildPackageType(context, 'Safari', Icons.forest, Colors.amber.shade800),
                _buildPackageType(context, 'Beach', Icons.beach_access, Colors.blue.shade600),
                _buildPackageType(context, 'City Break', Icons.location_city, Colors.teal.shade700),
                _buildPackageType(context, 'Cultural', Icons.museum, Colors.purple.shade600),
                _buildPackageType(context, 'Adventure', Icons.terrain, Colors.green.shade700),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),
        
        // All packages list
        _buildSection(
          context: context,
          title: 'All Packages',
          index: 4,
          contentBuilder: (context) => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final price = 20000 + (item.id * 1000);
              final days = 3 + (item.id % 7);
              final nights = days - 1;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: InkWell(
                  onTap: () => _navigateToItemDetailPage(item, categoryName),
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: CachedNetworkImage(
                          imageUrl: item.src.large,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.alt,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text("By ${item.photographer}"),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 16),
                                const SizedBox(width: 4),
                                Text("$days days / $nights nights"),
                                const SizedBox(width: 16),
                                Icon(Icons.people, size: 16),
                                const SizedBox(width: 4),
                                Text("2-${4 + (item.id % 4)} people"),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.check_circle, size: 16, color: Colors.green),
                                const SizedBox(width: 4),
                                Text("Includes accommodation & transport"),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 16),
                                    const SizedBox(width: 4),
                            Text(
                              item.alt,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text("By ${item.photographer}"),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 16),
                                const SizedBox(width: 4),
                                Text("$days days / $nights nights"),
                                const SizedBox(width: 16),
                                Icon(Icons.people, size: 16),
                                const SizedBox(width: 4),
                                Text("2-${4 + (item.id % 4)} people"),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.check_circle, size: 16, color: Colors.green),
                                const SizedBox(width: 4),
                                Text("Includes accommodation & transport"),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 16),
                                    const SizedBox(width: 4),
                                    Text("${4.0 + ((item.id * 7) % 10) / 10} (${50 + (item.id * 12)})"),
                                  ],
                                ),
                                Text(
                                  "KES $price",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                          ]),
                    ],
                  ),
                ),
      ])));
            },
          ),
        ),
        
        const SizedBox(height: 80), // Bottom padding
      ],
    );
  }

  Widget _buildPackageType(BuildContext context, String title, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Unified smooth opacity gradient background
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).scaffoldBackgroundColor.withOpacity(0.97),
            Theme.of(context).scaffoldBackgroundColor.withOpacity(0.90),
            Theme.of(context).scaffoldBackgroundColor.withOpacity(0.80),
          ],
          stops: const [0.0, 0.3, 1.0],
        ),
      ),
      child: Column(
        children: [
          // Features section (this is the top-most section, potentially dynamic via _selectedCategoryIndex)
          _buildFeaturedSection(),

          // Tab bar for switching content below
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: SizedBox(
              height: 40, // Consistent height for the tab bar
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedTabIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20), // Pill-shaped tabs
                        border: isSelected 
                            ? Border.all(color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5), width: 1.5)
                            : null,
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            blurRadius: 5,
                            offset: const Offset(0,2),
                          )
                        ] : [],
                      ),
                      child: Center(
                        child: Text(
                          _categories[index],
                          style: TextStyle(
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Dynamic content based on selected tab - now uses the specific page content methods
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.1),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _buildTabPageContent(), // Use the new method for page-specific content
            ),
          ),
        ],
      ),
    );
  }

  // New method for categories row
  Widget _buildCategoriesRow() {
    return Padding(
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
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isSelected
                                ? [
                                    Theme.of(context).colorScheme.primary.withBlue(
                                        Theme.of(context).colorScheme.primary.blue + 10),
                                    Theme.of(context).colorScheme.primary,
                                  ]
                                : [
                                    Theme.of(context).colorScheme.surface.withOpacity(0.9),
                                    Theme.of(context).colorScheme.surface.withOpacity(0.75),
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white.withOpacity(0.2)
                                : Theme.of(context).dividerColor.withOpacity(0.2),
                            width: 0.8,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (isSelected 
                                  ? Theme.of(context).colorScheme.primary 
                                  : Colors.black).withOpacity(isSelected ? 0.2 : 0.05),
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
                                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
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
    );
  }

  // New method for featured section with dynamic height
  Widget _buildFeaturedSection() {
    final String categoryTitle = _categories[_selectedCategoryIndex];
    final bool isFullHeight = _selectedCategoryIndex == 0; // Full height only for "Featured"
    
    return _buildSection(
      context: context,
      title: categoryTitle,
      index: 1,
      showSeeAll: true,
      onSeeAllPressed: () => _navigateToCategoryDetail(categoryTitle),
      contentBuilder: (context) => !isLoading &&
            _categorizedPhotos[categoryTitle] != null
        ? FeaturedCarousel(
            photos: _categorizedPhotos[categoryTitle]!,
            height: isFullHeight 
                ? MediaQuery.of(context).size.width * 0.8
                : MediaQuery.of(context).size.width * 0.6,
            isFullHeight: isFullHeight,
            onItemTap: (photo) {
              _navigateToItemDetailPage(photo, categoryTitle);
            },
          )
        : Container(
            height: isFullHeight
                ? MediaQuery.of(context).size.width * 0.8
                : MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceVariant
                  .withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: CircularProgressIndicator()),
          ),
    );
  }

  // Helper method to navigate to the appropriate detail page based on category
  void _navigateToItemDetailPage(PhotoResponse photo, String category) {
    Widget detailPage;
    
    // Choose the appropriate detail page based on category
    switch (category.toLowerCase()) {
      case "accommodation":
        detailPage = AccommodationDetailPage(accommodation: photo);
        break;
      case "transport":
        detailPage = TransportDetailPage(transport: photo);
        break;
      case "activities":
        detailPage = ActivityDetailPage(activity: photo);
        break;
      default:
        // Use the generic detail page for other categories
        detailPage = ItemDetailPage(photo: photo, category: category);
    }
    
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => detailPage),
    );
  }

  // Updated section builder with onSeeAllPressed callback
  Widget _buildSection({
    required BuildContext context,
    required String title,
    required int index,
    required Widget Function(BuildContext) contentBuilder,
    bool showSeeAll = false,
    VoidCallback? onSeeAllPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: AnimatedBuilder(
        animation: widget.containerController,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.scaleAnimations[index % widget.scaleAnimations.length].value,
            child: Opacity(
              opacity: widget.fadeAnimations[index % widget.fadeAnimations.length].value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.titleLarge?.color?.withOpacity(0.9),
                              ),
                        ),
                        if (showSeeAll)
                          TextButton(
                            onPressed: onSeeAllPressed,
                            style: TextButton.styleFrom(
                              foregroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                                  width: 0.8,
                                ),
                              ),
                            ),
                            child: const Text('See All'),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  contentBuilder(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// New class for category detail page
class CategoryDetailPage extends StatelessWidget {
  final String category;
  final List<PhotoResponse> photos;

  const CategoryDetailPage({
    super.key,
    required this.category,
    required this.photos,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.97),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.90),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.80),
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: photos.isEmpty
            ? const Center(child: Text("No items available in this category"))
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ItemDetailPage(
                            photo: photo,
                            category: category,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.surface.withOpacity(0.8),
                            Theme.of(context).colorScheme.surface.withOpacity(0.6),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                            spreadRadius: 0.5,
                          ),
                        ],
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: photo.src.medium,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  photo.alt,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "By ${photo.photographer}",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: Colors.amber, size: 20),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${(4.0 + (index % 10) / 10).toStringAsFixed(1)}",
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "(${100 + (index * 11)} reviews)",
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton.icon(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.favorite_border,
                                        color: Theme.of(context).colorScheme.primary,
                                        size: 18,
                                      ),
                                      label: Text(
                                        "Save",
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
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
                  );
                },
              ),
      ),
    );
  }
}

// New class for item detail page
class ItemDetailPage extends StatelessWidget {
  final PhotoResponse photo;
  final String category;

  const ItemDetailPage({
    super.key,
    required this.photo,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                photo.alt,
                style: TextStyle(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 1),
                      blurRadius: 3.0,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: photo.src.large,
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay for better text visibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.7, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.97),
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.90),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "By ${photo.photographer}",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.primary.withBlue(
                                  Theme.of(context).colorScheme.primary.blue + 10),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                "4.8",
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Description",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _generateDetailDescription(category, photo.alt),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Features Section
                    Text(
                      "Features",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFeaturesList(context, category),
                    
                    const SizedBox(height: 24),
                    
                    // Price section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          width: 0.8,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Price",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                "KES ${12000 + (photo.id * 500)}",
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "per person",
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {},
                              child: const Text("Book Now"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Generate a detailed description based on category and title
  String _generateDetailDescription(String category, String title) {
    // Create appropriate descriptions based on category
    switch (category.toLowerCase()) {
      case "accommodation":
        return "Experience luxury and comfort at this beautiful accommodation in Kenya. "
               "Located in a prime area, this $title offers stunning views, exceptional "
               "service, and modern amenities for a memorable stay. Enjoy spacious rooms, "
               "fine dining options, and easy access to local attractions.";
      case "transport":
        return "Travel in comfort and style with our $title service. Our reliable "
               "transport options ensure you reach your destination safely and on time. "
               "Enjoy scenic routes across Kenya's beautiful landscapes with experienced "
               "drivers who know the terrain well.";
      case "activities":
        return "Embark on an unforgettable adventure with our $title experience. "
               "This popular activity showcases Kenya's natural beauty and cultural heritage, "
               "providing thrilling moments and stunning photo opportunities. Suitable for all "
               "experience levels with professional guides to ensure your safety.";
      case "packages":
        return "Our all-inclusive $title package offers the perfect combination of "
               "accommodation, transportation, and activities for an unforgettable Kenyan experience. "
               "Carefully curated to showcase the best of Kenya's landscapes, wildlife, and culture, "
               "with expert guides and comfortable accommodations throughout your journey.";
      default:
        return "Discover the beauty of Kenya with this amazing $title experience. "
               "Kenya offers diverse landscapes from savannah plains to mountain forests, "
               "coastal beaches to highland plateaus. Home to the Big Five and over 40 national parks and reserves, "
               "it's a perfect destination for nature lovers and adventure seekers alike.";
    }
  }
  
  // Build features list based on category
  Widget _buildFeaturesList(BuildContext context, String category) {
    List<Map<String, dynamic>> features = [];
    
    // Set features based on category
    switch (category.toLowerCase()) {
      case "accommodation":
        features = [
          {"icon": Icons.wifi, "title": "Free WiFi"},
          {"icon": Icons.pool, "title": "Swimming Pool"},
          {"icon": Icons.restaurant, "title": "Restaurant"},
          {"icon": Icons.local_parking, "title": "Free Parking"},
          {"icon": Icons.ac_unit, "title": "Air Conditioning"},
          {"icon": Icons.room_service, "title": "Room Service"},
        ];
        break;
      case "transport":
        features = [
          {"icon": Icons.airline_seat_recline_extra, "title": "Comfortable Seats"},
          {"icon": Icons.ac_unit, "title": "Air Conditioning"},
          {"icon": Icons.badge, "title": "Professional Driver"},
          {"icon": Icons.security, "title": "Safety Features"},
          {"icon": Icons.wifi, "title": "WiFi Available"},
          {"icon": Icons.luggage, "title": "Luggage Space"},
        ];
        break;
      case "activities":
        features = [
          {"icon": Icons.tour, "title": "Expert Guides"},
          {"icon": Icons.camera_alt, "title": "Photo Opportunities"},
          {"icon": Icons.safety_check, "title": "Safety Equipment"},
          {"icon": Icons.access_time_filled, "title": "Flexible Duration"},
          {"icon": Icons.people, "title": "Group Discounts"},
          {"icon": Icons.child_care, "title": "Family Friendly"},
        ];
        break;
      default:
        features = [
          {"icon": Icons.hotel, "title": "Quality Accommodation"},
          {"icon": Icons.airport_shuttle, "title": "Transport Included"},
          {"icon": Icons.restaurant_menu, "title": "Meals Included"},
          {"icon": Icons.tour, "title": "Guided Tours"},
          {"icon": Icons.location_on, "title": "Major Attractions"},
          {"icon": Icons.support_agent, "title": "24/7 Support"},
        ];
        break;
    }
    
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: features.map((feature) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                feature["icon"],
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(feature["title"]),
            ],
          ),
        );
      }).toList(),
    );
  }
}
