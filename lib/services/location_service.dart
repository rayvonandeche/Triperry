import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class LocationService {
  static Future<LatLng?> getCoordinates(String query) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final response = await http.get(
        Uri.parse('https://nominatim.openstreetmap.org/search?q=$encodedQuery&format=json&limit=1'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List results = jsonDecode(response.body);
        if (results.isNotEmpty) {
          final double lat = double.parse(results[0]['lat']);
          final double lon = double.parse(results[0]['lon']);
          return LatLng(lat, lon);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}