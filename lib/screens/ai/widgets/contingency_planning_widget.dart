import 'package:flutter/material.dart';
import '../models/ai_models.dart';

/// Widget that displays the contingency planning phase of the travel planning process
class ContingencyPlanningWidget extends StatefulWidget {
  /// The selected destination
  final String selectedDestination;
  
  /// Research data from previous phase
  final Map<String, dynamic> researchData;
  
  /// Animation for fade effect
  final Animation<double> fadeAnimation;
  
  /// Animation for slide effect
  final Animation<Offset> slideAnimation;
  
  /// Callback when contingency planning is complete
  final Function(Map<String, dynamic>) onContingencyPlanningComplete;

  const ContingencyPlanningWidget({
    super.key,
    required this.selectedDestination,
    required this.researchData,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.onContingencyPlanningComplete,
  });

  @override
  State<ContingencyPlanningWidget> createState() => _ContingencyPlanningWidgetState();
}

class _ContingencyPlanningWidgetState extends State<ContingencyPlanningWidget> {
  final Map<String, bool> _selectedContingencies = {
    'weather': false,
    'health': false,
    'transportation': false,
    'accommodation': false,
    'documentation': false,
  };
  
  final Map<String, dynamic> _contingencyPlanData = {};
  
  void _updateContingency(String key, bool value) {
    setState(() {
      _selectedContingencies[key] = value;
      
      // Add corresponding contingency plan data
      if (value) {
        switch (key) {
          case 'weather':
            _contingencyPlanData['weather'] = {
              'title': 'Weather Contingencies',
              'plans': [
                'Pack weather-appropriate clothing including rain gear',
                'Research indoor activities for rainy days',
                'Download local weather app for real-time updates',
                'Consider travel insurance that covers weather-related cancellations'
              ],
            };
            break;
          case 'health':
            _contingencyPlanData['health'] = {
              'title': 'Health Contingencies',
              'plans': [
                'Pack a basic first aid kit with essential medications',
                'Research local healthcare facilities near your accommodation',
                'Purchase comprehensive travel insurance with medical coverage',
                'Save emergency contact numbers for local hospitals and your embassy'
              ],
            };
            break;
          case 'transportation':
            _contingencyPlanData['transportation'] = {
              'title': 'Transportation Contingencies',
              'plans': [
                'Download offline maps and transportation apps',
                'Have contact information for local taxi services',
                'Keep emergency funds for unexpected transportation needs',
                'Research alternative routes to key destinations'
              ],
            };
            break;
          case 'accommodation':
            _contingencyPlanData['accommodation'] = {
              'title': 'Accommodation Contingencies',
              'plans': [
                'Save booking confirmation and hotel contact information offline',
                'Research backup accommodations in case of issues',
                'Note emergency exits at your accommodation upon arrival',
                'Share your accommodation details with a trusted contact'
              ],
            };
            break;
          case 'documentation':
            _contingencyPlanData['documentation'] = {
              'title': 'Documentation Contingencies',
              'plans': [
                'Make digital and physical copies of all important documents',
                'Email copies of your passport and travel insurance to yourself',
                'Register with your country\'s embassy in the destination',
                'Keep a list of emergency contacts and important numbers'
              ],
            };
            break;
        }
      } else {
        _contingencyPlanData.remove(key);
      }
    });
  }
  
  void _completeContingencyPlanning() {
    widget.onContingencyPlanningComplete(_contingencyPlanData);
  }
  
  @override
  Widget build(BuildContext context) {
    final safetyInfo = widget.researchData['safety'] as Map<String, dynamic>?;
    
    return FadeTransition(
      opacity: widget.fadeAnimation,
      child: SlideTransition(
        position: widget.slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Contingency Planning",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Let's prepare for unexpected situations during your trip to ${widget.selectedDestination} to ensure you're ready for anything.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            
            // Safety information from research phase
            if (safetyInfo != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text(
                          "Safety Information",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text("Safety Rating: "),
                        Text(
                          safetyInfo['safetyRating'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text("Areas to be cautious:"),
                    ...(safetyInfo['areasToBeCautious'] as List).map((area) => Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.warning, size: 14, color: Colors.orange),
                          const SizedBox(width: 8),
                          Expanded(child: Text(area as String)),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            
            // Contingency plan selection section
            Text(
              "Select contingency plans you'd like to prepare:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            
            // Contingency options with checkboxes
            _buildContingencyOption(
              'Weather Disruptions', 
              'Plans for rain, storms, or extreme weather events', 
              'weather',
              Icons.wb_cloudy,
              context
            ),
            _buildContingencyOption(
              'Health & Medical Issues', 
              'First aid, medication, and healthcare access', 
              'health',
              Icons.medical_services,
              context
            ),
            _buildContingencyOption(
              'Transportation Problems', 
              'Missed connections, delays, or cancellations', 
              'transportation',
              Icons.train,
              context
            ),
            _buildContingencyOption(
              'Accommodation Issues', 
              'Booking problems or accommodation emergencies', 
              'accommodation',
              Icons.hotel,
              context
            ),
            _buildContingencyOption(
              'Lost Documents & Valuables', 
              'Plans for lost passport, cards, or personal items', 
              'documentation',
              Icons.description,
              context
            ),
            
            const SizedBox(height: 24),
            
            // Selected contingency plans
            if (_contingencyPlanData.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Contingency Plans",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._contingencyPlanData.values.map((plan) => _buildContingencyPlanDetails(
                      plan['title'],
                      plan['plans'],
                      context,
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            
            // Continue button
            Center(
              child: ElevatedButton(
                onPressed: _completeContingencyPlanning,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text("Continue to Itinerary Creation"),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildContingencyOption(
    String title, 
    String description, 
    String key, 
    IconData icon,
    BuildContext context
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _selectedContingencies[key]! 
              ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3) 
              : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: _selectedContingencies[key]!
                ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: CheckboxListTile(
          value: _selectedContingencies[key],
          onChanged: (value) => _updateContingency(key, value ?? false),
          title: Row(
            children: [
              Icon(
                icon,
                color: _selectedContingencies[key]!
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: _selectedContingencies[key]! ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          subtitle: Text(description),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
  
  Widget _buildContingencyPlanDetails(String title, List<String> plans, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...plans.map((plan) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(plan),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}