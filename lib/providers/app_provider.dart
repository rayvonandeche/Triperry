import 'package:flutter/material.dart';
import 'package:triperry/models/video_item.dart';

/// Main app state management provider
class AppProvider extends ChangeNotifier {
  // Theme state
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Location state
  String _currentLocation = "";
  String get currentLocation => _currentLocation;

  // Content state
  List _recentPhotos = [];
  List<VideoItem> _recentVideos = [];
  List  get recentPhotos => _recentPhotos;
  List<VideoItem> get recentVideos => _recentVideos;

  // Demo mode state (for testing without API calls)
  bool _demoMode = true;
  bool get demoMode => _demoMode;

  // App settings
  bool _notificationsEnabled = true;
  String _preferredLanguage = 'en';
  bool get notificationsEnabled => _notificationsEnabled;
  String get preferredLanguage => _preferredLanguage;

  /// Set theme mode (system, light, or dark)
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  // Legacy toggle method - now toggles between light and dark, or respects system
  void toggleTheme() {
    if (_themeMode == ThemeMode.system) {
      _themeMode = ThemeMode.dark;
    } else if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  /// Update current location
  void updateLocation(String location) {
    _currentLocation = location;
    notifyListeners();
  }

  /// Add photos to recent photos list
  void addRecentPhotos(List photos) {
    _recentPhotos = [...photos, ..._recentPhotos]
        .take(20) // Keep only the 20 most recent
        .toList();
    notifyListeners();
  }

  /// Add videos to recent videos list
  void addRecentVideos(List<VideoItem> videos) {
    _recentVideos = [...videos, ..._recentVideos]
        .take(20) // Keep only the 20 most recent
        .toList();
    notifyListeners();
  }

  /// Toggle demo mode
  void toggleDemoMode() {
    _demoMode = !_demoMode;
    notifyListeners();
  }

  /// Toggle notifications
  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
  }

  /// Update preferred language
  void updateLanguage(String language) {
    _preferredLanguage = language;
    notifyListeners();
  }

  /// Clear recent content
  void clearRecentContent() {
    _recentPhotos = [];
    _recentVideos = [];
    notifyListeners();
  }
}