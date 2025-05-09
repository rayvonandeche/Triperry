import 'package:flutter/material.dart';

/// Enum representing the different stages of the travel planning flow
enum TravelStage {
  welcome,
  interestSelected,
  destinationSelected,
  timeSelected,
  activitySelected,
  budgetSelected,
  
  // Research and analysis phase
  researchPhase,
  
  // Planning phase
  contingencyPlanning,
  itineraryCreation,
  
  // Booking phase
  bookingPhase,
  
  // Execution phase
  executionPhase,
  
  // Monitoring phase
  monitoringPhase,
  
  // Review phase
  reviewPhase,
  
  // Complete
  complete,
}

/// Model representing a comprehensive travel planning phase
class TravelPlannerPhase {
  /// The title of the phase
  final String title;
  
  /// The description of the phase
  final String description;
  
  /// The icon representing this phase
  final IconData icon;
  
  /// The color associated with this phase
  final Color color;
  
  /// The stages that are part of this phase
  final List<TravelStage> stages;
  
  /// Constructor
  const TravelPlannerPhase({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.stages,
  });
  
  /// Get all available travel planner phases
  static List<TravelPlannerPhase> get allPhases => [
    // Initial phase
    TravelPlannerPhase(
      title: 'Preferences',
      description: 'Setting up your travel preferences',
      icon: Icons.interests,
      color: Colors.blue,
      stages: [
        TravelStage.welcome,
        TravelStage.interestSelected,
        TravelStage.destinationSelected,
        TravelStage.timeSelected,
        TravelStage.activitySelected,
        TravelStage.budgetSelected,
      ],
    ),
    
    // Research phase
    TravelPlannerPhase(
      title: 'Research',
      description: 'Gathering essential destination information',
      icon: Icons.search,
      color: Colors.orange,
      stages: [
        TravelStage.researchPhase,
      ],
    ),
    
    // Planning phase
    TravelPlannerPhase(
      title: 'Planning',
      description: 'Creating your detailed travel itinerary',
      icon: Icons.event_note,
      color: Colors.green,
      stages: [
        TravelStage.contingencyPlanning,
        TravelStage.itineraryCreation,
      ],
    ),
    
    // Booking phase
    TravelPlannerPhase(
      title: 'Booking',
      description: 'Securing accommodations, tickets and reservations',
      icon: Icons.confirmation_number,
      color: Colors.purple,
      stages: [
        TravelStage.bookingPhase,
      ],
    ),
    
    // Execution phase
    TravelPlannerPhase(
      title: 'Execution',
      description: 'Final preparations before your trip',
      icon: Icons.flight_takeoff,
      color: Colors.red,
      stages: [
        TravelStage.executionPhase,
      ],
    ),
    
    // Monitoring phase
    TravelPlannerPhase(
      title: 'Monitoring',
      description: 'Real-time updates during your journey',
      icon: Icons.travel_explore,
      color: Colors.teal,
      stages: [
        TravelStage.monitoringPhase,
      ],
    ),
    
    // Review phase
    TravelPlannerPhase(
      title: 'Review',
      description: 'Reflecting on your travel experience',
      icon: Icons.rate_review,
      color: Colors.deepPurple,
      stages: [
        TravelStage.reviewPhase,
      ],
    ),
    
    // Complete
    TravelPlannerPhase(
      title: 'Complete',
      description: 'Your travel planning is complete',
      icon: Icons.check_circle,
      color: Colors.green,
      stages: [
        TravelStage.complete,
      ],
    ),
  ];
  
  /// Check if a travel stage belongs to this phase
  bool containsStage(TravelStage stage) {
    return stages.contains(stage);
  }
  
  /// Get the phase that contains a specific stage
  static TravelPlannerPhase getPhaseForStage(TravelStage stage) {
    return allPhases.firstWhere((phase) => phase.containsStage(stage));
  }
  
  /// Get the index of a phase in the overall flow
  static int getPhaseIndex(TravelPlannerPhase phase) {
    return allPhases.indexOf(phase);
  }
  
  /// Get the progress percentage based on the current stage
  static double getProgressPercentage(TravelStage currentStage) {
    final allStages = allPhases.expand((phase) => phase.stages).toList();
    final currentIndex = allStages.indexOf(currentStage);
    
    return (currentIndex + 1) / allStages.length;
  }
}

/// Data collected during the travel planning process
class TravelPlanningData {
  /// Selected interests
  List<String> interests;
  
  /// Selected destination
  String? destination;
  
  /// Selected travel time
  String? travelTime;
  
  /// Selected activities
  List<String> activities;
  
  /// Selected budget
  String? budget;
  
  /// Research data
  Map<String, dynamic>? researchData;
  
  /// Contingency plan data
  Map<String, dynamic>? contingencyData;
  
  /// Itinerary data
  Map<String, dynamic>? itineraryData;
  
  /// Booking data
  Map<String, dynamic>? bookingData;
  
  /// Execution data
  Map<String, dynamic>? executionData;
  
  /// Monitoring data
  Map<String, dynamic>? monitoringData;
  
  /// Review data
  Map<String, dynamic>? reviewData;
  
  /// Constructor
  TravelPlanningData({
    this.interests = const [],
    this.destination,
    this.travelTime,
    this.activities = const [],
    this.budget,
    this.researchData,
    this.contingencyData,
    this.itineraryData,
    this.bookingData,
    this.executionData,
    this.monitoringData,
    this.reviewData,
  });
  
  /// Check if the research phase is complete
  bool get isResearchComplete => researchData != null && researchData!['researchCompleted'] == true;
  
  /// Check if the contingency planning phase is complete
  bool get isContingencyPlanningComplete => contingencyData != null && contingencyData!['contingencyPlansCreated'] == true;
  
  /// Check if the itinerary phase is complete
  bool get isItineraryComplete => itineraryData != null && itineraryData!['itineraryGenerated'] == true;
  
  /// Check if the booking phase is complete
  bool get isBookingComplete => bookingData != null && bookingData!['bookingCompleted'] == true;
  
  /// Check if the execution phase is complete
  bool get isExecutionComplete => executionData != null && executionData!['executionCompleted'] == true;
  
  /// Check if the monitoring phase is complete
  bool get isMonitoringComplete => monitoringData != null && monitoringData!['monitoringCompleted'] == true;
  
  /// Check if the review phase is complete
  bool get isReviewComplete => reviewData != null && reviewData!['reviewCompleted'] == true;
}