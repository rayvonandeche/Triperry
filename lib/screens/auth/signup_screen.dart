import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:triperry/services/auth_service.dart';
import 'package:triperry/theme/app_theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 2; // Reduced from 3 to 2 pages
  
  // Travel preferences
  String _travelStyle = 'Adventure';
  final List<String> _selectedDestinations = [];
  String _budgetRange = 'Mid-range';
  String _travelFrequency = 'Quarterly';
  String _dietaryRestrictions = 'None';
  String _accommodationPreference = 'Mid-range hotels';
  int _travelers = 2;
  
  // Payment information (added)
  String _paymentMethod = 'Credit Card';
  final List<String> _paymentMethods = ['Credit Card', 'Debit Card', 'PayPal', 'Mobile Money', 'Apple Pay', 'Google Pay'];
  bool _hasAcceptedTerms = true;
  
  // Lists for dropdowns
  final List<String> _travelStyles = ['Adventure', 'Relaxation', 'Cultural', 'Luxury', 'Budget', 'Family'];
  final List<String> _destinations = ['Beach', 'Mountains', 'City', 'Countryside', 'Safari', 'Island', 'Cultural', 'Historical'];
  final List<String> _budgetRanges = ['Budget', 'Mid-range', 'Premium', 'Luxury'];
  final List<String> _travelFrequencies = ['Rarely (Annually)', 'Occasionally (Bi-annually)', 'Quarterly', 'Monthly', 'Frequently'];
  final List<String> _dietaryOptions = ['None', 'Vegetarian', 'Vegan', 'Gluten-free', 'Halal', 'Kosher', 'Allergies'];
  final List<String> _accommodationPreferences = ['Budget hostels', 'Mid-range hotels', 'Luxury resorts', 'Vacation rentals', 'All-inclusive'];
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage == 0) {
      // Validate first page form
      if (_formKey.currentState!.validate()) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentPage++;
        });
      }
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentPage--;
    });
  }

  Future<void> _signup() async {
    // Create travel preferences map
    final Map<String, dynamic> travelPreferences = {
      'travelStyle': _travelStyle,
      'preferredDestinations': _selectedDestinations,
      'budgetRange': _budgetRange,
      'travelFrequency': _travelFrequency,
      'dietaryRestrictions': _dietaryRestrictions,
      'accommodationPreference': _accommodationPreference,
      'travelers': _travelers,
      'paymentMethod': _paymentMethod, // Added payment method
    };

    final authService = Provider.of<AuthService>(context, listen: false);
    
    final success = await authService.signup(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
      travelPreferences,
    );
    
    if (!mounted) return;    if (success) {
      // Navigate to AI screen, replacing the login screen
      Navigator.of(context).pushReplacementNamed('/ai');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email already in use or registration failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  _buildAppBar(),
                  _buildProgressIndicator(),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildBasicInfoPage(),
                        _buildTravelPreferencesPage(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            Colors.white,
          ],
          stops: const [0.0, 0.6],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          if (_currentPage > 0)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _previousPage,
            ),
          const Spacer(),
          Text(
            'Create Account',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Login',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _pageTitle(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.darkText.withOpacity(0.7),
                ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (_currentPage + 1) / _totalPages,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
              color: AppTheme.primaryColor,
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _pageTitle() {
    switch (_currentPage) {
      case 0:
        return 'Basic Information';
      case 1:
        return 'Travel Preferences';
      default:
        return '';
    }
  }

  Widget _buildBasicInfoPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Full name field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your name',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Email field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Password field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Create a password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Confirm password field
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Confirm your password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              
              // Next button
              ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTravelPreferencesPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Travel style dropdown
            _buildDropdownField(
              label: 'Travel Style',
              value: _travelStyle,
              items: _travelStyles,
              onChanged: (value) {
                setState(() {
                  _travelStyle = value!;
                });
              },
              icon: Icons.style,
            ),
            const SizedBox(height: 20),
            
            // Preferred destinations multi-select
            Text(
              'Preferred Destinations',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.darkText.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _destinations.map((destination) {
                final isSelected = _selectedDestinations.contains(destination);
                return FilterChip(
                  label: Text(destination),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedDestinations.add(destination);
                      } else {
                        _selectedDestinations.remove(destination);
                      }
                    });
                  },
                  backgroundColor: Colors.white,
                  selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                  checkmarkColor: AppTheme.primaryColor,
                  side: BorderSide(
                    color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            
            // Budget range dropdown
            _buildDropdownField(
              label: 'Budget Range',
              value: _budgetRange,
              items: _budgetRanges,
              onChanged: (value) {
                setState(() {
                  _budgetRange = value!;
                });
              },
              icon: Icons.account_balance_wallet_outlined,
            ),
            const SizedBox(height: 20),
            
            // Travel frequency dropdown
            _buildDropdownField(
              label: 'How often do you travel?',
              value: _travelFrequency,
              items: _travelFrequencies,
              onChanged: (value) {
                setState(() {
                  _travelFrequency = value!;
                });
              },
              icon: Icons.calendar_today_outlined,
            ),
            const SizedBox(height: 20),
            
            // Payment method dropdown (added)
            _buildDropdownField(
              label: 'Payment Method',
              value: _paymentMethod,
              items: _paymentMethods,
              onChanged: (value) {
                setState(() {
                  _paymentMethod = value!;
                });
              },
              icon: Icons.payment_outlined,
            ),
            const SizedBox(height: 32),
            
            // Terms and conditions checkbox
            Row(
              children: [
                Checkbox(
                  value: _hasAcceptedTerms,
                  activeColor: AppTheme.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      _hasAcceptedTerms = value!;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    'I agree to the Terms of Service and Privacy Policy',
                    style: TextStyle(
                      color: AppTheme.darkText.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Create account button
            Consumer<AuthService>(
              builder: (context, authService, _) {
                return ElevatedButton(
                  onPressed: authService.isLoading ? null : _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: authService.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.darkText.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              icon: const Icon(Icons.arrow_drop_down),
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              borderRadius: BorderRadius.circular(12),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      Icon(icon, color: Colors.grey),
                      const SizedBox(width: 12),
                      Text(item),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
