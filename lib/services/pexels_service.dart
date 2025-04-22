import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Added VideoItem class for the video section
class VideoItem {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String videoUrl;
  final String duration;
  final String creator;

  const VideoItem({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.duration,
    required this.creator,
  });
}

class PexelsService {
  // Replace with your actual Pexels API key
  static const String _apiKey = 'OwpSRtDEiej4PtjuisrGFvERtk13wyKQJm80UYuobFU3yDB04GXm7Uhw';
  static const String _baseUrl = 'https://api.pexels.com/v1';
  
  // Cache key and expiration time (24 hours in milliseconds)
  static const String _cacheKey = 'pexels_photo_cache';
  static const int _cacheExpirationTime = 86400000;
  
  // Get demo videos (in a real app, you would fetch these from an API)
  List<VideoItem> getDemoVideos() {
    return [
      VideoItem(
        id: 'v1',
        title: 'Breathtaking Ocean Waves at Sunset',
        thumbnailUrl: 'https://images.pexels.com/videos/3571264/free-video-3571264.jpg?auto=compress&cs=tinysrgb&fit=crop&h=630&w=1200',
        videoUrl: 'https://player.vimeo.com/external/363625327.hd.mp4?s=a287a3583ba251be23ff28cbd72182ead5966d17&profile_id=175&oauth2_token_id=57447761',
        duration: '0:32',
        creator: 'Ocean Explorer',
      ),
      VideoItem(
        id: 'v2',
        title: 'Aerial View of Mountain Range',
        thumbnailUrl: 'https://images.pexels.com/videos/5245304/free-video-5245304.jpg?auto=compress&cs=tinysrgb&fit=crop&h=630&w=1200',
        videoUrl: 'https://player.vimeo.com/external/470803424.hd.mp4?s=fe0bb5533a71cd829a7456b4734ac20b695a1803&profile_id=175&oauth2_token_id=57447761',
        duration: '0:41',
        creator: 'Aerial Cinematics',
      ),
      VideoItem(
        id: 'v3',
        title: 'City Life in Tokyo at Night',
        thumbnailUrl: 'https://images.pexels.com/videos/3694153/free-video-3694153.jpg?auto=compress&cs=tinysrgb&fit=crop&h=630&w=1200',
        videoUrl: 'https://player.vimeo.com/external/400196188.hd.mp4?s=128b6ce29e446b50eb11434dce23c4cede24196d&profile_id=175&oauth2_token_id=57447761',
        duration: '0:25',
        creator: 'City Explorer',
      ),
      VideoItem(
        id: 'v4',
        title: 'Hiking Through the Wilderness',
        thumbnailUrl: 'https://images.pexels.com/videos/3330350/pexels-photo-3330350.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=630&w=1200',
        videoUrl: 'https://player.vimeo.com/external/390402415.hd.mp4?s=7c95053c1a91b7a1e268908b5619a131cab5a758&profile_id=175&oauth2_token_id=57447761',
        duration: '0:37',
        creator: 'Nature Explorers',
      ),
    ];
  }

