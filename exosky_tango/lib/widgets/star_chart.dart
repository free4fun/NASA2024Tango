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
    // Convert tap position to RA and Dec
    final double ra = raMin + (tapPosition.dx / width) * (raMax - raMin);
    final double dec = decMax - (tapPosition.dy / height) * (decMax - decMin);

    // Find the nearest exoplanet
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

    // Check if the nearest exoplanet is within a reasonable distance (e.g., 5 degrees)
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
  final bool showGrid;
  final Set<ExoplanetType> visibleTypes;
  final double raMin;
  final double raMax;
  final double decMin;
  final double decMax;

  StarChartPainter({
    required this.stars,
    required this.exoplanets,
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

    if (showGrid) _drawGrid(canvas, size);
    _drawStars(canvas, size);
    _drawExoplanets(canvas, size);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 0.5;

    // Draw RA lines
    for (double ra = raMin; ra <= raMax; ra += 15) {
      final x = _mapRA(ra, size.width);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw Dec lines
    for (double dec = decMin; dec <= decMax; dec += 10) {
      final y = _mapDec(dec, size.height);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawStars(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (final star in stars) {
      final x = _mapRA(star.rightAscension, size.width);
      final y = _mapDec(star.declination, size.height);

      // Adjust star size based on magnitude
      final starSize = _calculateStarSize(star.apparentMagnitude ?? 0.0);
      canvas.drawCircle(Offset(x, y), starSize, paint);
    }
  }

  double _calculateStarSize(double magnitude) {
    // Adjust this formula to get desired star sizes
    return max(0.5, min(3, 3 - (magnitude * 0.3)));
  }

  void _drawExoplanets(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final exoplanet in exoplanets) {
      if (!visibleTypes.contains(exoplanet.type)) continue;

      final x = _mapRA(exoplanet.rightAscension ?? 0, size.width);
      final y = _mapDec(exoplanet.declination ?? 0, size.height);

      paint.color = _getExoplanetColor(exoplanet.type);
      canvas.drawCircle(Offset(x, y), 3, paint);
    }
  }

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
        return Colors.cyan;
      default:
        return Colors.purple;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
