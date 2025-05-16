import 'package:flutter/material.dart';
import 'package:triperry/theme/app_theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';
import '../../../../services/kenya_transport_data.dart';
import 'transport_detail_screen.dart';

void showTransportTypeSheet(BuildContext context, String transportType) {
  // Modal sheet removed as content already updates on category change
  // If we need additional options for each transport type in future, we can re-enable this
}

class Transport extends StatefulWidget {
  const Transport({super.key});

  @override
  State<Transport> createState() => _TransportPageState();
}

class _TransportPageState extends State<Transport> with SingleTickerProviderStateMixin {
  String _selectedCategory = 'All';
  final List<String> _categories = KenyaTransportData.transportCategories;
  
  // Search and filter fields
  final TextEditingController _searchController = TextEditingController();
  int _passengerCount = 1;
  String _selectedTripType = 'One-way';
  
  // Filtered transport items
  late List<Map<String, dynamic>> _filteredTransport;
  
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    // Initialize filtered transport with all transport
    _filteredTransport = KenyaTransportData.getAllTransport();
    
    // Auto-rotate animation to draw attention to the category selector
    Future.delayed(const Duration(seconds: 1), () {
      _animationController.repeat(reverse: true);
    });
  }
    @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }
  
  // Filter transport based on selected category and search query
  void _filterTransport() {
    List<Map<String, dynamic>> transport;
    
    // First filter by category
    if (_selectedCategory == 'All') {
      transport = KenyaTransportData.getAllTransport();
    } else {
      transport = KenyaTransportData.getAllTransport().where((item) => 
        item['type'] == _selectedCategory
      ).toList();
    }
    
    // Apply search filter if text is entered
    if (_searchController.text.isNotEmpty) {
      final searchQuery = _searchController.text.toLowerCase();
      transport = transport.where((item) => 
        item['title'].toString().toLowerCase().contains(searchQuery) ||
        item['description'].toString().toLowerCase().contains(searchQuery) ||
        (item['address']?.toString().toLowerCase() ?? '').contains(searchQuery)
      ).toList();
    }
    
    setState(() {
      _filteredTransport = transport;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return buildTransportContent();
  }

  Widget buildTransportContent() {
    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 80),
      children: [
        _buildSearchAndFilterSection(),
        const SizedBox(height: 16),
        _buildCarouselSection(),
        const SizedBox(height: 24),
        _buildSectionTitle('Transport Categories'),
        const SizedBox(height: 16),
        _buildCategoriesSection(),
        const SizedBox(height: 24),
        _buildSectionTitle('Popular Transfers'),
        const SizedBox(height: 16),
        _buildPopularSection(),
        const SizedBox(height: 24),
        _buildSectionTitle('Recommended Transport'),
        const SizedBox(height: 16),
        _buildRecommendedSection(),
      ],
    );
  }  // Build search and filter section at the top of the screen
  Widget _buildSearchAndFilterSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          // Search bar with location icon
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Icon(
                          Icons.location_on,
                          color: AppTheme.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Where are you going?',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            onChanged: (value) {
                              _filterTransport();
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.grey.shade600,
                          ),
                          onPressed: () {
                            // Implement search functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Searching for: ${_searchController.text}')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(color: Colors.grey.shade200),
          ),
          
          // Filter options
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                // Trip type selector
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _showTripTypeOptions(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.swap_horiz,
                            color: Colors.grey.shade700,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _selectedTripType,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                
                // Passenger count selector
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _showPassengerSelector(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.grey.shade700,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$_passengerCount ${_passengerCount == 1 ? 'passenger' : 'passengers'}',
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                
                // Filter button
                InkWell(
                  onTap: () {
                    _showFilterOptions(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.filter_list,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Show trip type options
  void _showTripTypeOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trip Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Radio<String>(
                value: 'One-way',
                groupValue: _selectedTripType,
                onChanged: (value) {
                  Navigator.pop(context);
                  setState(() {
                    _selectedTripType = value!;
                  });
                },
                activeColor: AppTheme.primaryColor,
              ),
              title: const Text('One-way'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedTripType = 'One-way';
                });
              },
            ),
            ListTile(
              leading: Radio<String>(
                value: 'Round-trip',
                groupValue: _selectedTripType,
                onChanged: (value) {
                  Navigator.pop(context);
                  setState(() {
                    _selectedTripType = value!;
                  });
                },
                activeColor: AppTheme.primaryColor,
              ),
              title: const Text('Round-trip'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedTripType = 'Round-trip';
                });
              },
            ),
            ListTile(
              leading: Radio<String>(
                value: 'Multi-city',
                groupValue: _selectedTripType,
                onChanged: (value) {
                  Navigator.pop(context);
                  setState(() {
                    _selectedTripType = value!;
                  });
                },
                activeColor: AppTheme.primaryColor,
              ),
              title: const Text('Multi-city'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedTripType = 'Multi-city';
                });
              },
            ),
          ],
        ),
      ),
    );
  }
  
  // Show passenger selector
  void _showPassengerSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Passengers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Adults',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: Icon(
                              Icons.remove,
                              size: 16,
                              color: _passengerCount > 1 ? AppTheme.primaryColor : Colors.grey,
                            ),
                          ),
                          onPressed: _passengerCount > 1
                              ? () {
                                  setModalState(() {
                                    _passengerCount--;
                                  });
                                  setState(() {});
                                }
                              : null,
                        ),
                        Text(
                          '$_passengerCount',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: Icon(
                              Icons.add,
                              size: 16,
                              color: _passengerCount < 10 ? AppTheme.primaryColor : Colors.grey,
                            ),
                          ),
                          onPressed: _passengerCount < 10
                              ? () {
                                  setModalState(() {
                                    _passengerCount++;
                                  });
                                  setState(() {});
                                }
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  // Show filter options
  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Options',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Price Range',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppTheme.primaryColor,
                thumbColor: AppTheme.primaryColor,
                overlayColor: AppTheme.primaryColor.withOpacity(0.2),
              ),
              child: RangeSlider(
                values: const RangeValues(1000, 10000),
                min: 0,
                max: 20000,
                divisions: 20,
                labels: const RangeLabels('KSh 1,000', 'KSh 10,000'),
                onChanged: (RangeValues values) {
                  // Implement price range filter
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Transport Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: KenyaTransportData.transportCategories
                  .where((category) => category != 'All')
                  .map((type) => FilterChip(
                        label: Text(type),
                        selected: _selectedCategory == type,
                        onSelected: (selected) {                          Navigator.pop(context);
                          setState(() {
                            _selectedCategory = selected ? type : 'All';
                            _filterTransport(); // Apply filtering when category is changed
                          });
                        },
                        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                        checkmarkColor: AppTheme.primaryColor,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Amenities',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'WiFi',
                'Meals',
                'Entertainment',
                'Luggage',
                'Air-conditioning'
              ]
                  .map((amenity) => FilterChip(
                        label: Text(amenity),
                        selected: false,
                        onSelected: (selected) {
                          // Implement amenity filter
                        },
                        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                        checkmarkColor: AppTheme.primaryColor,
                      ))
                  .toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Build carousel section with featured transport options
  Widget _buildCarouselSection() {
    final PageController _pageController = PageController(viewportFraction: 0.93);
    final List<Map<String, dynamic>> featuredTransport = KenyaTransportData.getFeaturedTransport();

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            itemCount: featuredTransport.length,
            itemBuilder: (context, index) {
              final transport = featuredTransport[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransportDetailScreen(
                        transport: transport,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        // Image
                        Image.asset(
                          transport['image'],
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                        ),
                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        // Content
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transport['title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  transport['description'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      transport['price'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'Book Now',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        SmoothPageIndicator(
          controller: _pageController,
          count: featuredTransport.length,
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            type: WormType.thin,
            activeDotColor: AppTheme.primaryColor,
            dotColor: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  // Categories section with horizontal scrolling
  Widget _buildCategoriesSection() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          
          // Get icon based on category
          IconData icon;
          switch (category) {
            case 'Cars': icon = Icons.directions_car; break;
            case 'Flights': icon = Icons.flight; break;
            case 'Trains': icon = Icons.train; break;
            case 'Boats': icon = Icons.directions_boat; break;
            case 'Safari': icon = Icons.terrain; break;
            default: icon = Icons.commute; break;
          }
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
                _filterTransport(); // Apply filter when category changes
              });
                // Category filtering happens automatically via _filterTransport()
            },
            child: Container(
              width: 100,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryColor : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 8,
                        )
                      ] : null,
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? AppTheme.primaryColor : Colors.grey.shade700,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }  // Popular transport options
  Widget _buildPopularSection() {
    // Use filtered transport if available, otherwise get popular transport
    final List<Map<String, dynamic>> popularTransfers = 
      _selectedCategory != 'All' ? _filteredTransport : KenyaTransportData.getPopularTransport();
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: popularTransfers.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final transfer = popularTransfers[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransportDetailScreen(
                    transport: transfer,
                  ),
                ),
              );
            },
            child: Container(
              width: 200,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    spreadRadius: 1,
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(
                      transfer['image'],
                      width: 200,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transfer['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          transfer['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              transfer['price'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 14,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  transfer['rating'].toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }  // Recommended transport options
  Widget _buildRecommendedSection() {
    // Use filtered transport if available, otherwise get recommended transport
    final List<Map<String, dynamic>> recommendedOptions = 
      _selectedCategory != 'All' ? _filteredTransport : KenyaTransportData.getRecommendedTransport();

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: recommendedOptions.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final transport = recommendedOptions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransportDetailScreen(
                    transport: transport,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                // Image
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                  child: Image.asset(
                    transport['image'],
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transport['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          transport['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              transport['price'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                transport['type'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
