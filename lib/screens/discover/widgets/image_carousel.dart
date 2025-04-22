import 'dart:async';
import 'package:triperry/models/photo_response.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageCarousel extends StatefulWidget {
  final List<PhotoResponse> photos;
  final double height;
  final bool autoScroll;
  final Duration autoScrollDuration;

  const ImageCarousel({
    Key? key,
    required this.photos,
    this.height = 250,
    this.autoScroll = true,
    this.autoScrollDuration = const Duration(seconds: 5),
  }) : super(key: key);

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoScrollTimer;
  // Starting page for infinite scrolling - a large number
  static const int _initialPage = 1000;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.9,
      initialPage: _initialPage,
    );
    _pageController.addListener(_pageListener);
    
    // Update current page to match initial page
    _currentPage = _initialPage;
    
    // Initialize auto-scroll timer if enabled
    if (widget.autoScroll && widget.photos.length > 1) {
      _startAutoScroll();
    }
  }
  
  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(widget.autoScrollDuration, (timer) {
      if (_pageController.hasClients) {
        final nextPage = _currentPage + 1;
        _pageController.animateToPage(
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
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    super.dispose();
  }
  
  @override
  void didUpdateWidget(ImageCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Handle changes in autoScroll property or photos length
    if (oldWidget.autoScroll != widget.autoScroll ||
        oldWidget.photos.length != widget.photos.length) {
      if (widget.autoScroll && widget.photos.length > 1) {
        _startAutoScroll();
      } else {
        _autoScrollTimer?.cancel();
      }
    }
  }

  void _pageListener() {
    int page = _pageController.page!.round();
    if (_currentPage != page && mounted) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  // Get the actual photo index from infinite scrolling index
  int _getActualIndex(int index) {
    return index % widget.photos.length;
  }
  
  // Get item count - null means unlimited items
  int? _getItemCount() {
    // If no photos, return 0
    if (widget.photos.isEmpty) {
      return 0;
    }
    // Return null for unlimited/infinite items
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.photos.isEmpty) {
      return Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _getItemCount(),
            itemBuilder: (context, index) {
              // Get the actual photo index using modulo
              final actualIndex = _getActualIndex(index);
              
              return AnimatedPadding(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: _currentPage == index ? 0 : 16,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: widget.photos[actualIndex].src.large,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Theme.of(context).colorScheme.surfaceVariant,
                              child: const Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: widget.height,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, size: 60),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
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
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.photos[actualIndex].photographer,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.photos[actualIndex].alt,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
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
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.photos.length, (index) {
            // Map the current infinite page to the visible page indicator
            final currentVisibleIndex = _getActualIndex(_currentPage);
            
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentVisibleIndex == index
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
            );
          }),
        ),
      ],
    );
  }
}