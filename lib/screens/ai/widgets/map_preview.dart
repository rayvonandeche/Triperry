import 'package:flutter/material.dart';
import 'dart:math' as math;

class MapPreview extends StatelessWidget {
  final String destination;
  final double latitude;
  final double longitude;
  final List<MapPoint> pointsOfInterest;

  const MapPreview({
    super.key,
    required this.destination,
    required this.latitude,
    required this.longitude,
    this.pointsOfInterest = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade100,
            Colors.blue.shade50,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Simulated map grid
          CustomPaint(
            painter: MapGridPainter(),
            size: Size.infinite,
          ),
          
          // Points of interest
          ...pointsOfInterest.map((point) => Positioned(
            left: point.x * 200,
            top: point.y * 200,
            child: _buildMapPoint(point),
          )),
          
          // Destination marker
          Positioned(
            left: 100,
            top: 100,
            child: _buildDestinationMarker(),
          ),
          
          // Location info overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    destination,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Lat: ${latitude.toStringAsFixed(2)}°, Long: ${longitude.toStringAsFixed(2)}°',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
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

  Widget _buildDestinationMarker() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(
        Icons.location_on,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildMapPoint(MapPoint point) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        point.icon,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}

class MapPoint {
  final double x;
  final double y;
  final IconData icon;
  final String label;

  const MapPoint({
    required this.x,
    required this.y,
    required this.icon,
    required this.label,
  });
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.1)
      ..strokeWidth = 1;

    // Draw horizontal lines
    for (var i = 0; i < size.height; i += 20) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }

    // Draw vertical lines
    for (var i = 0; i < size.width; i += 20) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }

    // Draw some random "roads"
    final roadPaint = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..strokeWidth = 3;

    final random = math.Random(42); // Fixed seed for consistent roads
    for (var i = 0; i < 5; i++) {
      final startX = random.nextDouble() * size.width;
      final startY = random.nextDouble() * size.height;
      final endX = random.nextDouble() * size.width;
      final endY = random.nextDouble() * size.height;

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        roadPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 