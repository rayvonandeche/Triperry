import 'package:flutter/material.dart';

class DemoModeProvider extends ChangeNotifier {
  bool _demoModeEnabled = false;
  String _demoScenario = 'beach_vacation'; // Default scenario
  
  // Demo scenarios with predefined user prompts
  final Map<String, List<String>> _demoScenarios = {
    'beach_vacation': [
      'I want to plan a beach vacation for next month',
      'What are some good beach destinations in Asia?',
      'Tell me more about Bali',
      'What activities can I do in Bali?',
      'How much should I budget for a week in Bali?',
    ],
    'european_tour': [
      'I\'m planning a trip to Europe this summer',
      'Which cities should I visit if I have 2 weeks?',
      'Tell me about Paris',
      'What are the must-see attractions in Paris?',
      'How do I get from Paris to Barcelona?',
    ],
    'city_break': [
      'I need ideas for a weekend city break',
      'Which city is good for art and culture?',
      'Tell me about New York museums',
      'What restaurants should I try in New York?',
      'Is Central Park worth visiting?',
    ],
  };
  
  // Get available demo scenarios
  List<String> get availableScenarios => _demoScenarios.keys.toList();
  
  // Get current scenario
  String get currentScenario => _demoScenario;
  
  // Get demo prompts for current scenario
  List<String> get demoPrompts => _demoScenarios[_demoScenario] ?? [];
  
  // Demo mode status
  bool get isDemoModeEnabled => _demoModeEnabled;
  
  // Toggle demo mode
  void toggleDemoMode() {
    _demoModeEnabled = !_demoModeEnabled;
    notifyListeners();
  }
  
  // Set demo scenario
  void setScenario(String scenario) {
    if (_demoScenarios.containsKey(scenario)) {
      _demoScenario = scenario;
      notifyListeners();
    }
  }
}