import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Checks if an image URL is valid and can be loaded.
/// Returns a Future<bool> indicating if the image is valid.
Future<bool> isImageUrlValid(String url) async {
  try {
    if (url.startsWith('http')) {
      // For network images, check using DefaultCacheManager
      final file = await DefaultCacheManager().getSingleFile(url);
      return file != null;
    } else if (url.startsWith('lib/assets/')) {
      // For legacy asset paths that start with lib/assets/
      // Convert to the proper asset path format
      final correctedPath = url.replaceFirst('lib/', '');
      try {
        await rootBundle.load(correctedPath);
        return true;
      } catch (e) {
        return false;
      }
    } else if (url.startsWith('assets/')) {
      // For asset paths that already follow the correct format
      try {
        await rootBundle.load(url);
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  } catch (e) {
    debugPrint('Error checking image URL: $e');
    return false;
  }
}

/// Try loading from a list of image URLs until one works.
/// Returns the first working URL, or a placeholder if none work.
Future<String> getFirstWorkingImageUrl(List<String> urls) async {
  for (final url in urls) {
    if (url.startsWith('lib/assets/images/')) {
      return url.replaceFirst('lib/', '');
    } else if (url.startsWith('assets/')) {
      return url;
    } else if (url.startsWith('http')) {
      return url;
    }
  }
  return 'assets/images/placeholder.jpeg';
}

/// A widget that displays an image with offline support.
///
/// This widget tries to load an image from a list of URLs (falling back to the next if one fails),
/// or falls back to a local asset if all network images fail.
class OfflineReadyImage extends StatelessWidget {
  /// Single image URL to display
  final String? imageUrl;
  
  /// List of image URLs to try (in order of preference)
  final List<String>? imageUrls;
  
  /// How the image should be inscribed into the space allocated during layout
  final BoxFit fit;
  
  /// Local asset path to use as fallback if all network images fail
  final String? fallbackAssetPath;
  
  /// Optional widget to display while loading
  final Widget? loadingWidget;
  
  /// Optional widget to display on error
  final Widget? errorWidget;
  
  /// Optional height constraint
  final double? height;
  
  /// Optional width constraint
  final double? width;

  const OfflineReadyImage({
    Key? key,
    this.imageUrl,
    this.imageUrls,
    this.fit = BoxFit.cover,
    this.fallbackAssetPath = 'assets/images/placeholder.jpg',
    this.loadingWidget,
    this.errorWidget,
    this.height,
    this.width,
  }) : assert(imageUrl != null || imageUrls != null, 'Either imageUrl or imageUrls must be provided'),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the list of URLs if provided, otherwise create a list with the single URL
    final urls = imageUrls ?? (imageUrl != null ? [imageUrl!] : []);
    
    if (urls.isEmpty) {
      // If no URLs are provided, show the fallback asset
      return _buildFallbackImage();
    }
    
    return _buildCachedNetworkImageWithFallbacks(urls, 0);
  }
  
  /// Recursively tries to load images from the URL list, falling back to the next one on error
  Widget _buildCachedNetworkImageWithFallbacks(List<String> urls, int index) {
    if (index >= urls.length) {
      // If we've tried all URLs, show the fallback asset
      return _buildFallbackImage();
    }
    
    return CachedNetworkImage(
      imageUrl: urls[index],
      fit: fit,
      height: height,
      width: width,
      placeholder: (context, url) => loadingWidget ?? const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) {
        // If this URL fails, try the next one
        return _buildCachedNetworkImageWithFallbacks(urls, index + 1);
      },
    );
  }
  
  /// Builds the fallback image from local assets
  Widget _buildFallbackImage() {
    if (fallbackAssetPath == null) {
      return errorWidget ?? const Center(
        child: Icon(Icons.broken_image, size: 50),
      );
    }
    
    return Image.asset(
      fallbackAssetPath!,
      fit: fit,
      height: height,
      width: width,
    );
  }
}

/// Helper to generate fallback image URLs from a PhotoResponse
List<String> getFallbackImageUrls(dynamic photo, {String localFallbackPath = 'assets/images/placeholder.jpg'}) {
  List<String> urls = [];
  
  // If it's a PhotoResponse with src property
  if (photo != null && photo.src != null) {
    if (photo.src.large != null) {
      // Convert lib/assets paths to the correct format
      String largePath = photo.src.large;
      if (largePath.startsWith('lib/')) {
        largePath = largePath.replaceFirst('lib/', '');
      }
      urls.add(largePath);
    }
    if (photo.src.medium != null) urls.add(photo.src.medium);
    if (photo.src.small != null) urls.add(photo.src.small);
    if (photo.src.tiny != null) urls.add(photo.src.tiny);
  }
  // If it's just a string URL
  else if (photo is String) {
    urls.add(photo);
  }
  
  // Always add local fallback at the end
  urls.add(localFallbackPath);
  
  return urls;
}