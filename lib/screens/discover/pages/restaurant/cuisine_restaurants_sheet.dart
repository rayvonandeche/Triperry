import 'package:flutter/material.dart';
import 'package:triperry/theme/app_theme.dart';
import '../../../../services/kenya_places_data.dart';
import '../../../../services/kenya_restaurants_data.dart';
import 'restaurant_detail_screen.dart';

/// Shows a bottom sheet with restaurants matching a specific cuisine type
void showCuisineRestaurants(BuildContext context, String cuisineType) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CuisineRestaurantsSheet(cuisineType: cuisineType),
  );
}

// Helper methods for restaurant data - using real restaurant information when available
String _getRestaurantName(String placeName) {
  // First check if we have a real restaurant with a similar name
  for (var restaurant in KenyaRestaurantsData.restaurants) {
    if (restaurant['name'].toString().toLowerCase().contains(placeName.toLowerCase()) ||
        placeName.toLowerCase().contains(restaurant['name'].toString().toLowerCase())) {
      return restaurant['name'];
    }
  }
  
  // Fall back to our original mapping if no match
  final names = {
    'Maasai Mara': 'Savannah Grill',
    'Diani Beach': 'Ocean Breeze',
    'Mount Kenya': 'Highland Bistro',
    'Nairobi': 'Urban Eats',
    'Lamu': 'Coastal Kitchen'
  };
  return names[placeName] ?? '$placeName Restaurant';
}

String _getCuisineType(String placeName) {
  // First check if we have a real restaurant with a similar name
  for (var restaurant in KenyaRestaurantsData.restaurants) {
    if (restaurant['name'].toString().toLowerCase().contains(placeName.toLowerCase()) ||
        placeName.toLowerCase().contains(restaurant['name'].toString().toLowerCase())) {
      return restaurant['cuisineType'];
    }
  }
  
  // Fall back to our original mapping if no match
  final cuisines = {
    'Maasai Mara': 'African',
    'Diani Beach': 'Seafood',
    'Mount Kenya': 'Traditional',
    'Nairobi': 'International',
    'Lamu': 'Swahili'
  };
  return cuisines[placeName] ?? 'Kenyan';
}

String _getPriceRange(String placeName) {
  // First check if we have a real restaurant with a similar name
  for (var restaurant in KenyaRestaurantsData.restaurants) {
    if (restaurant['name'].toString().toLowerCase().contains(placeName.toLowerCase()) ||
        placeName.toLowerCase().contains(restaurant['name'].toString().toLowerCase())) {
      return restaurant['priceRange'];
    }
  }
  
  // Fall back to our original mapping if no match
  final prices = {
    'Maasai Mara': 'KSh 800-1500',
    'Diani Beach': 'KSh 1000-2000',
    'Mount Kenya': 'KSh 600-1200',
    'Nairobi': 'KSh 500-2500',
    'Lamu': 'KSh 700-1800',
    'Maasai Mara National Reserve': 'KSh 800-1500',
    'Nairobi National Park': 'KSh 500-2500',
    'Lamu Old Town': 'KSh 700-1800'
  };
  return prices[placeName] ?? 'KSh 500-2000';
}

List<String> _getRestaurantTags(String placeName) {
  // First check if we have a real restaurant with a similar name
  for (var restaurant in KenyaRestaurantsData.restaurants) {
    if (restaurant['name'].toString().toLowerCase().contains(placeName.toLowerCase()) ||
        placeName.toLowerCase().contains(restaurant['name'].toString().toLowerCase())) {
      return List<String>.from(restaurant['tags']);
    }
  }
  
  // Fall back to our original mapping if no match
  final tags = {
    'Maasai Mara': ['Outdoor', 'BBQ', 'Traditional'],
    'Diani Beach': ['Beachfront', 'Seafood', 'Romantic'],
    'Mount Kenya': ['Mountain View', 'Organic', 'Healthy'],
    'Nairobi': ['Fine Dining', 'Trendy', 'Cocktails'],
    'Lamu': ['Historic', 'Spicy', 'Cultural'],
    'Maasai Mara National Reserve': ['Outdoor', 'BBQ', 'Traditional'],
    'Nairobi National Park': ['Fine Dining', 'Trendy', 'Cocktails'],
    'Lamu Old Town': ['Historic', 'Spicy', 'Cultural']
  };
  return tags[placeName] ?? ['Popular', 'Local', 'Authentic'];
}

