import 'package:flutter/material.dart';
import 'package:exosky_tango/models/star.dart';
import 'package:exosky_tango/models/exoplanet.dart';
import 'dart:math' as math;

class StarChart extends StatelessWidget {
  final double raMin;
  final double raMax;
  final double decMin;
  final double decMax;
  final bool showGrid;
  final double zoom;
  final Offset offset;
  final List<Star> stars;
  final List<Exoplanet> exoplanets;

  const StarChart({
    Key? key,
    required this.raMin,
    required this.raMax,
    required this.decMin,
    required this.decMax,
    required this.showGrid,
    required this.zoom,
    required this.offset,
    required this.stars,
    required this.exoplanets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Dark background for better star visibility
      child: CustomPaint(
        painter: StarChartPainter(
          stars: stars,
          exoplanets: exoplanets,
          raMin: raMin,
          raMax: raMax,
          decMin: decMin,
          decMax: decMax,
          showGrid: showGrid,
          zoom: zoom,
          offset: offset,
        ),
        child: Container(),
      ),
    );
  }
}

class StarChartPainter extends CustomPainter {
  final List<Star> stars;
  final List<Exoplanet> exoplanets;
  final double raMin;
  final double raMax;
  final double decMin;
  final double decMax;
  final bool showGrid;
  final double zoom;
  final Offset offset;

  StarChartPainter({
    required this.stars,
    required this.exoplanets,
    required this.raMin,
    required this.raMax,
    required this.decMin,
    required this.decMax,
    required this.showGrid,
    required this.zoom,
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background grid if showGrid is true
    if (showGrid) {
      _drawGrid(canvas, size);
    }

    // Draw stars
    _drawStars(canvas, size);

    // Draw exoplanets
    _drawExoplanets(canvas, size);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 0.5;

    // Draw RA lines
    for (double ra = raMin; ra <= raMax; ra += 15) {
      final x = _mapRA(ra, size.width);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw Dec lines
    for (double dec = decMin; dec <= decMax; dec += 10) {
      final y = _mapDec(dec, size.height);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  void _drawStars(Canvas canvas, Size size) {
    for (var star in stars) {
      if (star.apparentMagnitude != null) {
        final x = _mapRA(star.rightAscension, size.width);
        final y = _mapDec(star.declination, size.height);
        final scaledSize = _scaleStarSize(star.apparentMagnitude!);

        final paint = Paint()
          ..color = _getStarColor(star.temperature)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          Offset(x * zoom + offset.dx, y * zoom + offset.dy),
          scaledSize,
          paint,
        );
      }
    }
  }

  void _drawExoplanets(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (var exoplanet in exoplanets) {
      if (exoplanet.rightAscension != null && exoplanet.declination != null) {
        final x = _mapRA(exoplanet.rightAscension!, size.width);
        final y = _mapDec(exoplanet.declination!, size.height);

        canvas.drawCircle(
          Offset(x * zoom + offset.dx, y * zoom + offset.dy),
          3,
          paint,
        );
      }
    }
  }

  double _mapRA(double ra, double width) {
    return (ra - raMin) / (raMax - raMin) * width;
  }

  double _mapDec(double dec, double height) {
    return (dec - decMin) / (decMax - decMin) * height;
  }

  double _scaleStarSize(double magnitude) {
    // Inverse relationship: brighter stars (lower magnitude) appear larger
    return math.max(5 - magnitude, 0.5);
  }

  Color _getStarColor(double? temperature) {
    if (temperature == null) return Colors.white;

    if (temperature > 30000) return Colors.blue[200]!;
    if (temperature > 10000) return Colors.white;
    if (temperature > 7500) return Colors.yellow[200]!;
    if (temperature > 6000) return Colors.yellow;
    if (temperature > 5000) return Colors.orange;
    return Colors.red;
  }

  @override
  bool shouldRepaint(covariant StarChartPainter oldDelegate) =>
      stars != oldDelegate.stars ||
      exoplanets != oldDelegate.exoplanets ||
      showGrid != oldDelegate.showGrid ||
      zoom != oldDelegate.zoom ||
      offset != oldDelegate.offset;
}
