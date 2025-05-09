import 'package:flutter/material.dart';

/// Widget that displays the contingency planning phase of travel planning
class ContingencyPlanningStage extends StatefulWidget {
  /// The selected destination
  final String selectedDestination;
  
  /// Animation for slide effect
  final Animation<Offset> slideAnimation;
  
  /// Animation for fade effect
  final Animation<double> fadeAnimation;
  
  /// Callback when contingency planning is complete
  final Function(Map<String, dynamic>) onContingencyPlanningComplete;

  const ContingencyPlanningStage({
    super.key,
    required this.selectedDestination,
    required this.slideAnimation,
    required this.fadeAnimation,
    required this.onContingencyPlanningComplete,
  });

  @override
  State<ContingencyPlanningStage> createState() => _ContingencyPlanningStageState();
}

class _ContingencyPlanningStageState extends State<ContingencyPlanningStage> {
  final List<ContingencyScenario> _scenarios = [];
  bool _isLoading = true;
  Map<String, dynamic> _contingencyData = {};
  
  @override
  void initState() {
    super.initState();
    _loadContingencyScenarios();
  }
  
  Future<void> _loadContingencyScenarios() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    
    setState(() {
      _scenarios.addAll([
        ContingencyScenario(
          title: 'Health Issues',
          description: 'In case of health emergencies or minor issues:',
          solutions: [
            'Carry basic first aid supplies for minor issues',
            'Pack extra prescription medications in original containers',
            'Save international emergency numbers in your phone',
            'Verify your travel insurance covers medical evacuation',
          ],
          icon: Icons.medical_services,
          category: 'Health',
        ),
        ContingencyScenario(
          title: 'Accommodation Issues',
          description: 'If your accommodations are unavailable or unsatisfactory:',
          solutions: [
            'Have contact info for booking platforms customer service',
            'Research backup accommodation options in the area',
            'Download offline maps of your destination',
            'Set aside emergency funds for last-minute booking needs',
          ],
          icon: Icons.hotel,
          category: 'Accommodation',
        ),
      ]);
      
      // Generate contingency data
      _contingencyData = {
        'scenariosAnalyzed': _scenarios.length,
        'contingencyPlansCreated': true,
        'emergencyContacts': {
          'insurance': 'Your policy number and 24/7 assistance number',
        },
        'recommendedApps': [
          'Maps.me (offline navigation)',
          'Google Translate (language support)',
          'XE Currency (currency conversion)',
          'TripIt (itinerary management)'
        ]
      };
      
      _isLoading = false;
    });
  }
  
  void _completeContingencyPlanning() {
    widget.onContingencyPlanningComplete(_contingencyData);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.fadeAnimation,
      child: SlideTransition(
        position: widget.slideAnimation,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Contingency Planning",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Let's prepare for unexpected situations that could arise during your trip to ${widget.selectedDestination}.",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Emergency contacts card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.2),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.error.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.emergency,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Emergency Contacts",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildContactItem(
                          "Travel Insurance",
                          _contingencyData['emergencyContacts']['insurance'],
                          Icons.health_and_safety,
                          context,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Scenarios
                  Text(
                    "Potential Scenarios",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  ...List.generate(_scenarios.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildScenarioCard(_scenarios[index], context),
                    );
                  }),
                  
                  const SizedBox(height: 24),
                  
                  // Recommended apps
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.app_shortcut,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Recommended Apps for Travel Safety",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(_contingencyData['recommendedApps'].length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.smartphone, size: 18),
                                const SizedBox(width: 8),
                                Text(_contingencyData['recommendedApps'][index]),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _completeContingencyPlanning,
                      icon: const Icon(Icons.check_circle),
                      label: const Text("Continue to Itinerary"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
  
  Widget _buildContactItem(String title, String value, IconData icon, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.error.withOpacity(0.8),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildScenarioCard(ContingencyScenario scenario, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: ExpansionTile(
        leading: Icon(
          scenario.icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          scenario.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          scenario.category,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scenario.description,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 12),
                ...scenario.solutions.map((solution) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(solution)),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Model for contingency scenarios
class ContingencyScenario {
  final String title;
  final String description;
  final List<String> solutions;
  final IconData icon;
  final String category;
  
  ContingencyScenario({
    required this.title,
    required this.description,
    required this.solutions,
    required this.icon,
    required this.category,
  });
}