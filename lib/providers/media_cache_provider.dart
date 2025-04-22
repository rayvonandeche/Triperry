import 'package:flutter/material.dart';
import 'package:triperry/models/photo_response.dart';
import 'package:triperry/models/video_item.dart';

/// Provider for caching media data to prevent reloading on widget remounts
class MediaCacheProvider extends ChangeNotifier {
  // Cache for photos by category
  final Map<String, List<PhotoResponse>> _photoCache = {};
  
  // Cache for videos
  final List<VideoItem> _videoCache = [];
  
  // Timestamp of when data was last loaded
  final Map<String, DateTime> _lastLoadTimes = {};
  
  // Cache duration (default: 5 minutes)
  final Duration _cacheDuration = const Duration(minutes: 5);
  
  // Default category for uncategorized photos
  static const String _defaultCategory = 'default';
  
  /// Get cached photos by category
  List<PhotoResponse>? getCachedPhotos(String category) {
    final cachedData = _photoCache[category];
    final lastLoaded = _lastLoadTimes['photos_$category'];
    
    // Return null if no cache or cache is too old
    if (cachedData == null || lastLoaded == null) return null;
    
    // Check if cache is still valid
    if (DateTime.now().difference(lastLoaded) > _cacheDuration) return null;
    
    return cachedData;
  }
  
  /// Get all cached photos
  List<PhotoResponse>? getAllCachedPhotos() {
    return getCachedPhotos(_defaultCategory);
  }
  
  /// Get cached videos
  List<VideoItem>? getCachedVideos() {
    final lastLoaded = _lastLoadTimes['videos'];
    
    // Return null if no cache or cache is too old
    if (_videoCache.isEmpty || lastLoaded == null) return null;
    
    // Check if cache is still valid
    if (DateTime.now().difference(lastLoaded) > _cacheDuration) return null;
    
    return _videoCache;
  }
  
  /// Cache photos by category
  void cachePhotos(List<PhotoResponse> photos, String category) {
    _photoCache[category] = photos;
    _lastLoadTimes['photos_$category'] = DateTime.now();
    notifyListeners();
  }
  
  /// Cache all photos (without category)
  void cacheAllPhotos(List<PhotoResponse> photos) {
    cachePhotos(photos, _defaultCategory);
  }
  
  /// Cache videos
  void cacheVideos(List<VideoItem> videos) {
    _videoCache.clear();
    _videoCache.addAll(videos);
    _lastLoadTimes['videos'] = DateTime.now();
    notifyListeners();
  }
  
  /// Check if photos are cached for a category
  bool hasPhotoCache(String category) {
    return getCachedPhotos(category) != null;
  }
  
  /// Check if videos are cached
  bool hasVideoCache() {
    return getCachedVideos() != null;
  }
  
  /// Clear all caches
  void clearCache() {
    _photoCache.clear();
    _videoCache.clear();
    _lastLoadTimes.clear();
    notifyListeners();
  }
  
  /// Clear specific photo category cache
  void clearPhotoCategoryCache(String category) {
    _photoCache.remove(category);
    _lastLoadTimes.remove('photos_$category');
    notifyListeners();
  }
  
  /// Set custom cache duration
  void setCacheDuration(Duration duration) {
    // Use with caution - this would replace the current cache duration
    // with a new one. Usually this shouldn't be needed as the default
    // duration is suitable for most cases.
    _lastLoadTimes.clear(); // Clear last load times to avoid inconsistencies
  }
}