Map<String, double> _getLocationCoordinates(String placeName) {
  // Map place names to coordinates
  final coordinates = {
    'Maasai Mara National Reserve': {'lat': -1.5, 'lng': 35.1},
    'Diani Beach': {'lat': -4.277, 'lng': 39.591},
    'Mount Kenya': {'lat': -0.152, 'lng': 37.3},
    'Nairobi National Park': {'lat': -1.312, 'lng': 36.817},
    'Lamu Old Town': {'lat': -2.269, 'lng': 40.902},
    'Maasai Mara': {'lat': -1.5, 'lng': 35.1},
    'Nairobi': {'lat': -1.286389, 'lng': 36.817223},
    'Lamu': {'lat': -2.269, 'lng': 40.902},
  };

  if (coordinates.containsKey(placeName)) {
    return {
      'lat': coordinates[placeName]!['lat']!,
      'lng': coordinates[placeName]!['lng']!,
    };
  }

  // Default to Nairobi coordinates
  return {'lat': -1.286389, 'lng': 36.817223};
}

class CuisineRestaurantsSheet extends StatelessWidget {
  final String cuisineType;

  const CuisineRestaurantsSheet({
    super.key,
    required this.cuisineType,
  });

  @override
  Widget build(BuildContext context) {    // Filter restaurants by the selected cuisine type
    final restaurants = KenyaRestaurantsData.restaurants
        .where((restaurant) {
          final cuisineType = (restaurant['cuisineType'] ?? '').toString().toLowerCase();
          
          // Safely handle tags which might be null
          List<dynamic> tags = [];
          if (restaurant['tags'] != null) {
            if (restaurant['tags'] is List) {
              tags = restaurant['tags'] as List<dynamic>;
            }
          }
          
          final tagMatches = tags.any((tag) => tag.toString().toLowerCase() == this.cuisineType.toLowerCase());
          
          return cuisineType == this.cuisineType.toLowerCase() || tagMatches;
        })
        .toList();

    // If no exact matches, use restaurants with similar cuisine keywords
    List<Map<String, dynamic>> displayRestaurants = restaurants.isNotEmpty 
        ? restaurants 
        : KenyaRestaurantsData.restaurants.where((restaurant) {
            final cuisineLower = (restaurant['cuisineType'] ?? '').toString().toLowerCase();
            return cuisineLower.contains(this.cuisineType.toLowerCase()) ||
                   this.cuisineType.toLowerCase().contains(cuisineLower);
          }).toList();    // If still empty, just show some default restaurants
    if (displayRestaurants.isEmpty) {
      displayRestaurants = KenyaRestaurantsData.restaurants
          .where((restaurant) {
            // Add null safety for rating
            final rating = restaurant['rating'];
            if (rating == null) return false;
            
            double ratingValue;
            if (rating is double) {
              ratingValue = rating;
            } else {
              ratingValue = double.tryParse(rating.toString()) ?? 0.0;
            }
            
            return ratingValue >= 4.0;
          })
          .take(5)
          .toList();
    }

    // If we still have no restaurants, just take the first 5 from the data
    if (displayRestaurants.isEmpty && KenyaRestaurantsData.restaurants.isNotEmpty) {
      displayRestaurants = KenyaRestaurantsData.restaurants.take(5).toList();
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            height: 5,
            width: 40,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$cuisineType Restaurants',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${displayRestaurants.length} restaurants found',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildFilterChip('All', true),
                _buildFilterChip('Highest Rated', false),
                _buildFilterChip('Nearest', false),
                _buildFilterChip('Price: Low to High', false),
                _buildFilterChip('Popular', false),
              ],
            ),
          ),
          
          const SizedBox(height: 10),
          
          // Restaurant list
          Expanded(
            child: displayRestaurants.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No $cuisineType restaurants found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try searching for a different cuisine',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: displayRestaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = displayRestaurants[index];
                      return _buildRestaurantCard(context, restaurant);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (value) {}, // In a full implementation, this would filter the list
        backgroundColor: Colors.grey[200],
        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
        checkmarkColor: AppTheme.primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primaryColor : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(BuildContext context, Map<String, dynamic> restaurant) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestaurantDetailScreen(restaurant: restaurant),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),                  child: Image.asset(
                    restaurant['image'] ?? 'assets/images/placeholder.jpeg',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(                          (restaurant['rating'] ?? 0.0).toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(                        child: Text(
                          restaurant['name'] ?? 'Restaurant',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        restaurant['priceRange'] ?? '\$\$',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant['address'] ?? 'Kenya',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),                  Wrap(
                    spacing: 8,
                    children: [
                      for (var tag in ((restaurant['tags'] as List<dynamic>?) ?? ['Local']).take(3))
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tag.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.primaryColor.withOpacity(0.8),
                            ),
                          ),
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
  }
}
