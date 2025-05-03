import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuickTripForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onFormComplete;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const QuickTripForm({
    super.key,
    required this.onFormComplete,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  State<QuickTripForm> createState() => _QuickTripFormState();
}

class _QuickTripFormState extends State<QuickTripForm> {
  final _formKey = GlobalKey<FormState>();
  final _destinationController = TextEditingController();
  final _budgetController = TextEditingController();
  final _peopleController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String _tripType = 'leisure';
  String _accommodationType = 'hotel';

  @override
  void dispose() {
    _destinationController.dispose();
    _budgetController.dispose();
    _peopleController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? DateTime.now() : (_startDate ?? DateTime.now()),
      firstDate: isStartDate ? DateTime.now() : (_startDate ?? DateTime.now()),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select both start and end dates')),
        );
        return;
      }
      
      if (_endDate!.isBefore(_startDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End date must be after start date')),
        );
        return;
      }

      widget.onFormComplete({
        'destination': _destinationController.text,
        'budget': double.tryParse(_budgetController.text) ?? 0,
        'people': int.tryParse(_peopleController.text) ?? 1,
        'startDate': _startDate,
        'endDate': _endDate,
        'tripType': _tripType,
        'accommodationType': _accommodationType,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.fadeAnimation,
      child: SlideTransition(
        position: widget.slideAnimation,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Let's plan your trip!",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Fill in the essential details to get started",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                
                // Destination
                TextFormField(
                  controller: _destinationController,
                  decoration: const InputDecoration(
                    labelText: 'Where do you want to go?',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a destination';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Budget
                TextFormField(
                  controller: _budgetController,
                  decoration: const InputDecoration(
                    labelText: 'Total Budget (USD)',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your budget';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Number of People
                TextFormField(
                  controller: _peopleController,
                  decoration: const InputDecoration(
                    labelText: 'Number of Travelers',
                    prefixIcon: Icon(Icons.people_outline),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of travelers';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Trip Type
                DropdownButtonFormField<String>(
                  value: _tripType,
                  decoration: const InputDecoration(
                    labelText: 'Trip Type',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'leisure', child: Text('Leisure/Vacation')),
                    DropdownMenuItem(value: 'business', child: Text('Business')),
                    DropdownMenuItem(value: 'adventure', child: Text('Adventure')),
                    DropdownMenuItem(value: 'family', child: Text('Family')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _tripType = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                
                // Accommodation Type
                DropdownButtonFormField<String>(
                  value: _accommodationType,
                  decoration: const InputDecoration(
                    labelText: 'Preferred Accommodation',
                    prefixIcon: Icon(Icons.hotel_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'hotel', child: Text('Hotel')),
                    DropdownMenuItem(value: 'hostel', child: Text('Hostel')),
                    DropdownMenuItem(value: 'airbnb', child: Text('Airbnb')),
                    DropdownMenuItem(value: 'resort', child: Text('Resort')),
                    DropdownMenuItem(value: 'apartment', child: Text('Apartment')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _accommodationType = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                
                // Dates
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, true),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Start Date',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            _startDate != null
                                ? DateFormat('MMM dd, yyyy').format(_startDate!)
                                : 'Select date',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, false),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'End Date',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            _endDate != null
                                ? DateFormat('MMM dd, yyyy').format(_endDate!)
                                : 'Select date',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Start Planning'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 