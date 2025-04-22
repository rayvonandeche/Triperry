import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

/// Service for handling Google Custom Search API requests
class GoogleSearchService {
  static const String _baseUrl = 'https://www.googleapis.com/customsearch/v1';
  
  /// Performs a search query using Google Custom Search API
  /// 
  /// Returns a list of search results with title, snippet and link
  Future<List<Map<String, dynamic>>> search(String query, {int resultCount = 5}) async {
    // Use mock data during development if specified in config
    if (ApiConfig.useMockSearchApi) {
      return _getMockSearchResults(query);
    }
    
    try {
      // Construct the Google Custom Search API URL
      final url = Uri.parse('$_baseUrl?'
          'key=${ApiConfig.searchApiKey}'
          '&cx=${ApiConfig.searchEngineId}'
          '&q=${Uri.encodeComponent(query)}'
          '&num=$resultCount');
      
      // Make the API request
      final response = await http.get(url);
      
      // Handle API response
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Extract search results
        if (data.containsKey('items') && data['items'] is List) {
          return (data['items'] as List).map((item) {
            return {
              'title': item['title'] ?? '',
              'snippet': item['snippet'] ?? '',
              'link': item['link'] ?? '',
            };
          }).toList();
        }
        return [];
      } else {
        throw Exception('Failed to search: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Fallback to mock data in case of errors
      print('Google Search API error: $e');
      return _getMockSearchResults(query);
    }
  }
  
  /// Provides mock search results for development purposes
  List<Map<String, dynamic>> _getMockSearchResults(String query) {
    // Generate relevant mock results based on query keywords
    final normalizedQuery = query.toLowerCase();
    
    if (normalizedQuery.contains('paris') || normalizedQuery.contains('france')) {
      return [
        {
          'title': 'Top 10 Things to Do in Paris - Travel Guide',
          'snippet': 'Discover the Eiffel Tower, Louvre Museum, and more must-see attractions in the City of Light.',
          'link': 'https://example.com/paris-travel-guide'
        },
        {
          'title': 'Paris Weather and Best Time to Visit',
          'snippet': 'Paris has a temperate climate with mild weather year-round. The best time to visit is April-June or September-October.',
          'link': 'https://example.com/paris-weather'
        }
      ];
    }
    
    if (normalizedQuery.contains('tokyo') || normalizedQuery.contains('japan')) {
      return [
        {
          'title': 'Tokyo Travel Guide - Best Attractions and Food',
          'snippet': 'Explore Tokyo\'s blend of traditional culture and futuristic cityscape. Visit temples, enjoy delicious ramen and sushi.',
          'link': 'https://example.com/tokyo-guide'
        },
        {
          'title': 'Getting Around Tokyo - Transportation Tips',
          'snippet': 'Tokyo\'s extensive metro system is efficient and convenient. The Japan Rail Pass offers excellent value for tourists.',
          'link': 'https://example.com/tokyo-transportation'
        }
      ];
    }
    
    // Generic travel results for any other query
    return [
      {
        'title': 'Travel Tips for ${_capitalizeFirstLetter(query)}',
        'snippet': 'Essential travel information including weather, attractions, and local customs.',
        'link': 'https://example.com/travel-guide'
      },
      {
        'title': 'Best Hotels in Popular Destinations',
        'snippet': 'Find top-rated accommodations from budget to luxury options in cities worldwide.',
        'link': 'https://example.com/hotels'
      },
      {
        'title': 'Travel Safety Information',
        'snippet': 'Stay informed about travel advisories, health recommendations, and safety tips for international travelers.',
        'link': 'https://example.com/travel-safety'
      }
    ];
  }
  
  /// Helper method to capitalize the first letter of a string
  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}