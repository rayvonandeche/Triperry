import 'package:flutter/material.dart';
import 'package:triperry/theme/app_theme.dart';
import '../../../../services/kenya_places_data.dart';
import 'accommodation_detail_screen.dart';

class AccommodationTypeSheet extends StatefulWidget {
  final String accommodationType;

  const AccommodationTypeSheet({
    Key? key,
    required this.accommodationType,
  }) : super(key: key);

  @override
  State<AccommodationTypeSheet> createState() => _AccommodationTypeSheetState();
}

class _AccommodationTypeSheetState extends State<AccommodationTypeSheet> {
  List<Map<String, dynamic>> filteredAccommodations = [];
  String _sortBy = 'Popular';
  final List<String> _sortOptions = ['Popular', 'Price: Low to High', 'Price: High to Low', 'Rating'];

  @override
  void initState() {
    super.initState();
    _filterAccommodations();
  }

  void _filterAccommodations() {
    // Filter accommodations based on the selected type
    filteredAccommodations = kenyaDestinations.where((place) {
      final type = _getAccommodationType(place['name']);
      return widget.accommodationType == 'All' || type == widget.accommodationType;
    }).map((place) {
      return {
        'title': _getAccommodationName(place['name']),
        'description': _getAccommodationType(place['name']),
        'image': place['image'],
        'price': _getPriceRange(place['name']),
        'rating': place['rating'],
        'reviews': place['reviews'],
        'address': place['address'] ?? 'Kenya',
        'amenities': _getAccommodationAmenities(place['name']),
        'tags': _getAccommodationTags(place['name']),
        'coordinates': {
          'lat': place['coordinates']?['lat'] ?? -1.286389,
          'lng': place['coordinates']?['lng'] ?? 36.817223
        },
      };
    }).toList();

    // Apply sorting
    _sortAccommodations();
  }

  void _sortAccommodations() {
    switch (_sortBy) {
      case 'Price: Low to High':
        filteredAccommodations.sort((a, b) {
          // Extract numeric values from price strings
          final priceA = _extractPriceValue(a['price']);
          final priceB = _extractPriceValue(b['price']);
          return priceA.compareTo(priceB);
        });
        break;
      case 'Price: High to Low':
        filteredAccommodations.sort((a, b) {
          final priceA = _extractPriceValue(a['price']);
          final priceB = _extractPriceValue(b['price']);
          return priceB.compareTo(priceA);
        });
        break;
      case 'Rating':
        filteredAccommodations.sort((a, b) => (b['rating'] ?? 0.0).compareTo(a['rating'] ?? 0.0));
        break;
      default: // Popular (based on reviews count)
        filteredAccommodations.sort((a, b) => (b['reviews'] ?? 0).compareTo(a['reviews'] ?? 0));
    }
  }

