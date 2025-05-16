import 'package:flutter/material.dart';
import 'package:triperry/theme/app_theme.dart';
import 'package:triperry/screens/discover/pages/pages.dart';
import 'pages/restaurant/restaurant.dart';
import 'pages/accommodation/accommodation.dart';

class DiscoverPage extends StatefulWidget{
  final double toolbarHeight;
  final List<Animation<double>> scaleAnimations;
  final List<Animation<double>> fadeAnimations;
  final AnimationController containerController;

  const DiscoverPage({
    super.key,
    required this.toolbarHeight,
    required this.scaleAnimations,
    required this.fadeAnimations,
    required this.containerController,
  });

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  late final ScrollController _scrollController;
  bool _isLoading = false;
  
  // Categories for the top scrollable list
  final List<String> _categories = [
    'Restaurant',
    'Accommodation',
    'Transport',
    'Activities',
    'Packages',
  ];
  
  // Track selected category (index)
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }  // Method to build content based on selected category
  Widget _buildCategoryContent(int index) {
    switch (index) {
      case 0: // Featured
        return const Restaurant();
      case 1: // Accommodation
        return const Accommodation();
      case 2: // Transport
        return buildTransportContent();
      case 3: // Activities
        return buildActivitiesContent();
      case 4: // Packages
        return buildPackagesContent();
      default:
        return const Restaurant();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Add top spacing for the AppBar
          SizedBox(height: widget.toolbarHeight),
          
          // Category selection (horizontal scrollable list)
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedCategoryIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? 
                      AppTheme.primaryColor : 
                      (Theme.of(context).brightness == Brightness.dark ? 
                        Colors.grey[800] : Colors.grey[200]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      )
                    ] : null,
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Center(
                      child: Text(
                        _categories[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : 
                            (Theme.of(context).brightness == Brightness.dark ? 
                              Colors.white : Colors.black),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Content area that changes based on selected category
          Expanded(
            child: _buildCategoryContent(_selectedCategoryIndex),
          ),
          
          // Loading indicator
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
