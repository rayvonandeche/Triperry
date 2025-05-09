import 'package:flutter/material.dart';
import 'dart:math';
import '../models/ai_models.dart';

class ResearchAnalysisWidget extends StatefulWidget {
  /// The selected destination
  final String destination;
  
  /// Animation for fade effect
  final Animation<double> fadeAnimation;
  
  /// Animation for slide effect
  final Animation<Offset> slideAnimation;
  
  /// Callback when research is complete
  final Function(Map<String, dynamic>) onResearchComplete;

  const ResearchAnalysisWidget({
    super.key,
    required this.destination,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.onResearchComplete,
  });

  @override
  State<ResearchAnalysisWidget> createState() => _ResearchAnalysisWidgetState();
}

class _ResearchAnalysisWidgetState extends State<ResearchAnalysisWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  final Map<String, dynamic> _researchData = {};
  final List<String> _savedItems = [];
  
  // Research categories
  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Overview',
      'icon': Icons.info_outline,
      'color': Colors.blue,
    },
    {
      'title': 'Attractions',
      'icon': Icons.place_outlined,
      'color': Colors.green,
    },
    {
      'title': 'Transportation',
      'icon': Icons.directions_car_outlined,
      'color': Colors.orange,
    },
    {
      'title': 'Accommodations',
      'icon': Icons.hotel_outlined,
      'color': Colors.purple,
    },
    {
      'title': 'Food & Drink',
      'icon': Icons.restaurant_outlined,
      'color': Colors.red,
    },
    {
      'title': 'Local Customs',
      'icon': Icons.people_outlined,
      'color': Colors.teal,
    },
    {
      'title': 'Safety & Risks',
      'icon': Icons.shield_outlined,
      'color': Colors.amber,
    }
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    // Simulate loading data from API
    _loadResearchData();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  void _loadResearchData() {
    // In a real app, this would be a API call or database query
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      
      // Generate mock research data
      final overviewData = _generateOverviewData();
      final attractionsData = _generateAttractionsData();
      final transportationData = _generateTransportationData();
      final accommodationsData = _generateAccommodationsData();
      final foodData = _generateFoodData();
      final customsData = _generateLocalCustomsData();
      final safetyData = _generateSafetyData();
      
      setState(() {
        _researchData['overview'] = overviewData;
        _researchData['attractions'] = attractionsData;
        _researchData['transportation'] = transportationData;
        _researchData['accommodations'] = accommodationsData;
        _researchData['food'] = foodData;
        _researchData['customs'] = customsData;
        _researchData['safety'] = safetyData;
        _isLoading = false;
      });
    });
  }
  
  Map<String, dynamic> _generateOverviewData() {
    return {
      'description': '${widget.destination} is a fantastic travel destination known for its unique culture, beautiful landscapes, and warm hospitality. The best time to visit is typically during the shoulder seasons when crowds are fewer and prices are lower.',
      'bestTimeToVisit': 'March-May and September-November',
      'language': _getRandomLanguage(),
      'currency': _getRandomCurrency(),
      'timeZone': 'GMT${Random().nextBool() ? "+" : "-"}${Random().nextInt(12)}',
      'visaRequirements': Random().nextBool() ? 'Visa required' : 'Visa-free for stays up to 90 days',
      'weather': {
        'summer': '75°F - 90°F (24°C - 32°C), Sunny with occasional rain',
        'fall': '55°F - 75°F (13°C - 24°C), Mild and pleasant',
        'winter': '40°F - 60°F (4°C - 16°C), Cool with some precipitation',
        'spring': '60°F - 80°F (16°C - 27°C), Warming up with occasional showers'
      },
    };
  }
  
  List<Map<String, dynamic>> _generateAttractionsData() {
    final attractions = [
      {
        'name': '${widget.destination} Historical Museum',
        'description': 'An impressive museum showcasing the rich history and cultural heritage of the region.',
        'rating': 4.7,
        'price': '\$15',
        'openingHours': '9 AM - 6 PM',
        'imageUrl': 'https://picsum.photos/id/${30 + Random().nextInt(20)}/300/200',
        'tags': ['Cultural', 'Indoor', 'Family-friendly'],
      },
      {
        'name': '${widget.destination.split(",")[0]} National Park',
        'description': 'Stunning natural landscapes with hiking trails, wildlife, and breathtaking viewpoints.',
        'rating': 4.9,
        'price': '\$10',
        'openingHours': '8 AM - Sunset',
        'imageUrl': 'https://picsum.photos/id/${50 + Random().nextInt(20)}/300/200',
        'tags': ['Nature', 'Outdoor', 'Photography'],
      },
      {
        'name': 'Central Market',
        'description': 'Vibrant local market offering fresh produce, crafts, and regional specialties.',
        'rating': 4.5,
        'price': 'Free',
        'openingHours': '7 AM - 8 PM',
        'imageUrl': 'https://picsum.photos/id/${70 + Random().nextInt(20)}/300/200',
        'tags': ['Shopping', 'Food', 'Cultural'],
      },
      {
        'name': 'Old Town Square',
        'description': 'Historic plaza surrounded by architectural gems and lively cafes.',
        'rating': 4.8,
        'price': 'Free',
        'openingHours': '24/7',
        'imageUrl': 'https://picsum.photos/id/${90 + Random().nextInt(20)}/300/200',
        'tags': ['Sightseeing', 'Architecture', 'Photography'],
      },
      {
        'name': 'Coastal Walking Trail',
        'description': 'Scenic pathway along the coast with spectacular views and quiet beaches.',
        'rating': 4.6,
        'price': 'Free',
        'openingHours': 'Sunrise to Sunset',
        'imageUrl': 'https://picsum.photos/id/${110 + Random().nextInt(20)}/300/200',
        'tags': ['Nature', 'Outdoor', 'Free'],
      },
    ];
    
    return attractions;
  }
  
  List<Map<String, dynamic>> _generateTransportationData() {
    return [
      {
        'type': 'Public Transit',
        'description': '${widget.destination} has an efficient public transportation system including buses, trams, and metro lines connecting major attractions.',
        'cost': 'Single ride: \$2-3, Day pass: \$10',
        'tips': 'Purchase a rechargeable transit card for convenience and discounted fares.',
        'reliability': 'High',
      },
      {
        'type': 'Taxi',
        'description': 'Taxis are readily available and can be hailed on the street or booked through apps.',
        'cost': 'Base fare: \$5, \$1-2 per km',
        'tips': 'Always ensure the meter is running or negotiate the fare before starting your journey.',
        'reliability': 'Medium',
      },
      {
        'type': 'Car Rental',
        'description': 'Multiple car rental agencies are available at the airport and city center.',
        'cost': '\$30-70 per day depending on vehicle type',
        'tips': 'International driving permit may be required. Parking can be challenging in the city center.',
        'reliability': 'High',
      },
      {
        'type': 'Walking',
        'description': 'The central areas of ${widget.destination.split(",")[0]} are very walkable with pedestrian-friendly streets.',
        'cost': 'Free',
        'tips': 'Download an offline map for easy navigation.',
        'reliability': 'High',
      },
      {
        'type': 'Bike Rental',
        'description': 'Bike sharing programs and rental shops are popular options for exploring the city.',
        'cost': '\$10-15 per day',
        'tips': 'Check for dedicated bike lanes and always lock your bike when not in use.',
        'reliability': 'Medium',
      },
    ];
  }
  
  List<Map<String, dynamic>> _generateAccommodationsData() {
    return [
      {
        'type': 'Luxury Hotels',
        'priceRange': '\$200-500 per night',
        'description': '5-star accommodations with premium amenities and exceptional service.',
        'locations': 'Downtown, Waterfront District',
        'recommendations': ['Grand ${widget.destination} Hotel', 'Royal Plaza Hotel', 'Luxury Suites'],
        'imageUrl': 'https://picsum.photos/id/${130 + Random().nextInt(20)}/300/200',
      },
      {
        'type': 'Mid-range Hotels',
        'priceRange': '\$100-200 per night',
        'description': 'Comfortable 3-4 star hotels with good amenities and locations.',
        'locations': 'City Center, Business District',
        'recommendations': ['City View Hotel', 'Comfort Inn ${widget.destination}', 'Plaza Hotel'],
        'imageUrl': 'https://picsum.photos/id/${150 + Random().nextInt(20)}/300/200',
      },
      {
        'type': 'Budget Hotels',
        'priceRange': '\$50-100 per night',
        'description': 'Basic accommodations with essential amenities at affordable prices.',
        'locations': 'Suburban areas, Public Transit routes',
        'recommendations': ['Economy Inn', 'Budget Stay', 'Traveler\'s Lodge'],
        'imageUrl': 'https://picsum.photos/id/${170 + Random().nextInt(20)}/300/200',
      },
      {
        'type': 'Hostels',
        'priceRange': '\$20-40 per night',
        'description': 'Shared and private rooms with common spaces, popular with backpackers.',
        'locations': 'Near attractions, Historic district',
        'recommendations': ['Backpackers Paradise', 'Youth Hostel', 'Adventure Stay'],
        'imageUrl': 'https://picsum.photos/id/${190 + Random().nextInt(20)}/300/200',
      },
      {
        'type': 'Vacation Rentals',
        'priceRange': '\$80-300 per night',
        'description': 'Apartments, houses, and unique stays available through platforms like Airbnb.',
        'locations': 'Throughout the city and suburbs',
        'recommendations': ['Use trusted platforms and read reviews carefully'],
        'imageUrl': 'https://picsum.photos/id/${210 + Random().nextInt(20)}/300/200',
      },
    ];
  }
  
  List<Map<String, dynamic>> _generateFoodData() {
    return [
      {
        'name': 'Local Specialties',
        'description': 'Traditional dishes unique to ${widget.destination} that showcase local ingredients and cooking techniques.',
        'mustTry': ['Regional Specialty Dish', 'Traditional Stew', 'Local Street Food'],
        'priceRange': '\$5-15 per dish',
        'recommendations': ['Old Town Kitchen', 'Traditional Restaurant', 'Local Tavern'],
        'imageUrl': 'https://picsum.photos/id/${230 + Random().nextInt(20)}/300/200',
      },
      {
        'name': 'Fine Dining',
        'description': 'Upscale restaurants offering gourmet cuisine and exceptional service.',
        'mustTry': ['Chef\'s Tasting Menu', 'Local Delicacies with Modern Twist'],
        'priceRange': '\$50-150 per person',
        'recommendations': ['Gourmet ${widget.destination.split(",")[0]}', 'Michelin Star Restaurant', 'Sunset Terrace'],
        'imageUrl': 'https://picsum.photos/id/${250 + Random().nextInt(20)}/300/200',
      },
      {
        'name': 'Street Food',
        'description': 'Authentic and affordable local cuisine from vendors and food markets.',
        'mustTry': ['Popular Street Snack', 'Local Sandwich', 'Sweet Pastry'],
        'priceRange': '\$2-8 per item',
        'recommendations': ['Food Market', 'Night Market', 'Food Truck Area'],
        'imageUrl': 'https://picsum.photos/id/${270 + Random().nextInt(20)}/300/200',
      },
      {
        'name': 'Cafes & Bakeries',
        'description': 'Perfect spots for breakfast, coffee, and pastries.',
        'mustTry': ['Local Coffee Style', 'Regional Pastry', 'Breakfast Special'],
        'priceRange': '\$3-10 per item',
        'recommendations': ['Historic Café', 'Artisan Bakery', 'Riverside Coffee Shop'],
        'imageUrl': 'https://picsum.photos/id/${290 + Random().nextInt(20)}/300/200',
      },
      {
        'name': 'International Cuisine',
        'description': 'Restaurants offering global flavors and dishes from around the world.',
        'mustTry': ['Fusion Dishes', 'International Favorites'],
        'priceRange': '\$10-30 per dish',
        'recommendations': ['World Bistro', 'International Food Court', 'Global Cuisine Center'],
        'imageUrl': 'https://picsum.photos/id/${310 + Random().nextInt(20)}/300/200',
      },
    ];
  }
  
  Map<String, dynamic> _generateLocalCustomsData() {
    return {
      'etiquette': [
        'Greeting: ${Random().nextBool() ? "Handshakes are common" : "Bow slightly when meeting someone"}',
        'Tipping: ${Random().nextBool() ? "10-15% in restaurants" : "Not customary, service is included"}',
        'Photography: Always ask permission before taking photos of locals',
        'Shoes: ${Random().nextBool() ? "Remove shoes when entering homes and temples" : "Keep shoes on in most places"}',
      ],
      'customs': [
        '${widget.destination.split(",")[0]} has a strong tradition of afternoon breaks/siestas',
        'Local festivals occur throughout the year, featuring traditional music and dance',
        'Markets typically operate from early morning until midday',
      ],
      'taboos': [
        'Avoid discussing sensitive political topics',
        'Public displays of affection may be frowned upon',
        'Pointing with your finger or foot is considered rude',
      ],
      'phrases': {
        'Hello': Random().nextBool() ? 'Hola' : 'Konnichiwa',
        'Thank you': Random().nextBool() ? 'Gracias' : 'Arigato',
        'Please': Random().nextBool() ? 'Por favor' : 'Onegaishimasu',
        'Excuse me': Random().nextBool() ? 'Perdón' : 'Sumimasen',
      },
      'businessHours': 'Most shops open 9 AM - 7 PM, with some closures during midday in smaller towns.'
    };
  }
  
  Map<String, dynamic> _generateSafetyData() {
    return {
      'overallSafety': Random().nextInt(3) == 0 ? 'High' : 'Medium',
      'emergencyNumbers': {
        'Police': '${Random().nextInt(900) + 100}',
        'Ambulance': '${Random().nextInt(900) + 100}',
        'Tourist Police': '${Random().nextInt(900) + 100}',
      },
      'healthConcerns': [
        Random().nextBool() ? 'Tap water is safe to drink' : 'Use bottled water for drinking',
        'Medical facilities are ${Random().nextBool() ? "excellent in major cities" : "adequate but limited in rural areas"}',
        'Travel insurance with medical coverage is recommended',
      ],
      'commonScams': [
        'Overpriced taxi rides from airports',
        'Unofficial "guides" offering services at major attractions',
        '"Free" items that actually require payment later',
      ],
      'areasToAvoid': [
        'Some suburban areas after dark',
        'Isolated beaches at night',
        'Crowded tourist areas - watch for pickpockets',
      ],
      'weatherRisks': Random().nextBool() 
          ? 'Hurricane season from June to November' 
          : 'Heavy rainfall may cause flooding during monsoon season',
    };
  }
  
  String _getRandomLanguage() {
    final languages = ['Spanish', 'French', 'Japanese', 'Italian', 'Thai', 'German', 'Portuguese'];
    return '${languages[Random().nextInt(languages.length)]}, English widely spoken in tourist areas';
  }
  
  String _getRandomCurrency() {
    final currencies = ['Euro (EUR)', 'US Dollar (USD)', 'Japanese Yen (JPY)', 'British Pound (GBP)', 'Thai Baht (THB)'];
    return currencies[Random().nextInt(currencies.length)];
  }
  
  void _toggleSaveItem(String category, String itemTitle) {
    final saveId = '$category:$itemTitle';
    setState(() {
      if (_savedItems.contains(saveId)) {
        _savedItems.remove(saveId);
      } else {
        _savedItems.add(saveId);
      }
    });
  }
  
  bool _isItemSaved(String category, String itemTitle) {
    return _savedItems.contains('$category:$itemTitle');
  }
  
  void _submitResearch() {
    final researchSummary = {
      'destination': widget.destination,
      'researchCompleted': true,
      'savedItems': _savedItems,
      'overviewNotes': _researchData['overview'],
      'savedAttractions': _getSavedItemsOfCategory('attractions'),
      'savedAccommodations': _getSavedItemsOfCategory('accommodations'),
      'savedTransportation': _getSavedItemsOfCategory('transportation'),
      'savedFoodOptions': _getSavedItemsOfCategory('food'),
      'localCustoms': _researchData['customs'],
      'safetyNotes': _researchData['safety'],
      'researchDate': DateTime.now().toIso8601String(),
    };
    
    widget.onResearchComplete(researchSummary);
  }
  
  List<Map<String, dynamic>> _getSavedItemsOfCategory(String category) {
    if (!_researchData.containsKey(category)) return [];
    
    return (_researchData[category] as List<Map<String, dynamic>>)
        .where((item) => _isItemSaved(category, item['name'] ?? item['type']))
        .toList();
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
              "Destination Research",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Let's explore key information about ${widget.destination} to prepare for your trip.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),
            
            // Tabbed navigation for research categories
            TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Theme.of(context).colorScheme.primary,
              indicatorWeight: 3,
              tabs: _categories.map((category) {
                return Tab(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          category['icon'] as IconData,
                          color: category['color'] as Color,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(category['title']),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),
            
            // Tab content
            SizedBox(
              height: 450, // Fixed height for content area
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Overview
                  _isLoading ? _buildLoadingView() : _buildOverviewTab(),
                  
                  // Attractions
                  _isLoading ? _buildLoadingView() : _buildAttractionsTab(),
                  
                  // Transportation
                  _isLoading ? _buildLoadingView() : _buildTransportationTab(),
                  
                  // Accommodations
                  _isLoading ? _buildLoadingView() : _buildAccommodationsTab(),
                  
                  // Food & Drink
                  _isLoading ? _buildLoadingView() : _buildFoodTab(),
                  
                  // Local Customs
                  _isLoading ? _buildLoadingView() : _buildLocalCustomsTab(),
                  
                  // Safety & Risks
                  _isLoading ? _buildLoadingView() : _buildSafetyTab(),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // Show saved items
                    _showSavedItems(context);
                  },
                  icon: const Icon(Icons.bookmark),
                  label: Text('Saved (${_savedItems.length})'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _submitResearch,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Continue Trip Planning'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            "Researching ${widget.destination}...",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOverviewTab() {
    final overviewData = _researchData['overview'] as Map<String, dynamic>;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // General description
          _buildInfoCard(
            title: 'About ${widget.destination}',
            content: overviewData['description'],
            icon: Icons.info_outline,
            color: Colors.blue,
            isBookmarkable: false,
          ),
          
          const SizedBox(height: 16),
          
          // Key facts
          _buildInfoCard(
            title: 'Key Facts',
            content: '',
            icon: Icons.fact_check_outlined,
            color: Colors.purple,
            isBookmarkable: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildKeyValueRow('Best Time to Visit:', overviewData['bestTimeToVisit']),
                _buildKeyValueRow('Language:', overviewData['language']),
                _buildKeyValueRow('Currency:', overviewData['currency']),
                _buildKeyValueRow('Time Zone:', overviewData['timeZone']),
                _buildKeyValueRow('Visa:', overviewData['visaRequirements']),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Weather
          _buildInfoCard(
            title: 'Seasonal Weather',
            content: '',
            icon: Icons.wb_sunny_outlined,
            color: Colors.amber,
            isBookmarkable: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildKeyValueRow('Summer:', (overviewData['weather'] as Map)['summer']),
                _buildKeyValueRow('Fall:', (overviewData['weather'] as Map)['fall']),
                _buildKeyValueRow('Winter:', (overviewData['weather'] as Map)['winter']),
                _buildKeyValueRow('Spring:', (overviewData['weather'] as Map)['spring']),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAttractionsTab() {
    final attractions = _researchData['attractions'] as List<Map<String, dynamic>>;
    
    return ListView.builder(
      itemCount: attractions.length,
      itemBuilder: (context, index) {
        final attraction = attractions[index];
        return _buildAttractionCard(attraction);
      }
    );
  }
  
  Widget _buildTransportationTab() {
    final transportation = _researchData['transportation'] as List<Map<String, dynamic>>;
    
    return ListView.builder(
      itemCount: transportation.length,
      itemBuilder: (context, index) {
        final transportOption = transportation[index];
        return _buildInfoCard(
          title: transportOption['type'],
          content: transportOption['description'],
          icon: Icons.directions,
          color: Colors.orange,
          itemCategory: 'transportation',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildKeyValueRow('Cost:', transportOption['cost']),
              _buildKeyValueRow('Tips:', transportOption['tips']),
              _buildKeyValueRow('Reliability:', transportOption['reliability']),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildAccommodationsTab() {
    final accommodations = _researchData['accommodations'] as List<Map<String, dynamic>>;
    
    return ListView.builder(
      itemCount: accommodations.length,
      itemBuilder: (context, index) {
        final accommodation = accommodations[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  accommodation['imageUrl'],
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.hotel, size: 50, color: Colors.white),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and bookmark
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            accommodation['type'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isItemSaved('accommodations', accommodation['type'])
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () => _toggleSaveItem('accommodations', accommodation['type']),
                        ),
                      ],
                    ),
                    
                    // Price range
                    Text(
                      accommodation['priceRange'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Description
                    Text(accommodation['description']),
                    
                    const SizedBox(height: 8),
                    
                    // Locations
                    _buildKeyValueRow('Areas:', accommodation['locations']),
                    
                    const SizedBox(height: 8),
                    
                    // Recommendations
                    _buildKeyValueRow('Options:', (accommodation['recommendations'] as List).join(', ')),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildFoodTab() {
    final foodOptions = _researchData['food'] as List<Map<String, dynamic>>;
    
    return ListView.builder(
      itemCount: foodOptions.length,
      itemBuilder: (context, index) {
        final food = foodOptions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  food['imageUrl'],
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.restaurant, size: 50, color: Colors.white),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and bookmark
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            food['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isItemSaved('food', food['name'])
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () => _toggleSaveItem('food', food['name']),
                        ),
                      ],
                    ),
                    
                    // Description
                    Text(food['description']),
                    
                    const SizedBox(height: 8),
                    
                    // Must try
                    _buildKeyValueRow('Must Try:', (food['mustTry'] as List).join(', ')),
                    
                    const SizedBox(height: 8),
                    
                    // Price range
                    _buildKeyValueRow('Price Range:', food['priceRange']),
                    
                    const SizedBox(height: 8),
                    
                    // Recommendations
                    _buildKeyValueRow('Where to Go:', (food['recommendations'] as List).join(', ')),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildLocalCustomsTab() {
    final customsData = _researchData['customs'] as Map<String, dynamic>;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Etiquette
          _buildInfoCard(
            title: 'Etiquette & Manners',
            content: '',
            icon: Icons.public,
            color: Colors.teal,
            isBookmarkable: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final item in customsData['etiquette']) Text('• $item'),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Local customs
          _buildInfoCard(
            title: 'Local Customs',
            content: '',
            icon: Icons.celebration,
            color: Colors.purple,
            isBookmarkable: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final item in customsData['customs']) Text('• $item'),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Taboos
          _buildInfoCard(
            title: 'Cultural Sensitivity',
            content: '',
            icon: Icons.not_interested,
            color: Colors.red,
            isBookmarkable: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final item in customsData['taboos']) Text('• $item'),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Useful phrases
          _buildInfoCard(
            title: 'Useful Phrases',
            content: '',
            icon: Icons.translate,
            color: Colors.blue,
            isBookmarkable: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final entry in (customsData['phrases'] as Map<String, dynamic>).entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            entry.key,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(entry.value),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Business hours
          _buildInfoCard(
            title: 'Business Hours',
            content: customsData['businessHours'],
            icon: Icons.access_time,
            color: Colors.orange,
            isBookmarkable: false,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSafetyTab() {
    final safetyData = _researchData['safety'] as Map<String, dynamic>;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overall safety
          _buildInfoCard(
            title: 'Overall Safety',
            content: 'Safety Level: ${safetyData['overallSafety']}',
            icon: Icons.security,
            color: safetyData['overallSafety'] == 'High' ? Colors.green : Colors.orange,
            isBookmarkable: false,
          ),
          
          const SizedBox(height: 16),
          
          // Emergency numbers
          _buildInfoCard(
            title: 'Emergency Numbers',
            content: '',
            icon: Icons.emergency,
            color: Colors.red,
            isBookmarkable: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final entry in (safetyData['emergencyNumbers'] as Map<String, dynamic>).entries)
                  _buildKeyValueRow('${entry.key}:', entry.value),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Health concerns
          _buildInfoCard(
            title: 'Health Information',
            content: '',
            icon: Icons.health_and_safety,
            color: Colors.green,
            isBookmarkable: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final item in safetyData['healthConcerns']) Text('• $item'),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Areas to avoid
          _buildInfoCard(
            title: 'Areas to Be Cautious',
            content: '',
            icon: Icons.location_off,
            color: Colors.deepOrange,
            isBookmarkable: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final item in safetyData['areasToAvoid']) Text('• $item'),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Common scams
          _buildInfoCard(
            title: 'Common Scams',
            content: '',
            icon: Icons.warning_amber,
            color: Colors.amber,
            isBookmarkable: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final item in safetyData['commonScams']) Text('• $item'),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Weather risks
          _buildInfoCard(
            title: 'Weather Risks',
            content: safetyData['weatherRisks'],
            icon: Icons.thunderstorm,
            color: Colors.blueGrey,
            isBookmarkable: false,
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
    Widget? child,
    bool isBookmarkable = true,
    String itemCategory = '',
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isBookmarkable)
                  IconButton(
                    icon: Icon(
                      _isItemSaved(itemCategory, title)
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () => _toggleSaveItem(itemCategory, title),
                  ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Content
            if (content.isNotEmpty) Text(content),
            
            // Optional child widget
            if (child != null) ...[
              if (content.isNotEmpty) const SizedBox(height: 16),
              child,
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildAttractionCard(Map<String, dynamic> attraction) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              attraction['imageUrl'],
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: const Icon(Icons.photo, size: 50, color: Colors.white),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and bookmark
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        attraction['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isItemSaved('attractions', attraction['name'])
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => _toggleSaveItem('attractions', attraction['name']),
                    ),
                  ],
                ),
                
                // Rating
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber.shade700, size: 18),
                    Text(
                      ' ${attraction['rating']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Description
                Text(attraction['description']),
                
                const SizedBox(height: 8),
                
                // Price and hours
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: 'Price: '),
                          TextSpan(
                            text: attraction['price'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: 'Hours: '),
                          TextSpan(
                            text: attraction['openingHours'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (attraction['tags'] as List).map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildKeyValueRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
  
  void _showSavedItems(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with drag handle
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Saved Items",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                const Divider(height: 24),
                
                // Items list
                Expanded(
                  child: _savedItems.isEmpty
                      ? Center(
                          child: Text(
                            "No saved items yet.\nBookmark items as you explore!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _savedItems.length,
                          itemBuilder: (context, index) {
                            final savedId = _savedItems[index];
                            final parts = savedId.split(':');
                            final category = parts[0];
                            final itemTitle = parts[1];
                            
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: Icon(
                                  _getCategoryIcon(category),
                                  color: _getCategoryColor(category),
                                ),
                                title: Text(itemTitle),
                                subtitle: Text(_getCategoryName(category)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () {
                                    setState(() {
                                      _savedItems.remove(savedId);
                                    });
                                    Navigator.pop(context);
                                    _showSavedItems(context);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
                
                // Footer
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'attractions': return Icons.place_outlined;
      case 'transportation': return Icons.directions_car_outlined;
      case 'accommodations': return Icons.hotel_outlined;
      case 'food': return Icons.restaurant_outlined;
      default: return Icons.bookmark_outlined;
    }
  }
  
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'attractions': return Colors.green;
      case 'transportation': return Colors.orange;
      case 'accommodations': return Colors.purple;
      case 'food': return Colors.red;
      default: return Colors.blue;
    }
  }
  
  String _getCategoryName(String category) {
    switch (category) {
      case 'attractions': return 'Attraction';
      case 'transportation': return 'Transportation';
      case 'accommodations': return 'Accommodation';
      case 'food': return 'Food & Drink';
      default: return 'Item';
    }
  }
}