  Future<List<Map<String, dynamic>>> searchPhotos(String query, {int perPage = 5}) async {
    // Check cache first
    final cachedResults = await _getFromCache(query);
    if (cachedResults != null) {
      return cachedResults;
    }
    
    final url = Uri.parse('$_baseUrl/search?query=${Uri.encodeComponent(query)}&per_page=$perPage');
    
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': _apiKey,
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final photos = List<Map<String, dynamic>>.from(data['photos']);
        
        // Cache the results
        await _saveToCache(query, photos);
        
        return photos;
      } else {
        print('Error fetching photos: ${response.statusCode}');
        return _getFallbackImages();
      }
    } catch (e) {
      print('Exception while fetching photos: $e');
      return _getFallbackImages();
    }
  }
  
  // Cache helpers
  Future<void> _saveToCache(String query, List<Map<String, dynamic>> photos) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final cacheData = {
        'timestamp': timestamp,
        'photos': photos,
      };
      
      // Get existing cache map or create new one
      final String? existingCache = prefs.getString(_cacheKey);
      Map<String, dynamic> cacheMap = {};
      
      if (existingCache != null) {
        cacheMap = Map<String, dynamic>.from(jsonDecode(existingCache));
      }
      
      // Add/update this entry
      cacheMap[query.toLowerCase()] = cacheData;
      
      // Save back to SharedPreferences
      await prefs.setString(_cacheKey, jsonEncode(cacheMap));
    } catch (e) {
      print('Error saving to cache: $e');
    }
  }

  Future<List<Map<String, dynamic>>?> _getFromCache(String query) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? existingCache = prefs.getString(_cacheKey);
      
      if (existingCache == null) return null;
      
      final cacheMap = Map<String, dynamic>.from(jsonDecode(existingCache));
      final entry = cacheMap[query.toLowerCase()];
      
      if (entry == null) return null;
      
      final timestamp = entry['timestamp'];
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      
      // Check if cached data is still valid
      if (currentTime - timestamp < _cacheExpirationTime) {
        return List<Map<String, dynamic>>.from(entry['photos']);
      }
    } catch (e) {
      print('Error retrieving from cache: $e');
    }
    
    return null;
  }
  
  // Fallback images when API fails or rate limited
  List<Map<String, dynamic>> _getFallbackImages() {
    return [
      {
        'id': 1,
        'width': 800,
        'height': 600,
        'url': 'https://example.com/fallback1.jpg',
        'photographer': 'Default',
        'photographer_url': 'https://www.pexels.com',
        'src': {
          'original': 'https://images.pexels.com/photos/1051073/pexels-photo-1051073.jpeg',
          'large2x': 'https://images.pexels.com/photos/1051073/pexels-photo-1051073.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
          'large': 'https://images.pexels.com/photos/1051073/pexels-photo-1051073.jpeg?auto=compress&cs=tinysrgb&h=650&w=940',
          'medium': 'https://images.pexels.com/photos/1051073/pexels-photo-1051073.jpeg?auto=compress&cs=tinysrgb&h=350',
          'small': 'https://images.pexels.com/photos/1051073/pexels-photo-1051073.jpeg?auto=compress&cs=tinysrgb&h=130',
          'portrait': 'https://images.pexels.com/photos/1051073/pexels-photo-1051073.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800',
          'landscape': 'https://images.pexels.com/photos/1051073/pexels-photo-1051073.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200',
          'tiny': 'https://images.pexels.com/photos/1051073/pexels-photo-1051073.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280'
        }
      },
      {
        'id': 2,
        'width': 800,
        'height': 600,
        'url': 'https://example.com/fallback2.jpg',
        'photographer': 'Default',
        'photographer_url': 'https://www.pexels.com',
        'src': {
          'original': 'https://images.pexels.com/photos/3601425/pexels-photo-3601425.jpeg',
          'large2x': 'https://images.pexels.com/photos/3601425/pexels-photo-3601425.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
          'large': 'https://images.pexels.com/photos/3601425/pexels-photo-3601425.jpeg?auto=compress&cs=tinysrgb&h=650&w=940',
          'medium': 'https://images.pexels.com/photos/3601425/pexels-photo-3601425.jpeg?auto=compress&cs=tinysrgb&h=350',
          'small': 'https://images.pexels.com/photos/3601425/pexels-photo-3601425.jpeg?auto=compress&cs=tinysrgb&h=130',
          'portrait': 'https://images.pexels.com/photos/3601425/pexels-photo-3601425.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800',
          'landscape': 'https://images.pexels.com/photos/3601425/pexels-photo-3601425.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200',
          'tiny': 'https://images.pexels.com/photos/3601425/pexels-photo-3601425.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280'
        }
      },
      {
        'id': 3,
        'width': 800,
        'height': 600,
        'url': 'https://example.com/fallback3.jpg',
        'photographer': 'Default',
        'photographer_url': 'https://www.pexels.com',
        'src': {
          'original': 'https://images.pexels.com/photos/1659438/pexels-photo-1659438.jpeg',
          'large2x': 'https://images.pexels.com/photos/1659438/pexels-photo-1659438.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
          'large': 'https://images.pexels.com/photos/1659438/pexels-photo-1659438.jpeg?auto=compress&cs=tinysrgb&h=650&w=940',
          'medium': 'https://images.pexels.com/photos/1659438/pexels-photo-1659438.jpeg?auto=compress&cs=tinysrgb&h=350',
          'small': 'https://images.pexels.com/photos/1659438/pexels-photo-1659438.jpeg?auto=compress&cs=tinysrgb&h=130',
          'portrait': 'https://images.pexels.com/photos/1659438/pexels-photo-1659438.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800',
          'landscape': 'https://images.pexels.com/photos/1659438/pexels-photo-1659438.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200',
          'tiny': 'https://images.pexels.com/photos/1659438/pexels-photo-1659438.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280'
        }
      }
    ];
  }
}

class PhotoResponse {
  final int id;
  final int width;
  final int height;
  final String url;
  final String photographer;
  final String photographerUrl;
  final int photographerId;
  final String avgColor;
  final Src src;
  final String alt;

  const PhotoResponse({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.photographer,
    required this.photographerUrl,
    required this.photographerId,
    required this.avgColor,
    required this.src,
    required this.alt,
  });

  factory PhotoResponse.fromJson(Map<String, dynamic> json) {
    return PhotoResponse(
      id: json['id'] ?? 0,
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      url: json['url'] ?? '',
      photographer: json['photographer'] ?? '',
      photographerId: json['photographer_id'] ?? 0,
      photographerUrl: json['photographer_url'] ?? '',
      avgColor: json['avg_color'] ?? '',
      src: Src.fromJson(json['src'] ?? {}),  // Fix: Pass the 'src' object
      alt: json['alt'] ?? '',
    );
  }
}

class Src {
  final String original;
  final String large2x;
  final String large;
  final String medium;
  final String small;
  final String portrait;
  final String landscape;
  final String tiny;

  const Src({
    required this.original,
    required this.large2x,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
    required this.tiny,
  });

  factory Src.fromJson(Map<String, dynamic> json) {
    return Src(
      original: json['original'] ?? '',
      large2x: json['large2x'] ?? '',
      large: json['large'] ?? '',
      medium: json['medium'] ?? '',
      small: json['small'] ?? '',
      portrait: json['portrait'] ?? '',
      landscape: json['landscape'] ?? '',
      tiny: json['tiny'] ?? '',
    );
  }
}
