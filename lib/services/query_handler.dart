import 'travel_data_service.dart';

enum QueryIntent { destination, activity, schedule, general }

class QueryHandler {
  static final TravelDataService _travelDataService = TravelDataService();
  static String? _lastLocation;

  static QueryIntent detectIntent(String query) {
    query = query.toLowerCase();

    if (query.contains('where') ||
        query.contains('destination') ||
        query.contains('place') ||
        query.contains('country') ||
        query.contains('city')) {
      return QueryIntent.destination;
    }

    if (query.contains('what to do') ||
        query.contains('activities') ||
        query.contains('attractions') ||
        query.contains('visit') ||
        query.contains('see')) {
      return QueryIntent.activity;
    }

    if (query.contains('when') ||
        query.contains('schedule') ||
        query.contains('itinerary') ||
        query.contains('plan') ||
        query.contains('days')) {
      return QueryIntent.schedule;
    }

    return QueryIntent.general;
  }

  /// Extracts location from a user query by looking for common location-related phrases
  /// Returns the extracted location string or null if no location is found
  static String? extractLocation(String query) {
    final queryLower = query.toLowerCase();

    // Common location prefixes in travel queries
    final locationPrefixes = [
      'in ',
      'to ',
      'at ',
      'for ',
      'about ',
      'regarding ',
      'concerning ',
      'visiting ',
      'traveling to ',
      'travelling to ',
      'go to ',
      'going to ',
      'vacation in ',
      'holiday in ',
      'trip to ',
      'explore ',
      'visit ',
    ];

    // Common suffixes that might follow a location
    final locationSuffixes = [
      ' in ',
      ' during ',
      ' for ',
      ' on ',
      ' with ',
      ' and ',
      ' or ',
      ' when ',
      ' this ',
      ' next ',
      '?',
      '.',
      ',',
    ];

    // Check for explicit location requests like "tell me about Paris"
    for (final prefix in locationPrefixes) {
      if (queryLower.contains(prefix)) {
        final startIndex = queryLower.indexOf(prefix) + prefix.length;
        int endIndex = queryLower.length;

        // Find the end of the location by looking for a suffix
        for (final suffix in locationSuffixes) {
          final suffixIndex = queryLower.indexOf(suffix, startIndex);
          if (suffixIndex > startIndex && (suffixIndex < endIndex)) {
            endIndex = suffixIndex;
          }
        }

        // Extract the location between prefix and suffix
        if (endIndex > startIndex) {
          final location = query.substring(startIndex, endIndex).trim();
          if (location.isNotEmpty && location.length > 1) {
            // Capitalize first letter of each word for better display
            return location.split(' ').map((word) {
              return word.isNotEmpty
                  ? word[0].toUpperCase() + word.substring(1)
                  : '';
            }).join(' ');
          }
        }
      }
    }

    // Check for common city and country names directly in the query
    final commonLocations = [
      'Paris',
      'London',
      'New York',
      'Tokyo',
      'Rome',
      'Amsterdam',
      'Barcelona',
      'Berlin',
      'Sydney',
      'Dubai',
      'Singapore',
      'Hong Kong',
      'Bangkok',
      'Istanbul',
      'Venice',
      'Prague',
      'Vienna',
      'Madrid',
      'Seoul',
      'San Francisco',
      'Los Angeles',
      'Chicago',
      'Toronto',
      'Florence',
      'Kyoto',
      'Bali',
      'Hawaii',
      'Alps',
      'Caribbean',
      'France',
      'Italy',
      'Spain',
      'Japan',
      'Thailand',
      'Australia',
      'Greece',
      'Egypt',
      'Morocco',
      'India',
      'China',
      'Brazil',
      'Mexico',
      'Canada',
      'Germany',
      'Switzerland',
      'Norway',
      'Sweden',
      'Finland',
      'Denmark',
      'Ireland',
      'Scotland',
      'Wales',
      'Portugal'
    ];

    for (final location in commonLocations) {
      final locationLower = location.toLowerCase();
      if (queryLower.contains(locationLower)) {
        // Make sure it's a standalone word by checking for word boundaries
        final regex = RegExp('\\b$locationLower\\b');
        if (regex.hasMatch(queryLower)) {
          return location;
        }
      }
    }

    return null;
  }

  static void setLastLocation(String? location) {
    if (location != null && location.isNotEmpty) {
      _lastLocation = location;
    }
  }

  // Generate interactive follow-up questions based on intent
  static List<Map<String, String>> generateFollowUpQuestions(
      QueryIntent intent, String? location) {
    final questions = <Map<String, String>>[];

    if (location == null) {
      questions.add({
        'text': 'Which destination are you interested in?',
        'type': 'location'
      });
    }

    switch (intent) {
      case QueryIntent.destination:
        questions.add({
          'text':
              'What kind of travel experience are you looking for? (beach, adventure, culture, relaxation)',
          'type': 'preference'
        });
        questions
            .add({'text': 'When are you planning to travel?', 'type': 'date'});
        break;

      case QueryIntent.activity:
        questions.add({
          'text':
              'Are you interested in any specific type of activities? (outdoor, cultural, food, family-friendly)',
          'type': 'category'
        });
        questions.add({
          'text': 'How much time do you have for activities?',
          'type': 'duration'
        });
        break;

      case QueryIntent.schedule:
        questions.add(
            {'text': 'How many days will you be staying?', 'type': 'days'});
        questions.add({
          'text': 'Do you prefer a relaxed or packed schedule?',
          'type': 'pace'
        });
        break;

      default:
        questions.add({
          'text':
              'What specific information are you looking for about this destination?',
          'type': 'general'
        });
    }

    return questions;
  }

