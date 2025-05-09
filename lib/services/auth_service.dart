import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final Map<String, dynamic> travelPreferences;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.travelPreferences,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      travelPreferences: json['travelPreferences'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'travelPreferences': travelPreferences,
    };
  }
}

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  // Demo users for the app
  final Map<String, User> _users = {
    'anthony@triperry.com': User(
      id: '1',
      name: 'Anthony Mwangi',
      email: 'anthony@triperry.com',
      avatar: 'assets/images/avatars/anthony.jpg',
      travelPreferences: {
        'travelStyle': 'Adventure',
        'preferredDestinations': ['Safari', 'Mountains', 'Cultural'],
        'budgetRange': 'Mid-range',
        'travelFrequency': 'Quarterly',
        'dietaryRestrictions': 'None',
        'accommodationPreference': 'Mid-range hotels',
      },
    ),
    'tamara@triperry.com': User(
      id: '2',
      name: 'Tamara Chebet',
      email: 'tamara@triperry.com',
      avatar: 'assets/images/avatars/tamara.jpg',
      travelPreferences: {
        'travelStyle': 'Luxury',
        'preferredDestinations': ['Beach', 'City', 'Island'],
        'budgetRange': 'Premium',
        'travelFrequency': 'Monthly',
        'dietaryRestrictions': 'Vegetarian',
        'accommodationPreference': 'Luxury resorts',
      },
    ),
  };

  AuthService() {
    _loadUserFromStorage();
  }

  Future<void> _loadUserFromStorage() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');

    if (userData != null) {
      try {
        _currentUser = User.fromJson(jsonDecode(userData));
      } catch (e) {
        debugPrint('Error loading user: $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // For demo purposes, we're using a simple check
    // In a real app, you'd verify credentials against a backend
    if (_users.containsKey(email) && password == 'password123') {
      _currentUser = _users[email];
      
      // Save user to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(_currentUser!.toJson()));
      
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> signup(
    String name,
    String email,
    String password,
    Map<String, dynamic> travelPreferences,
  ) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, you'd create a new user in your backend
    // For demo, we'll check if email exists and add if not
    if (_users.containsKey(email)) {
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Create new user
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      avatar: 'assets/images/avatars/default.png',
      travelPreferences: travelPreferences,
    );

    // Add to users map (in real app, would be saved to backend)
    _users[email] = newUser;
    
    // Set as current user
    _currentUser = newUser;
    
    // Save user to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(_currentUser!.toJson()));

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    // Clear local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');

    _currentUser = null;

    _isLoading = false;
    notifyListeners();
  }
}
