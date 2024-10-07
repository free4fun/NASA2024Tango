//testing new feature, by alejandro. its 19:50 and project is due soon so lets see

import 'package:flutter/material.dart';
import 'package:exosky_tango/models/exoplanet.dart'; // Import your Exoplanet model

class ConstellationPainter extends CustomPainter {
  final List<Exoplanet> planets;

  ConstellationPainter(this.planets);

  @override
  void paint(Canvas canvas, Size size) {
    if (planets.length < 2) return; // Ensure at least two planets are selected

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0;

    for (int i = 0; i < planets.length - 1; i++) {
      final Offset start = Offset(planets[i].x, planets[i].y);
      final Offset end = Offset(planets[i + 1].x, planets[i + 1].y);
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
