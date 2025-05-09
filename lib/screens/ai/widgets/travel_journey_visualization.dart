import 'package:flutter/material.dart';
import '../models/travel_planning_models.dart';

/// Widget that displays a visual representation of the travel planning journey
class TravelJourneyVisualization extends StatelessWidget {
  /// The current stage in the journey
  final TravelStage currentStage;
  
  /// Callback when a user taps on a phase
  final Function(TravelPlannerPhase)? onPhaseSelected;
  
  /// The data collected during the travel planning process
  final TravelPlanningData planningData;
  
  /// Whether to show the phases as cards (true) or a timeline (false)
  final bool showAsCards;
  
  const TravelJourneyVisualization({
    super.key,
    required this.currentStage,
    required this.planningData,
    this.onPhaseSelected,
    this.showAsCards = false,
  });

  @override
  Widget build(BuildContext context) {
    if (showAsCards) {
      return _buildPhasesAsCards(context);
    } else {
      return _buildPhasesAsTimeline(context);
    }
  }
  
  Widget _buildPhasesAsCards(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: TravelPlannerPhase.allPhases.length,
      itemBuilder: (context, index) {
        final phase = TravelPlannerPhase.allPhases[index];
        final isCurrentPhase = phase.containsStage(currentStage);
        final isCompleted = _isPhaseCompleted(phase);
        final isActive = isCurrentPhase || isCompleted;
        
        return InkWell(
          onTap: isActive && onPhaseSelected != null ? () => onPhaseSelected!(phase) : null,
          borderRadius: BorderRadius.circular(12),
          child: Card(
            elevation: isCurrentPhase ? 4 : 1,
            shadowColor: isCurrentPhase ? phase.color.withOpacity(0.5) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isCurrentPhase 
                ? BorderSide(color: phase.color, width: 2)
                : BorderSide.none,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isActive ? phase.color.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          phase.icon,
                          color: isActive ? phase.color : Colors.grey,
                          size: 24,
                        ),
                      ),
                      if (isCompleted)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    phase.title,
                    style: TextStyle(
                      fontWeight: isCurrentPhase ? FontWeight.bold : FontWeight.normal,
                      color: isActive ? null : Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (isActive) 
                    Text(
                      phase.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isActive 
                          ? Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7)
                          : Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildPhasesAsTimeline(BuildContext context) {
    return Column(
      children: [
        // Progress indicator
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: TravelPlannerPhase.getProgressPercentage(currentStage),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        
        // Timeline
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(TravelPlannerPhase.allPhases.length * 2 - 1, (index) {
              // Even indices are nodes, odd indices are connectors
              if (index.isEven) {
                final phaseIndex = index ~/ 2;
                final phase = TravelPlannerPhase.allPhases[phaseIndex];
                final isCurrentPhase = phase.containsStage(currentStage);
                final isCompleted = _isPhaseCompleted(phase);
                final isActive = isCurrentPhase || isCompleted;
                final currentPhaseColor = isActive ? phase.color : Colors.grey.shade300;
                
                return InkWell(
                  onTap: isActive && onPhaseSelected != null ? () => onPhaseSelected!(phase) : null,
                  borderRadius: BorderRadius.circular(50),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: currentPhaseColor.withOpacity(isActive ? 0.2 : 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: currentPhaseColor,
                            width: isCurrentPhase ? 2 : 1,
                          ),
                        ),
                        child: isCompleted
                            ? Icon(
                                Icons.check,
                                color: currentPhaseColor,
                                size: 18,
                              )
                            : Center(
                                child: Text(
                                  (phaseIndex + 1).toString(),
                                  style: TextStyle(
                                    color: currentPhaseColor,
                                    fontWeight: isCurrentPhase ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 60),
                        child: Text(
                          phase.title,
                          style: TextStyle(
                            fontSize: 10,
                            color: isActive ? currentPhaseColor : Colors.grey,
                            fontWeight: isCurrentPhase ? FontWeight.bold : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                final prevPhaseIndex = index ~/ 2;
                final prevPhase = TravelPlannerPhase.allPhases[prevPhaseIndex];
                final nextPhase = TravelPlannerPhase.allPhases[prevPhaseIndex + 1];
                final isPrevCompleted = _isPhaseCompleted(prevPhase);
                
                return Expanded(
                  child: Container(
                    height: 2,
                    color: isPrevCompleted ? prevPhase.color : Colors.grey.shade300,
                  ),
                );
              }
            }),
          ),
        ),
      ],
    );
  }
  
  bool _isPhaseCompleted(TravelPlannerPhase phase) {
    // Check if all stages in this phase are completed
    if (phase.stages.contains(TravelStage.welcome) && 
        planningData.destination != null && 
        planningData.travelTime != null && 
        planningData.budget != null) {
      return true;
    }
    if (phase.stages.contains(TravelStage.researchPhase) && planningData.isResearchComplete) {
      return true;
    }
    if (phase.stages.contains(TravelStage.contingencyPlanning) && 
        planningData.isContingencyPlanningComplete &&
        planningData.isItineraryComplete) {
      return true;
    }
    if (phase.stages.contains(TravelStage.bookingPhase) && planningData.isBookingComplete) {
      return true;
    }
    if (phase.stages.contains(TravelStage.executionPhase) && planningData.isExecutionComplete) {
      return true;
    }
    if (phase.stages.contains(TravelStage.monitoringPhase) && planningData.isMonitoringComplete) {
      return true;
    }
    if (phase.stages.contains(TravelStage.reviewPhase) && planningData.isReviewComplete) {
      return true;
    }
    if (phase.stages.contains(TravelStage.complete) && 
        planningData.isResearchComplete &&
        planningData.isContingencyPlanningComplete &&
        planningData.isItineraryComplete &&
        planningData.isBookingComplete &&
        planningData.isExecutionComplete &&
        planningData.isMonitoringComplete &&
        planningData.isReviewComplete) {
      return true;
    }
    
    // If we get here, the phase is not completed
    return false;
  }
}