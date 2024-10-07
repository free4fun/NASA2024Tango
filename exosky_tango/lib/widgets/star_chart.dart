import 'dart:math';
import 'package:flutter/material.dart';
import 'package:exosky_tango/models/star.dart';
import 'package:exosky_tango/models/exoplanet.dart';

class StarChart extends StatelessWidget {
  final List<Star> stars;
  final List<Exoplanet> exoplanets;
  final bool showGrid;
  final Function(Exoplanet?) onExoplanetSelected;
  final Set<ExoplanetType> visibleTypes;
  final double raMin;
  final double raMax;
  final double decMin;
  final double decMax;
  final double width;
  final double height;
  final List<Exoplanet> selectedPlanets; // Updated: Include selected planets

  const StarChart({
    Key? key,
    required this.stars,
    required this.exoplanets,
    required this.showGrid,
    required this.onExoplanetSelected,
    required this.visibleTypes,
    required this.raMin,
    required this.raMax,
    required this.decMin,
    required this.decMax,
    required this.width,
    required this.height,
    required this.selectedPlanets, // Updated: Include selected planets
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) => _handleTap(details.localPosition),
      child: CustomPaint(
        size: Size(width, height),
        painter: StarChartPainter(
          stars: stars,
          exoplanets: exoplanets,
          selectedPlanets: selectedPlanets, // Updated: Pass selected planets
          showGrid: showGrid,
          visibleTypes: visibleTypes,
          raMin: raMin,
          raMax: raMax,
          decMin: decMin,
          decMax: decMax,
        ),
      ),
    );
  }

  void _handleTap(Offset tapPosition) {
    final double ra = raMin + (tapPosition.dx / width) * (raMax - raMin);
    final double dec = decMax - (tapPosition.dy / height) * (decMax - decMin);

    Exoplanet? nearestExoplanet;
    double minDistance = double.infinity;

    for (final exoplanet in exoplanets) {
      if (!visibleTypes.contains(exoplanet.type)) continue;

      final distance = _calculateCelestialDistance(ra, dec,
          exoplanet.rightAscension ?? 0.0, exoplanet.declination ?? 0.0);
      if (distance < minDistance) {
        minDistance = distance;
        nearestExoplanet = exoplanet;
      }
    }

    if (minDistance <= 5.0) {
      onExoplanetSelected(nearestExoplanet);
    } else {
      onExoplanetSelected(null);
    }
  }

  double _calculateCelestialDistance(
      double ra1, double dec1, double ra2, double dec2) {
    final phi1 = _degreesToRadians(90 - dec1);
    final phi2 = _degreesToRadians(90 - dec2);
    final theta = _degreesToRadians(ra1 - ra2);

    final cosDistance =
        sin(phi1) * sin(phi2) * cos(theta) + cos(phi1) * cos(phi2);
    return _radiansToDegrees(acos(cosDistance.clamp(-1.0, 1.0)));
  }

  double _degreesToRadians(double degrees) => degrees * pi / 180;
  double _radiansToDegrees(double radians) => radians * 180 / pi;
}

class StarChartPainter extends CustomPainter {
  final List<Star> stars;
  final List<Exoplanet> exoplanets;
  final List<Exoplanet> selectedPlanets;
  final bool showGrid;
  final Set<ExoplanetType> visibleTypes;
  final double raMin;
  final double raMax;
  final double decMin;
  final double decMax;

  StarChartPainter({
    required this.stars,
    required this.exoplanets,
    required this.selectedPlanets,
    required this.showGrid,
    required this.visibleTypes,
    required this.raMin,
    required this.raMax,
    required this.decMin,
    required this.decMax,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.black,
    );

      void _drawGrid(Canvas canvas, Size size) {
    // Your grid drawing logic
    Paint paint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..style = PaintingStyle.stroke;
      
    for (double i = 0; i < size.width; i += 50) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double j = 0; j < size.height; j += 50) {
      canvas.drawLine(Offset(0, j), Offset(size.width, j), paint);
    }
  }

  void _drawStars(Canvas canvas, Size size) {
  Paint paint = Paint()..color = Colors.white;

  for (var star in stars) {
    canvas.drawCircle(star.position, star.size, paint); // Use star.position and star.size
  }
}

void _drawSelectedPlanets(Canvas canvas, Size size) {
  Paint paint = Paint()..color = Colors.yellow;

  for (var planet in selectedPlanets) {
    canvas.drawCircle(planet.position, planet.size, paint); // Use planet.position and planet.size
  }
}


    if (showGrid) _drawGrid(canvas, size);
    _drawStars(canvas, size);
    _drawExoplanets(canvas, size);
    _drawSelectedPlanets(canvas, size); // Draw selected planets
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Change to true if the data might change
  }

  void _drawExoplanets(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final exoplanet in exoplanets) {
      if (!visibleTypes.contains(exoplanet.type)) continue;

      // Calculate coordinates
      exoplanet.x = _mapRA(exoplanet.rightAscension ?? 0, size.width);
      exoplanet.y = _mapDec(exoplanet.declination ?? 0, size.height);

      paint.color = _getExoplanetColor(exoplanet.type);
      canvas.drawCircle(Offset(exoplanet.x, exoplanet.y), 3, paint);
    }
  }

  // Other existing methods remain unchanged...

  // Map Right Ascension to x-coordinate
  double _mapRA(double ra, double width) {
    return (ra - raMin) / (raMax - raMin) * width;
  }

  // Map Declination to y-coordinate
  double _mapDec(double dec, double height) {
    return (decMax - dec) / (decMax - decMin) * height;
  }

  Color _getExoplanetColor(ExoplanetType type) {
    switch (type) {
      case ExoplanetType.gasGiant:
        return Colors.orange;
      case ExoplanetType.terrestrial:
        return Colors.blue;
      case ExoplanetType.superEarth:
        return Colors.green;
      case ExoplanetType.iceGiant:
        return Colors.purple;
      default:
        return Colors.grey; // Unknown
    }
  }
}
