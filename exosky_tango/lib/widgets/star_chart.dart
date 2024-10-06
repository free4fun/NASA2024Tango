import 'package:flutter/material.dart';
import 'dart:math' show pi, sin, cos, asin, acos, tan, log;
import 'package:exosky_tango/models/exoplanet.dart';
import 'package:exosky_tango/models/star.dart';
import 'package:provider/provider.dart';
import 'package:exosky_tango/providers/star_provider.dart';

class StarChart extends StatefulWidget {
  final List<Exoplanet> exoplanets;
  final bool showGrid;
  final double rightAscension;
  final double declination;

  const StarChart({
    Key? key,
    required this.exoplanets,
    required this.showGrid,
    required this.rightAscension,
    required this.declination,
  }) : super(key: key);

  @override
  _StarChartState createState() => _StarChartState();
}

class _StarChartState extends State<StarChart> {
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  Offset? _lastFocalPoint;

  @override
  Widget build(BuildContext context) {
    return Consumer<StarProvider>(
      builder: (context, starProvider, child) {
        return GestureDetector(
          onScaleStart: (details) {
            _lastFocalPoint = details.focalPoint;
          },
          onScaleUpdate: (details) {
            setState(() {
              // Handle zooming
              _scale *= details.scale;
              _scale = _scale.clamp(0.5, 5.0); // Limit zoom level

              // Handle panning
              if (_lastFocalPoint != null) {
                final delta = details.focalPoint - _lastFocalPoint!;
                _offset += delta / _scale;
                _lastFocalPoint = details.focalPoint;
              }
            });
          },
          child: CustomPaint(
            painter: StarChartPainter(
              stars: starProvider.stars,
              exoplanets: widget.exoplanets,
              showGrid: widget.showGrid,
              rightAscension: widget.rightAscension,
              declination: widget.declination,
              scale: _scale,
              offset: _offset,
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

class StarChartPainter extends CustomPainter {
  final List<Star> stars;
  final List<Exoplanet> exoplanets;
  final bool showGrid;
  final double rightAscension;
  final double declination;
  final double scale;
  final Offset offset;

  StarChartPainter({
    required this.stars,
    required this.exoplanets,
    required this.showGrid,
    required this.rightAscension,
    required this.declination,
    required this.scale,
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Set black background
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.black);

    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.scale(scale);

    if (showGrid) {
      _drawGrid(canvas, size);
    }

    // Draw stars
    for (var star in stars) {
      _drawStar(canvas, star, size);
    }

    // Draw exoplanets
    for (var exoplanet in exoplanets) {
      _drawExoplanet(canvas, exoplanet, size);
    }

    canvas.restore();
  }

  void _drawStar(Canvas canvas, Star star, Size size) {
    final position = _calculateStarPosition(star, size);
    if (position != null) {
      final brightness = _calculateApparentBrightness(star);
      final paint = Paint()
        ..color = _getStarColor(star)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(position, brightness / scale, paint);

      if (star.properName != null) {
        _drawStarName(canvas, star.properName!, position, size);
      }
    }
  }

  void _drawExoplanet(Canvas canvas, Exoplanet exoplanet, Size size) {
    final position = _calculateStarPosition(
      Star(
        sourceId: '0',
        rightAscension: exoplanet.rightAscension ?? 0,
        declination: exoplanet.declination ?? 0,
        parallax: 0,
        magnitude: 0,
      ),
      size,
    );
    if (position != null) {
      final paint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.fill;
      canvas.drawCircle(position, 3 / scale, paint);
      _drawStarName(canvas, exoplanet.name ?? 'Unknown', position, size);
    }
  }

  Offset? _calculateStarPosition(Star star, Size size) {
    // Convert equatorial coordinates to horizontal coordinates
    final double hourAngle = rightAscension - star.rightAscension;
    final double sinAlt =
        sin(star.declination * pi / 180) * sin(declination * pi / 180) +
            cos(star.declination * pi / 180) *
                cos(declination * pi / 180) *
                cos(hourAngle * pi / 12);
    final double alt = asin(sinAlt);
    final double cosAz = (sin(star.declination * pi / 180) -
            sin(declination * pi / 180) * sinAlt) /
        (cos(declination * pi / 180) * cos(alt));
    final double az = acos(cosAz.clamp(-1.0, 1.0));

    // Use stereographic projection to map the celestial sphere to a 2D plane
    final r = 2 * tan((pi / 2 - alt) / 2);
    final x = r * sin(az) * size.width / 4 + size.width / 2;
    final y = -r * cos(az) * size.height / 4 + size.height / 2;

    return Offset(x, y);
  }

  double _calculateApparentBrightness(Star star) {
    final distance = 1 / (star.parallax! / 1000); // Convert parallax to parsecs
    final apparentMagnitude =
        star.magnitude! + 5 * (log(distance / 10) / log(10));
    return 5 / (apparentMagnitude + 2);
  }

  Color _getStarColor(Star star) {
    // Estimate star color based on its temperature
    if (star.temperature == null) return Colors.white;

    if (star.temperature! < 3500) return Colors.red[300]!;
    if (star.temperature! < 5000) return Colors.orange[200]!;
    if (star.temperature! < 6000) return Colors.yellow[100]!;
    if (star.temperature! < 10000) return Colors.white;
    return Colors.blue[200]!;
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1 / scale;

    // Draw RA lines
    for (var i = 0; i < 24; i++) {
      final ra = i * pi / 12;
      final path = Path();
      bool started = false;
      for (var dec = -pi / 2; dec <= pi / 2; dec += 0.1) {
        final point = _calculateStarPosition(
          Star(
            sourceId: '0',
            rightAscension: ra * 12 / pi,
            declination: dec * 180 / pi,
            parallax: 0,
            magnitude: 0,
          ),
          size,
        );
        if (point != null) {
          if (!started) {
            path.moveTo(point.dx, point.dy);
            started = true;
          } else {
            path.lineTo(point.dx, point.dy);
          }
        }
      }
      canvas.drawPath(path, gridPaint);
    }

    // Draw Dec lines
    for (var i = -6; i <= 6; i++) {
      final dec = i * pi / 12;
      final path = Path();
      bool started = false;
      for (var ra = 0.0; ra <= 2 * pi; ra += 0.1) {
        final point = _calculateStarPosition(
          Star(
            sourceId: '0',
            rightAscension: ra * 12 / pi,
            declination: dec * 180 / pi,
            parallax: 0,
            magnitude: 0,
          ),
          size,
        );
        if (point != null) {
          if (!started) {
            path.moveTo(point.dx, point.dy);
            started = true;
          } else {
            path.lineTo(point.dx, point.dy);
          }
        }
      }
      canvas.drawPath(path, gridPaint);
    }
  }

  void _drawStarName(Canvas canvas, String name, Offset position, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: name,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10 / scale,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, position.translate(5 / scale, 5 / scale));
  }

  @override
  bool shouldRepaint(covariant StarChartPainter oldDelegate) {
    return oldDelegate.scale != scale ||
        oldDelegate.offset != offset ||
        oldDelegate.rightAscension != rightAscension ||
        oldDelegate.declination != declination ||
        oldDelegate.showGrid != showGrid;
  }
}
