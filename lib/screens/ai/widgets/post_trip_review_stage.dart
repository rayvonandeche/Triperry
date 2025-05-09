import 'package:flutter/material.dart';

/// Widget that displays the post-trip review phase of travel planning
class PostTripReviewStage extends StatefulWidget {
  /// The completed trip destination
  final String destination;
  
  /// Animation for slide effect
  final Animation<Offset> slideAnimation;
  
  /// Animation for fade effect
  final Animation<double> fadeAnimation;
  
  /// Callback when review is complete
  final Function(Map<String, dynamic>) onReviewComplete;

  const PostTripReviewStage({
    super.key,
    required this.destination,
    required this.slideAnimation,
    required this.fadeAnimation,
    required this.onReviewComplete,
  });

  @override
  State<PostTripReviewStage> createState() => _PostTripReviewStageState();
}

class _PostTripReviewStageState extends State<PostTripReviewStage> {
  final _formKey = GlobalKey<FormState>();
  
  // Review data
  double _overallRating = 4;
  double _accommodationRating = 4;
  double _transportationRating = 4;
  double _activitiesRating = 4;
  double _valueForMoneyRating = 4;
  
  String _highlight = '';
  String _improvement = '';
  List<String> _tags = [];
  
  final List<String> _availableTags = [
    'Adventure', 'Relaxation', 'Family', 'Romantic', 'Cultural', 
    'Nature', 'Historical', 'Food', 'Budget', 'Luxury',
  ];
  
  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // Simulate API call to save review
      await Future.delayed(const Duration(milliseconds: 500));
      
      final reviewData = {
        'destination': widget.destination,
        'overallRating': _overallRating,
        'categoryRatings': {
          'accommodation': _accommodationRating,
          'transportation': _transportationRating,
          'activities': _activitiesRating,
          'valueForMoney': _valueForMoneyRating,
        },
        'highlight': _highlight,
        'improvement': _improvement,
        'tags': _tags,
        'reviewDate': DateTime.now().toString(),
        'reviewCompleted': true,
      };
      
      widget.onReviewComplete(reviewData);
    }
  }
  
  void _toggleTag(String tag) {
    setState(() {
      if (_tags.contains(tag)) {
        _tags.remove(tag);
      } else {
        _tags.add(tag);
      }
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
              "Trip Review",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Tell us about your experience in ${widget.destination}. Your feedback helps improve future recommendations!",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            
            // Review form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overall rating
                  _buildRatingSection(
                    "Overall Experience",
                    _overallRating,
                    (value) {
                      setState(() {
                        _overallRating = value;
                      });
                    },
                    icon: Icons.star,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 16),
                  
                  // Divider
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  // Category ratings
                  Text(
                    "Category Ratings",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  _buildRatingSection(
                    "Accommodation",
                    _accommodationRating,
                    (value) {
                      setState(() {
                        _accommodationRating = value;
                      });
                    },
                    icon: Icons.hotel,
                  ),
                  const SizedBox(height: 8),
                  
                  _buildRatingSection(
                    "Transportation",
                    _transportationRating,
                    (value) {
                      setState(() {
                        _transportationRating = value;
                      });
                    },
                    icon: Icons.directions_bus,
                  ),
                  const SizedBox(height: 8),
                  
                  _buildRatingSection(
                    "Activities",
                    _activitiesRating,
                    (value) {
                      setState(() {
                        _activitiesRating = value;
                      });
                    },
                    icon: Icons.hiking,
                  ),
                  const SizedBox(height: 8),
                  
                  _buildRatingSection(
                    "Value for Money",
                    _valueForMoneyRating,
                    (value) {
                      setState(() {
                        _valueForMoneyRating = value;
                      });
                    },
                    icon: Icons.monetization_on,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Divider
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  // Open-ended feedback
                  Text(
                    "Your Feedback",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Trip highlight
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "What was the highlight of your trip?",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.favorite),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please share at least one highlight';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _highlight = value!;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Area for improvement
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "What could have been improved?",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.build),
                    ),
                    maxLines: 3,
                    onSaved: (value) {
                      _improvement = value ?? '';
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Tags
                  Text(
                    "Trip Tags",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Select tags that describe your trip",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableTags.map((tag) {
                      final isSelected = _tags.contains(tag);
                      
                      return FilterChip(
                        selected: isSelected,
                        label: Text(tag),
                        onSelected: (_) => _toggleTag(tag),
                        selectedColor: Theme.of(context).colorScheme.primaryContainer,
                        checkmarkColor: Theme.of(context).colorScheme.primary,
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _submitReview,
                      icon: const Icon(Icons.check_circle),
                      label: const Text("Submit Review"),
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
          ],
        ),
      ),
    );
  }
  
  Widget _buildRatingSection(String title, double rating, Function(double) onChanged, {IconData? icon, Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 20,
                color: color ?? Theme.of(context).colorScheme.primary,
              ),
            if (icon != null)
              const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              rating.toStringAsFixed(1),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color ?? Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: rating,
          min: 1,
          max: 5,
          divisions: 8,
          activeColor: color ?? Theme.of(context).colorScheme.primary,
          label: rating.toStringAsFixed(1),
          onChanged: onChanged,
        ),
      ],
    );
  }
}