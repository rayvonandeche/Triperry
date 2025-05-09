import 'package:flutter/material.dart';

/// Widget that displays the post-trip review phase of the travel planning process
class PostTripReviewWidget extends StatefulWidget {
  /// The selected destination
  final String selectedDestination;
  
  /// Full itinerary data from previous phases
  final Map<String, dynamic> itineraryData;
  
  /// Animation for fade effect
  final Animation<double> fadeAnimation;
  
  /// Animation for slide effect
  final Animation<Offset> slideAnimation;
  
  /// Callback when review is complete
  final Function(Map<String, dynamic>) onReviewComplete;

  const PostTripReviewWidget({
    super.key,
    required this.selectedDestination,
    required this.itineraryData,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.onReviewComplete,
  });

  @override
  State<PostTripReviewWidget> createState() => _PostTripReviewWidgetState();
}

class _PostTripReviewWidgetState extends State<PostTripReviewWidget> {
  double _overallRating = 0;
  double _accommodationRating = 0;
  double _activitiesRating = 0;
  double _foodRating = 0;
  double _transportationRating = 0;
  
  final TextEditingController _highlightsController = TextEditingController();
  final TextEditingController _improvementsController = TextEditingController();
  
  final Map<String, dynamic> _reviewData = {};
  bool _isSubmitting = false;
  
  @override
  void dispose() {
    _highlightsController.dispose();
    _improvementsController.dispose();
    super.dispose();
  }
  
  void _submitReview() {
    setState(() {
      _isSubmitting = true;
    });
    
    // Prepare review data
    _reviewData['ratings'] = {
      'overall': _overallRating,
      'accommodation': _accommodationRating,
      'activities': _activitiesRating,
      'food': _foodRating,
      'transportation': _transportationRating,
    };
    
    _reviewData['feedback'] = {
      'highlights': _highlightsController.text,
      'improvements': _improvementsController.text,
    };
    
    _reviewData['timestamp'] = DateTime.now().toIso8601String();
    _reviewData['destination'] = widget.selectedDestination;
    
    // Simulate network delay
    Future.delayed(const Duration(seconds: 1), () {
      widget.onReviewComplete(_reviewData);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.fadeAnimation,
      child: SlideTransition(
        position: widget.slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Trip Review & Feedback",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Share your thoughts about your trip to ${widget.selectedDestination} to help us improve future recommendations.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            
            // Overall rating
            _buildRatingSection(
              "Overall Experience",
              "How would you rate your overall trip experience?",
              _overallRating,
              (rating) => setState(() => _overallRating = rating),
              context,
            ),
            
            const Divider(height: 32),
            
            // Accommodation rating
            _buildRatingSection(
              "Accommodation",
              "How satisfied were you with your accommodations?",
              _accommodationRating,
              (rating) => setState(() => _accommodationRating = rating),
              context,
            ),
            
            const SizedBox(height: 24),
            
            // Activities rating
            _buildRatingSection(
              "Activities & Excursions",
              "How enjoyable were the activities in your itinerary?",
              _activitiesRating,
              (rating) => setState(() => _activitiesRating = rating),
              context,
            ),
            
            const SizedBox(height: 24),
            
            // Food rating
            _buildRatingSection(
              "Food & Dining",
              "How was your dining experience during the trip?",
              _foodRating,
              (rating) => setState(() => _foodRating = rating),
              context,
            ),
            
            const SizedBox(height: 24),
            
            // Transportation rating
            _buildRatingSection(
              "Transportation",
              "How convenient was transportation during your trip?",
              _transportationRating,
              (rating) => setState(() => _transportationRating = rating),
              context,
            ),
            
            const Divider(height: 32),
            
            // Highlights text field
            Text(
              "Trip Highlights",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "What were the best parts of your trip?",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _highlightsController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Share your favorite moments...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Improvements text field
            Text(
              "Suggestions for Improvement",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "What could have been better?",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _improvementsController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Share what could be improved...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Submit button
            Center(
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReview,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: _isSubmitting
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text("Submitting..."),
                        ],
                      )
                    : const Text("Submit Review"),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Privacy note
            Center(
              child: Text(
                "Your feedback helps us improve future trip recommendations",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRatingSection(
    String title,
    String description,
    double rating,
    Function(double) onRatingChanged,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: rating,
                min: 0,
                max: 5,
                divisions: 10,
                label: rating.toStringAsFixed(1),
                onChanged: onRatingChanged,
              ),
            ),
            Container(
              width: 48,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  rating.toStringAsFixed(1),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Poor",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                "Excellent",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}