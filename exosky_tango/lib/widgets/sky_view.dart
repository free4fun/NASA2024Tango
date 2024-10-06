import 'dart:math';
import 'package:flutter/material.dart';
import 'package:exosky_tango/models/exoplanet.dart';
import 'package:exosky_tango/models/star.dart';

class SkyView extends StatefulWidget {
  final List<Exoplanet> exoplanets;
  final List<Star> stars;
  final Exoplanet? selectedExoplanet;
  final Function(Exoplanet) onExoplanetSelected;

  const SkyView({
    Key? key,
    required this.exoplanets,
    required this.stars,
    this.selectedExoplanet,
    required this.onExoplanetSelected,
  }) : super(key: key);

  @override
  State<SkyView> createState() => _SkyViewState();
}

class _SkyViewState extends State<SkyView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _scale = 1.0;
  Offset _offset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _controller.stop();
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_scale * details.scale).clamp(0.5, 5.0);
      _offset += details.focalPointDelta;
    });
  }

  void _handleTapDown(TapDownDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    final tappedExoplanet = _findTappedExoplanet(localPosition);
    if (tappedExoplanet != null) {
      widget.onExoplanetSelected(tappedExoplanet);
    }
  }

  Exoplanet? _findTappedExoplanet(Offset localPosition) {
    for (var exoplanet in widget.exoplanets) {
      final planetPosition = _calculatePosition(
        exoplanet.rightAscension ?? 0,
        exoplanet.declination ?? 0,
        context.size ?? Size.zero,
      );
      if ((planetPosition - localPosition).distance <= 10 / _scale) {
        return exoplanet;
      }
    }
    return null;
  }

  Offset _calculatePosition(
      double rightAscension, double declination, Size size) {
    // Convert right ascension (0-24h) to degrees (0-360)
    final ra = (rightAscension / 24) * 360;

    // Calculate x and y positions
    final x = (ra / 360) * size.width;
    final y = ((90 - declination) / 180) * size.height;

    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      onTapDown: _handleTapDown,
      child: ClipRect(
        child: CustomPaint(
          painter: SkyPainter(
            exoplanets: widget.exoplanets,
            stars: widget.stars,
            selectedExoplanet: widget.selectedExoplanet,
            scale: _scale,
            offset: _offset,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class SkyPainter extends CustomPainter {
  final List<Exoplanet> exoplanets;
  final List<Star> stars;
  final Exoplanet? selectedExoplanet;
  final double scale;
  final Offset offset;

  SkyPainter({
    required this.exoplanets,
    required this.stars,
    this.selectedExoplanet,
    required this.scale,
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.scale(scale);

    // Draw background
    final Paint backgroundPaint = Paint()..color = Colors.black;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Draw stars
    final Paint starPaint = Paint()..color = Colors.white;
    for (var star in stars) {
      final position =
          _calculatePosition(star.rightAscension, star.declination, size);
      final starSize = _calculateStarSize(star.magnitude ?? 0);
      canvas.drawCircle(position, starSize, starPaint);
    }

    // Draw exoplanets
    final Paint planetPaint = Paint()..color = Colors.blue;
    for (var planet in exoplanets) {
      final position = _calculatePosition(
          planet.rightAscension ?? 0, planet.declination ?? 0, size);
      final planetSize = _calculatePlanetSize(planet.planetRadius);
      canvas.drawCircle(position, planetSize, planetPaint);

      // Draw planet name
      final textPainter = TextPainter(
        text: TextSpan(
          text: planet.name ?? 'Unknown',
          style: TextStyle(color: Colors.white, fontSize: 10 / scale),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, position.translate(0, -10 / scale));
    }

    // Highlight selected exoplanet
    if (selectedExoplanet != null) {
      final position = _calculatePosition(
          selectedExoplanet!.rightAscension ?? 0,
          selectedExoplanet!.declination ?? 0,
          size);
      final Paint selectedPaint = Paint()
        ..color = Colors.yellow
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 / scale;
      canvas.drawCircle(
          position,
          _calculatePlanetSize(selectedExoplanet!.planetRadius) * 1.5,
          selectedPaint);
    }

    canvas.restore();
  }

  Offset _calculatePosition(
      double rightAscension, double declination, Size size) {
    // Convert right ascension (0-24h) to degrees (0-360)
    final ra = (rightAscension / 24) * 360;

    // Calculate x and y positions
    final x = (ra / 360) * size.width;
    final y = ((90 - declination) / 180) * size.height;

    return Offset(x, y);
  }

  double _calculateStarSize(double magnitude) {
    // Inverse relationship: brighter stars (lower magnitude) appear larger
    return max(0.5, 3 - (magnitude * 0.3));
  }

  double _calculatePlanetSize(double? radius) {
    // Use Earth radius as a reference (1 Earth radius = 2 pixels)
    return radius != null ? max(2.0, radius * 2) : 2.0;
  }

  @override
  bool shouldRepaint(covariant SkyPainter oldDelegate) =>
      exoplanets != oldDelegate.exoplanets ||
      stars != oldDelegate.stars ||
      selectedExoplanet != oldDelegate.selectedExoplanet ||
      scale != oldDelegate.scale ||
      offset != oldDelegate.offset;
}