  // Helper method to extract numeric price value for sorting
  double _extractPriceValue(String? priceString) {
    if (priceString == null) return 0.0;
    
    // Extract numbers from strings like "KSh 12,000/night"
    final regex = RegExp(r'([0-9,]+)');
    final match = regex.firstMatch(priceString);
    if (match != null) {
      final numericString = match.group(1)?.replaceAll(',', '') ?? '0';
      return double.tryParse(numericString) ?? 0.0;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle and title
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 12, bottom: 16),
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.accommodationType} Accommodations',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildSortDropdown(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '${filteredAccommodations.length} options available',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Accommodations list
          Expanded(
            child: filteredAccommodations.isEmpty
                ? const Center(child: Text('No accommodations found'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredAccommodations.length,
                    itemBuilder: (context, index) {
                      final accommodation = filteredAccommodations[index];
                      return _buildAccommodationCard(accommodation);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4,),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: _sortBy,
        icon: const Icon(Icons.keyboard_arrow_down, size: 20),
        underline: const SizedBox(),
        style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w500),
        items: _sortOptions.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _sortBy = newValue;
              _sortAccommodations();
            });
          }
        },
      ),
    );
  }

  Widget _buildAccommodationCard(Map<String, dynamic> accommodation) {    // Defensive: ensure all fields are non-null for the detail screen
    final safeAccommodation = <String, dynamic>{
      'image': accommodation['image'] ?? 'assets/images/placeholder.jpeg',
      'title': accommodation['title'] ?? 'Accommodation',
      'description': accommodation['description'] ?? 'No description available',
      'address': accommodation['address'] ?? 'Kenya',
      'price': accommodation['price'] ?? 'KSh 5,000/night',
      'priceRange': accommodation['price'] ?? 'KSh 5,000/night', // Add priceRange as well
      'rating': accommodation['rating'] ?? 4.0,
      'reviews': accommodation['reviews'] ?? 0,
      'amenities': accommodation['amenities'] ?? <String>[],
      'tags': (accommodation['tags'] as List<dynamic>?) ?? <String>[],
      'coordinates': accommodation['coordinates'] ?? {'lat': -1.286389, 'lng': 36.817223},
    };
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AccommodationDetailScreen(
                accommodation: safeAccommodation,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and rating
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),                  child: Image.asset(
                    accommodation['image'] ?? 'assets/images/placeholder.jpeg',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                        const SizedBox(width: 4),                        Text(
                          '${accommodation['rating'] ?? 4.0}',
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
            
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and type                  
                  Text(
                    accommodation['title'] ?? 'Accommodation',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    accommodation['description'] ?? 'No description available',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          accommodation['address'] ?? 'Kenya',
                          style: TextStyle(color: Colors.grey.shade600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Tags
                  if (accommodation['tags'] != null)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ((accommodation['tags'] as List<dynamic>?) ?? []).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            tag.toString(),
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 12),
                  
                  // Price and action
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'From ${accommodation['price'] ?? 'KSh 5,000/night'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccommodationDetailScreen(
                                accommodation: safeAccommodation,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Book Now'),
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
  
  // Helper methods for accommodation data
  String _getAccommodationName(String placeName) {
    final names = {
      'Maasai Mara': 'Savannah Lodge',
      'Diani Beach': 'Beach Resort',
      'Mount Kenya': 'Mountain View Hotel',
      'Nairobi': 'City Hotel',
      'Lamu': 'Coastal Retreat'
    };
    return names[placeName] ?? '$placeName Accommodation';
  }

  String _getAccommodationType(String placeName) {
    final types = {
      'Maasai Mara': 'Safari Lodge',
      'Diani Beach': 'Beach Resort',
      'Mount Kenya': 'Mountain Hotel',
      'Nairobi': 'City Hotel',
      'Lamu': 'Boutique Stay'
    };
    return types[placeName] ?? 'Hotel';
  }

  List<String> _getAccommodationAmenities(String placeName) {
    final amenities = {
      'Maasai Mara': ['Pool', 'Restaurant', 'Game drives', 'Spa'],
      'Diani Beach': ['Beachfront', 'Pool', 'Water sports', 'Restaurant'],
      'Mount Kenya': ['Mountain views', 'Hiking trails', 'Restaurant', 'Free WiFi'],
      'Nairobi': ['Business center', 'Restaurant', 'Gym', 'Airport shuttle'],
      'Lamu': ['Sea view', 'Traditional design', 'Restaurant', 'Cultural tours']
    };
    return amenities[placeName] ?? ['Free WiFi', 'Restaurant', 'Air conditioning', 'Parking'];
  }

  String _getPriceRange(String placeName) {
    final prices = {
      'Maasai Mara': 'KSh 12,000/night',
      'Diani Beach': 'KSh 15,000/night',
      'Mount Kenya': 'KSh 8,000/night',
      'Nairobi': 'KSh 7,500/night',
      'Lamu': 'KSh 9,000/night'
    };
    return prices[placeName] ?? 'KSh 5,000/night';
  }

  List<String> _getAccommodationTags(String placeName) {
    final tags = {
      'Maasai Mara': ['Safari', 'Wildlife', 'Luxury'],
      'Diani Beach': ['Beachfront', 'Family-friendly', 'All-inclusive'],
      'Mount Kenya': ['Mountain view', 'Nature', 'Hiking'],
      'Nairobi': ['Business', 'City center', 'Airport transfer'],
      'Lamu': ['Historic', 'Cultural', 'Romantic']
    };
    return tags[placeName] ?? ['Comfortable', 'Clean', 'Convenient'];
  }
}

void showAccommodationTypeSheet(BuildContext context, String accommodationType) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => AccommodationTypeSheet(accommodationType: accommodationType),
  );
}