  static Map<String, Object>? getStructuredOutputConfig(
      QueryIntent intent, String query) {
    // Base configuration for more focused responses
    final baseConfig = <String, Object>{
      'temperature': 1.2,
      'maxOutputTokens': 800,
      'topK': 20,
      'topP': 0.7,
    };

    switch (intent) {
      case QueryIntent.destination:
        return {
          'response_mime_type': 'application/json',
          'response_schema': {
            'type': 'OBJECT',
            'properties': {
              'options': {
                'type': 'ARRAY',
                'maxItems': 4,
                'items': {
                  'type': 'OBJECT',
                  'properties': {
                    'label': {'type': 'STRING'},
                    'description': {'type': 'STRING'},
                    'imageQuery': {'type': 'STRING'},
                    'highlights': {
                      'type': 'ARRAY',
                      'maxItems': 4,
                      'items': {'type': 'STRING'}
                    }
                  }
                }
              }
            }
          },
          ...baseConfig,
        };

      case QueryIntent.activity:
        return {
          'response_mime_type': 'application/json',
          'response_schema': {
            'type': 'OBJECT',
            'properties': {
              'activities': {
                'type': 'ARRAY',
                'maxItems': 5,
                'items': {
                  'type': 'OBJECT',
                  'properties': {
                    'name': {'type': 'STRING'},
                    'category': {'type': 'STRING'},
                    'description': {'type': 'STRING'},
                    'imageQuery': {'type': 'STRING'},
                    'highlights': {
                      'type': 'ARRAY',
                      'maxItems': 3, // Consistent with prompt adjustment
                      'items': {'type': 'STRING'}
                    }
                  }
                }
              }
            }
          },
          ...baseConfig,
        };

      case QueryIntent.schedule:
        return {
          'response_mime_type': 'application/json',
          'response_schema': {
            'type': 'OBJECT',
            'properties': {
              'days': {
                'type': 'ARRAY',
                'maxItems': 7,
                'items': {
                  'type': 'OBJECT',
                  'properties': {
                    'day': {'type': 'INTEGER', 'minimum': 1, 'maximum': 7},
                    'date': {'type': 'STRING'}, // Added date field
                    'activities': {
                      'type': 'ARRAY',
                      'maxItems': 3,
                      'items': {
                        'type': 'OBJECT',
                        'properties': {
                          'time': {'type': 'STRING'},
                          'activity': {'type': 'STRING'},
                          'notes': {'type': 'STRING'}
                        }
                      }
                    }
                  }
                }
              }
            }
          },
          ...baseConfig,
        };

      default:
        return null;
    }
  }

  static Future<String> enhancePrompt(
      String originalQuery, QueryIntent intent) async {
    // Extract location from query
    final location = extractLocation(originalQuery);

    // Set as last location if found
    if (location != null) {
      setLastLocation(location);
    }

    String basePrompt;
    switch (intent) {
      case QueryIntent.destination:
        basePrompt = """Based on the query: "$originalQuery"
                 Respond with a focused JSON containing exactly 3 recommended destinations.
                 Each destination MUST include ALL of these fields:
                 - label: Brief name/title (2-4 words)
                 - description: A short 2-3 sentence description about the destination and its unique features
                 - imageQuery: Specific photo search term (e.g. "Paris Eiffel Tower landmark")
                 - highlights: Array of 3-4 key features or reasons to visit""";

      case QueryIntent.activity:
        basePrompt = """Based on the query: "$originalQuery"
                 Provide a focused JSON with 3-5 most popular activities.
                 Each activity MUST include ALL of these fields:
                 - name: activity title
                 - category: Main category (e.g. "Outdoor Adventure", "Cultural Experience", "Food & Dining")
                 - description: short 2-3 sentence description of what the activity entails
                 - imageQuery: Specific photo search term for the activity
                 - highlights: Array of exactly 3 key features or reasons why this activity is special""";

      case QueryIntent.schedule:
        basePrompt = """Based on the query: "$originalQuery"
                 Create a detailed JSON itinerary with:
                 {
                   "days": [
                     {
                       "day": 1,
                       "date": "Date in format: Monday, April 21",
                       "activities": [
                         {
                           "time": "Morning/Afternoon/Evening or specific time",
                           "activity": "Name of activity or location",
                           "notes": "Additional details, tips, or practical information"
                         }
                       ]
                     }
                   ]
                 }
                 Include 2-3 activities per day with specific times
                 Add practical notes about timing, transportation, or tips
                 Make sure each activity has a clear time period""";

      default:
        basePrompt = originalQuery;
    }

    // Augment with real data if location is available
    if (location != null) {
      try {
        return await _travelDataService.augmentPromptWithData(
            basePrompt, location);
      } catch (e) {
        return basePrompt;
      }
    }

    return basePrompt;
  }

  String _enhancePrompt(String prompt, QueryIntent intent) {
    switch (intent) {
      case QueryIntent.destination:
        return '''$prompt
Please provide detailed destination information in the following JSON format:
{
  "options": [
    {
      "label": "Place name",
      "description": "Short description of the place",
      "imageQuery": "Specific image search query for the place",
      "highlights": ["Key highlight 1", "Key highlight 2"]
    }
  ]
}''';
      case QueryIntent.activity:
        return '''$prompt
Please provide detailed activity information in the following JSON format:
{
  "activities": {
    "category1": [
      {
        "name": "Activity name",
        "description": "Short activity description",
        "imageQuery": "Specific image search query",
        "highlights": ["Key feature 1", "Key feature 2"],
        "location": "Activity location"
      }
    ]
  }
}''';
      default:
        return prompt;
    }
  }
}
