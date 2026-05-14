import 'package:flutter/material.dart';
import 'dart:math' as math;

class NexusLogoWidget extends StatelessWidget {
  const NexusLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 200), 
      painter: _NexusOrbPainter(),
    );
  }
}

class _NexusOrbPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;
    const baseColor = Colors.cyanAccent;
    
    const double spacing = 15.0;
    const int gridLimit = 4;

    for (int i = -gridLimit; i <= gridLimit; i++) {
      for (int j = -gridLimit; j <= gridLimit; j++) {
        

        double valI = i.abs().toDouble();
        double valJ = j.abs().toDouble();
        double shapeLogic = math.pow(valI, 3.0).toDouble() + math.pow(valJ, 3.0).toDouble();
        double maxRadius = math.pow(gridLimit.toDouble(), 3.0).toDouble();

        if (shapeLogic <= maxRadius) {
          double x = center.dx + i * spacing;
          double y = center.dy + j * spacing;
          double realDist = math.sqrt(i * i + j * j);

          double dotSize;
          if (i == 0 && j == 0) {
            dotSize = 9.0; 
          } else {

            dotSize = (7.5 - (realDist * 0.8)).clamp(2.0, 7.5);
          }

          double normalizedDist = realDist / (gridLimit * 1.2);
          double opacity = (1.0 - math.pow(normalizedDist, 2.0)).clamp(0.0, 1.0);

          if (shapeLogic > maxRadius * 0.7) {
            opacity *= 0.5; 
          }

          paint.color = baseColor.withOpacity(opacity);

          canvas.drawCircle(Offset(x, y), dotSize, paint);

          if (realDist < 1.5) {
            canvas.drawCircle(
              Offset(x, y),
              dotSize * 1.5,
              Paint()..color = baseColor.withOpacity(0.1),
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}