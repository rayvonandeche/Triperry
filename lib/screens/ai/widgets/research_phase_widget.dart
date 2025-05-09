import 'package:flutter/material.dart';
import '../models/ai_models.dart';
import '../services/trip_planning_guide.dart';

/// Widget that displays the research phase of the travel planning process
class ResearchPhaseWidget extends StatefulWidget {
  /// The selected destination
  final String selectedDestination;
  
  /// The selected travel time
  final String travelTime;
  
  /// The selected interest category
  final String selectedInterest;
  
  /// The selected budget
  final BudgetRange budget;
  
  /// Animation for fade effect
  final Animation<double> fadeAnimation;
  
  /// Animation for slide effect
  final Animation<Offset> slideAnimation;
  
  /// Callback when research is complete
  final Function(Map<String, dynamic>) onResearchComplete;

  const ResearchPhaseWidget({
    super.key,
    required this.selectedDestination,
    required this.travelTime,
    required this.selectedInterest,
    required this.budget,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.onResearchComplete,
  });

  @override
  State<ResearchPhaseWidget> createState() => _ResearchPhaseWidgetState();
}

class _ResearchPhaseWidgetState extends State<ResearchPhaseWidget> {
  bool _weatherResearchComplete = false;
  bool _localCultureResearchComplete = false;
  bool _safetyInfoComplete = false;
  bool _transportationOptionsComplete = false;
  
  final Map<String, dynamic> _researchData = {};
  
  @override
  void initState() {
    super.initState();
    
    // Simulate research in progress
    _startResearch();
  }
  
  Future<void> _startResearch() async {
    // Simulate API calls to gather destination research
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _weatherResearchComplete = true;
      _researchData['weather'] = {
        'averageTemperature': '22°C',
        'rainyDays': 'Minimal during ${widget.travelTime}',
        'seasonalConsiderations': 'Pack light clothing with a light jacket for evenings',
      };
    });
    
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _localCultureResearchComplete = true;
      _researchData['culture'] = {
        'localCustoms': ['Greeting customs', 'Dining etiquette', 'Appropriate attire'],
        'languageTips': 'Basic phrases to know',
        'culturalConsiderations': 'Important local customs to respect',
      };
    });
    
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _safetyInfoComplete = true;
      _researchData['safety'] = {
        'safetyRating': 'High',
        'emergencyContacts': {'police': '911', 'ambulance': '112', 'embassy': '+1-555-123-4567'},
        'areasToBeCautious': ['Downtown at night', 'Tourist hotspots (watch for pickpockets)'],
      };
    });
    
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _transportationOptionsComplete = true;
      _researchData['transportation'] = {
        'localOptions': ['Public transit', 'Taxis', 'Rideshare', 'Car rental'],
        'recommendedOption': 'Public transit passes offer the best value for exploring the city',
        'airportTransfer': 'Airport express train runs every 15 minutes and costs \$25',
      };
    });
  }
  
  void _completeResearch() {
    widget.onResearchComplete(_researchData);
  }
  
  @override
  Widget build(BuildContext context) {
    final planningChecklist = TripPlanningGuide.getPlanningChecklist();
    
    return FadeTransition(
      opacity: widget.fadeAnimation,
      child: SlideTransition(
        position: widget.slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Research & Analysis",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "We're gathering important information about ${widget.selectedDestination} to help you prepare for your trip.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            
            // Research progress indicators
            _buildResearchSection(
              "Weather & Climate", 
              _weatherResearchComplete, 
              Icons.wb_sunny,
              context
            ),
            _buildResearchSection(
              "Local Culture & Customs", 
              _localCultureResearchComplete, 
              Icons.people,
              context
            ),
            _buildResearchSection(
              "Safety Information", 
              _safetyInfoComplete, 
              Icons.security,
              context
            ),
            _buildResearchSection(
              "Transportation Options", 
              _transportationOptionsComplete, 
              Icons.directions_bus,
              context
            ),
            
            const SizedBox(height: 24),
            
            // Planning checklist 
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Planning Checklist",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...planningChecklist.take(5).map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Theme.of(context).colorScheme.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Continue button
            if (_weatherResearchComplete && 
                _localCultureResearchComplete && 
                _safetyInfoComplete && 
                _transportationOptionsComplete)
              Center(
                child: ElevatedButton(
                  onPressed: _completeResearch,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text("Continue to Contingency Planning"),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildResearchSection(String title, bool isComplete, IconData icon, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isComplete 
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isComplete 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: isComplete ? 1.0 : 0.6,
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  color: isComplete
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(height: 4),
                Text(
                  isComplete ? "Research complete" : "Researching...",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                    fontStyle: isComplete ? FontStyle.normal : FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isComplete)
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 20,
            ),
        ],
      ),
    );
  }
}