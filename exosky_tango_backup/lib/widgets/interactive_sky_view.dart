import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vector;
import '../models/exoplanet.dart';

class InteractiveSkyView extends StatefulWidget {
  final List<Exoplanet> exoplanets;

  const InteractiveSkyView({super.key, required this.exoplanets});

  @override
  _InteractiveSkyViewState createState() => _InteractiveSkyViewState();
}

class _InteractiveSkyViewState extends State<InteractiveSkyView> {
  double _rotationX = 0;
  double _rotationY = 0;
  double _scale = 1;

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _rotationY += details.delta.dx * 0.01;
      _rotationX -= details.delta.dy * 0.01;
    });
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale *= details.scale;
      _scale = _scale.clamp(0.5, 3.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onScaleUpdate: _onScaleUpdate,
      child: Container(
        color: Colors.black,
        child: CustomPaint(
          painter: StarFieldPainter(
            exoplanets: widget.exoplanets,
            rotationX: _rotationX,
            rotationY: _rotationY,
            scale: _scale,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class StarFieldPainter extends CustomPainter {
  final List<Exoplanet> exoplanets;
  final double rotationX;
  final double rotationY;
  final double scale;

  StarFieldPainter({
    required this.exoplanets,
    required this.rotationX,
    required this.rotationY,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..color = Colors.white;

    for (var exoplanet in exoplanets) {
      if (exoplanet.radius != null && exoplanet.mass != null) {
        // Crear una posición 3D basada en la masa y el radio
        final position = vector.Vector3(
          exoplanet.mass! * 10,
          exoplanet.radius! * 10,
          0,
        );

        // Aplicar rotaciones
        position.applyAxisAngle(vector.Vector3(1, 0, 0), rotationX);
        position.applyAxisAngle(vector.Vector3(0, 1, 0), rotationY);

        // Proyectar el punto 3D en el espacio 2D
        final projectedX = position.x * scale + center.dx;
        final projectedY = position.y * scale + center.dy;

        // Dibujar el punto
        canvas.drawCircle(
          Offset(projectedX, projectedY),
          2,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(StarFieldPainter oldDelegate) {
    return oldDelegate.rotationX != rotationX ||
        oldDelegate.rotationY != rotationY ||
        oldDelegate.scale != scale;
  }
}
