import 'dart:convert';
import 'package:http/http.dart' as http;

class KenyaMapsService {
  final String apiKey;
  KenyaMapsService(this.apiKey);

  // Fetch popular Kenyan destinations (e.g., beaches, parks, cities)
  Future<List<Map<String, dynamic>>> fetchPopularDestinations() async {
    // Example: Search for top places in Kenya
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/textsearch/json?query=top+tourist+destinations+in+Kenya&key=$apiKey',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['results']);
    } else {
      throw Exception('Failed to fetch destinations');
    }
  }

  // Fetch details for a specific place by placeId
  Future<Map<String, dynamic>> fetchPlaceDetails(String placeId) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['result'] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch place details');
    }
  }

  // Fetch photos for a place
  String getPhotoUrl(String photoReference, {int maxWidth = 400}) {
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=$maxWidth&photoreference=$photoReference&key=$apiKey';
  }
}
