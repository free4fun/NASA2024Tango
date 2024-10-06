import 'package:flutter/material.dart';
import 'package:exosky_tango/models/star.dart';
import 'dart:math';

class SkyView extends StatelessWidget {
  final List<Star> stars;
  final double fieldOfView; // in degrees

  const SkyView({Key? key, required this.stars, this.fieldOfView = 60})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = min(constraints.maxWidth, constraints.maxHeight);
        return Container(
          width: size,
          height: size,
          color: Colors.black,
          child: GestureDetector(
            onTapUp: (details) => _handleTap(context, details, size),
            child: CustomPaint(
              painter: StarFieldPainter(stars: stars, fieldOfView: fieldOfView),
            ),
          ),
        );
      },
    );
  }

  void _handleTap(BuildContext context, TapUpDetails details, double size) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(details.globalPosition);
    final double x = localPosition.dx / size * fieldOfView;
    final double y = localPosition.dy / size * fieldOfView;

    // Find the closest star to the tap position
    Star? closestStar;
    double minDistance = double.infinity;
    for (final star in stars) {
      final distance =
          sqrt(pow(star.rightAscension - x, 2) + pow(star.declination - y, 2));
      if (distance < minDistance) {
        minDistance = distance;
        closestStar = star;
      }
    }

    if (closestStar != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(closestStar!.id),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Apparent Magnitude: ${closestStar.apparentMagnitude?.toStringAsFixed(2)}'),
                Text(
                    'Distance: ${closestStar.distance.toStringAsFixed(2)} parsecs'),
                Text('Spectral Type: ${closestStar.spectralType}'),
                if (closestStar.temperature != null)
                  Text(
                      'Temperature: ${closestStar.temperature!.toStringAsFixed(0)} K'),
                if (closestStar.radius != null)
                  Text(
                      'Radius: ${closestStar.radius!.toStringAsFixed(2)} solar radii'),
                if (closestStar.luminosity != null)
                  Text(
                      'Luminosity: ${closestStar.luminosity!.toStringAsFixed(2)} solar luminosities'),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}

class StarFieldPainter extends CustomPainter {
  final List<Star> stars;
  final double fieldOfView;

  StarFieldPainter({required this.stars, required this.fieldOfView});

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final x = (star.rightAscension % fieldOfView) / fieldOfView * size.width;
      final y = (star.declination % fieldOfView) / fieldOfView * size.height;

      // Calculate star size based on magnitude (brighter stars appear larger)
      final starSize = (6 - (star.apparentMagnitude ?? 0)).clamp(0.5, 4.0);

      final paint = Paint()..color = star.color;
      canvas.drawCircle(Offset(x, y), starSize.toDouble(), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
