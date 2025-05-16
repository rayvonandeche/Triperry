import 'package:flutter/material.dart';
import 'package:triperry/theme/app_theme.dart';
import '../../../../services/kenya_transport_data.dart';
import 'transport_detail_screen.dart';

class TransportTypeSheet extends StatefulWidget {
  final String transportType;

  const TransportTypeSheet({
    Key? key,
    required this.transportType,
  }) : super(key: key);

  @override
  State<TransportTypeSheet> createState() => _TransportTypeSheetState();
}

class _TransportTypeSheetState extends State<TransportTypeSheet> {
  List<Map<String, dynamic>> filteredTransport = [];
  String _sortBy = 'Popular';
  final List<String> _sortOptions = ['Popular', 'Price: Low to High', 'Price: High to Low', 'Rating'];

  @override
  void initState() {
    super.initState();
    _filterTransport();
  }
  void _filterTransport() {
    // Get transport data from service
    final List<Map<String, dynamic>> transportOptions = KenyaTransportData.getAllTransport();
    
    // Filter based on selected type
    filteredTransport = widget.transportType == 'All'
        ? transportOptions
        : transportOptions.where((transport) => transport['type'] == widget.transportType).toList();

    // Apply sorting
    _sortTransport();
  }

  void _sortTransport() {
    switch (_sortBy) {
      case 'Price: Low to High':
        filteredTransport.sort((a, b) {
          final priceA = _extractPriceValue(a['price']);
          final priceB = _extractPriceValue(b['price']);
          return priceA.compareTo(priceB);
        });
        break;
      case 'Price: High to Low':
        filteredTransport.sort((a, b) {
          final priceA = _extractPriceValue(a['price']);
          final priceB = _extractPriceValue(b['price']);
          return priceB.compareTo(priceA);
        });
        break;
      case 'Rating':
        filteredTransport.sort((a, b) => (b['rating'] ?? 0.0).compareTo(a['rating'] ?? 0.0));
        break;
      default: // Popular (based on reviews count)
        filteredTransport.sort((a, b) => (b['reviews'] ?? 0).compareTo(a['reviews'] ?? 0));
    }
  }

  // Helper method to extract numeric price value for sorting
  double _extractPriceValue(String? priceString) {
    if (priceString == null) return 0.0;
    
    // Extract numbers from strings like "KSh 5,000/day"
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.transportType} Transport',
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
              '${filteredTransport.length} options available',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Transport options list
          Expanded(
            child: filteredTransport.isEmpty
                ? const Center(child: Text('No transport options found'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredTransport.length,
                    itemBuilder: (context, index) {
                      final transport = filteredTransport[index];
                      return _buildTransportCard(transport);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
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
              _sortTransport();
            });
          }
        },
      ),
    );
  }

  Widget _buildTransportCard(Map<String, dynamic> transport) {
    // Defensive: ensure all fields are non-null for the detail screen
    final safeTransport = <String, dynamic>{
      'image': transport['image'] ?? 'assets/images/placeholder.jpeg',
      'title': transport['title'] ?? 'Transport',
      'description': transport['description'] ?? 'No description available',
      'address': transport['address'] ?? 'Kenya',
      'price': transport['price'] ?? 'Price on request',
      'rating': transport['rating'] ?? 4.0,
      'reviews': transport['reviews'] ?? 0,
      'amenities': transport['amenities'] ?? <String>[],
      'tags': (transport['tags'] as List<dynamic>?) ?? <String>[],
      'type': transport['type'] ?? 'Transport',
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
              builder: (context) => TransportDetailScreen(
                transport: safeTransport,
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    transport['image'] ?? 'assets/images/placeholder.jpeg',
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
                        const SizedBox(width: 4),
                        Text(
                          '${transport['rating'] ?? 4.0}',
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
                    transport['title'] ?? 'Transport',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transport['description'] ?? 'No description available',
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
                          transport['address'] ?? 'Kenya',
                          style: TextStyle(color: Colors.grey.shade600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Tags
                  if (transport['tags'] != null)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ((transport['tags'] as List<dynamic>?) ?? []).map((tag) {
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
                        transport['price'] ?? 'Price on request',
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
                              builder: (context) => TransportDetailScreen(
                                transport: safeTransport,
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
}

void showTransportTypeSheet(BuildContext context, String transportType) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => TransportTypeSheet(transportType: transportType),
  );
}
