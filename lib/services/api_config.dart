import 'package:flutter/foundation.dart';

/// Configuration class for API keys and settings
class ApiConfig {
  // Gemini API configuration
  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
  static const String geminiModelName = String.fromEnvironment('GEMINI_MODEL', defaultValue: 'gemini-1.5-pro');
  
  // Google Custom Search API configuration
  static const String searchApiKey = String.fromEnvironment('SEARCH_API_KEY', defaultValue: '');
  static const String searchEngineId = String.fromEnvironment('SEARCH_ENGINE_ID', defaultValue: '');
  
  // Development flags
  static const bool useMockGeminiApi = bool.fromEnvironment('USE_MOCK_GEMINI', defaultValue: true);
  static const bool useMockSearchApi = bool.fromEnvironment('USE_MOCK_SEARCH', defaultValue: true);
  
  /// Returns true if all necessary API keys are configured for production use
  static bool get isProductionReady {
    return geminiApiKey.isNotEmpty && 
           searchApiKey.isNotEmpty && 
           searchEngineId.isNotEmpty;
  }
  
  /// Logs the configuration status at startup (without exposing keys)
  static void logConfigStatus() {
    if (kDebugMode) {
      print('=== API Configuration Status ===');
      print('Gemini API Key: ${geminiApiKey.isEmpty ? 'Missing' : 'Configured'}');
      print('Search API Key: ${searchApiKey.isEmpty ? 'Missing' : 'Configured'}');
      print('Search Engine ID: ${searchEngineId.isEmpty ? 'Missing' : 'Configured'}');
      print('Using Mock Gemini API: $useMockGeminiApi');
      print('Using Mock Search API: $useMockSearchApi');
      print('Production Ready: $isProductionReady');
      print('===============================');
    }
  }
}