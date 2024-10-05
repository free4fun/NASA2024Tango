import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vector;
import '../models/exoplanet.dart';
import '../models/star.dart';

class InteractiveSkyView extends StatefulWidget {
  final Exoplanet exoplanet;
  final List<Star> stars;

  InteractiveSkyView({required this.exoplanet, required this.stars});

  @override
  _InteractiveSkyViewState createState() => _InteractiveSkyViewState();
}

class _InteractiveSkyViewState extends State<InteractiveSkyView> {
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  late Size _size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        _size = context.size!;
      },
      onScaleUpdate: (details) {
        setState(() {
          _scale = details.scale;
          _offset += details.focalPointDelta;
          _offset = Offset(
            _offset.dx.clamp(-_size.width, _size.width),
            _offset.dy.clamp(-_size.height, _size.height),
          );
        });
      },
      child: CustomPaint(
        painter: SkyPainter(
          exoplanet: widget.exoplanet,
          stars: widget.stars,
          scale: _scale,
          offset: _offset,
        ),
        child: Container(),
      ),
    );
  }
}

class SkyPainter extends CustomPainter {
  final Exoplanet exoplanet;
  final List<Star> stars;
  final double scale;
  final Offset offset;

  SkyPainter({
    required this.exoplanet,
    required this.stars,
    required this.scale,
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    canvas.translate(offset.dx, offset.dy);
    canvas.scale(scale);

    // Dibuja el fondo del cielo
    Paint skyPaint = Paint()..color = Colors.black;
    canvas.drawRect(
        Rect.fromLTWH(
            -size.width / 2, -size.height / 2, size.width, size.height),
        skyPaint);

    // Dibuja las estrellas
    for (var star in stars) {
      Paint starPaint = Paint()..color = _getStarColor(star.temperature);
      double starSize = _getStarSize(star.magnitude);
      vector.Vector3 starPosition = _getStarPosition(star);
      canvas.drawCircle(
          Offset(starPosition.x, starPosition.y), starSize, starPaint);
    }
  }

  Color _getStarColor(double temperature) {
    if (temperature > 30000) return Colors.blue[200]!;
    if (temperature > 10000) return Colors.white;
    if (temperature > 7500) return Colors.yellow[200]!;
    if (temperature > 6000) return Colors.yellow;
    if (temperature > 5000) return Colors.orange;
    return Colors.red;
  }

  double _getStarSize(double magnitude) {
    return max(1.0, 5.0 - magnitude);
  }

  vector.Vector3 _getStarPosition(Star star) {
    // Simplificación: proyección de coordenadas esféricas a cartesianas
    double theta =
        star.rightAscension * pi / 12; // Convertir ascensión recta a radianes
    double phi =
        (90 - star.declination) * pi / 180; // Convertir declinación a radianes

    double x = 1000 * sin(phi) * cos(theta);
    double y = 1000 * sin(phi) * sin(theta);
    double z = 1000 * cos(phi);

    return vector.Vector3(x, y, z);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
