import 'package:flutter/material.dart';

class QuickForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onComplete;

  const QuickForm({
    super.key,
    required this.onComplete,
  });

  @override
  State<QuickForm> createState() => _QuickFormState();
}

class _QuickFormState extends State<QuickForm> {
  final _formKey = GlobalKey<FormState>();
  String _tripType = 'leisure';
  String _destination = '';
  double _budget = 2000;
  DateTime _preferredDate = DateTime.now().add(const Duration(days: 30));
  int _duration = 7;
  int _travelers = 2;
  List<String> _interests = [];

  final List<String> _availableInterests = [
    'Beach & Relaxation',
    'Adventure & Sports',
    'Culture & History',
    'Food & Dining',
    'Shopping',
    'Nature & Wildlife',
    'Nightlife',
    'Family Activities',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Let\'s Plan Your Trip',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Fill in some basic details to help us personalize your experience',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              
              // Trip Type Selection
              Text(
                'What type of trip are you planning?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildTripTypeChip('leisure', 'Leisure'),
                  _buildTripTypeChip('business', 'Business'),
                  _buildTripTypeChip('adventure', 'Adventure'),
                  _buildTripTypeChip('family', 'Family'),
                ],
              ),
              const SizedBox(height: 24),

              // Destination Input
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Where would you like to go?',
                  hintText: 'Enter destination',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) => _destination = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a destination';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Budget Slider
              Text(
                'What\'s your budget?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _budget,
                      min: 500,
                      max: 10000,
                      divisions: 19,
                      label: '\$${_budget.toStringAsFixed(0)}',
                      onChanged: (value) {
                        setState(() => _budget = value);
                      },
                    ),
                  ),
                  Text(
                    '\$${_budget.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Date Selection
              Text(
                'When would you like to travel?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _preferredDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => _preferredDate = date);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 8),
                      Text(
                        '${_preferredDate.day}/${_preferredDate.month}/${_preferredDate.year}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Duration Selection
              Text(
                'How long will you stay?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _duration.toDouble(),
                      min: 1,
                      max: 30,
                      divisions: 29,
                      label: '$_duration days',
                      onChanged: (value) {
                        setState(() => _duration = value.toInt());
                      },
                    ),
                  ),
                  Text(
                    '$_duration days',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Number of Travelers
              Text(
                'How many people are traveling?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _travelers.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: '$_travelers travelers',
                      onChanged: (value) {
                        setState(() => _travelers = value.toInt());
                      },
                    ),
                  ),
                  Text(
                    '$_travelers travelers',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Interests Selection
              Text(
                'What are your interests?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableInterests.map((interest) {
                  final isSelected = _interests.contains(interest);
                  return FilterChip(
                    label: Text(interest),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _interests.add(interest);
                        } else {
                          _interests.remove(interest);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onComplete({
                        'tripType': _tripType,
                        'destination': _destination,
                        'budget': _budget,
                        'preferredDate': _preferredDate,
                        'duration': _duration,
                        'travelers': _travelers,
                        'interests': _interests,
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Start Planning'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripTypeChip(String value, String label) {
    final isSelected = _tripType == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _tripType = value);
      },
    );
  }
} 