import 'dart:math';
import 'package:flutter/material.dart';


class PercentageIndicator extends StatelessWidget {
  const PercentageIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomPaint(
            painter: PercentageIndicatorPainter(
              percentage: 75, // Set the desired percentage value
              strokeWidth: 10, // Set the desired stroke width
              primaryColor: Colors.blue, // Set the desired primary color
              backgroundColor: Colors.grey, // Set the desired background color
            ),
            child: const  SizedBox(
              width: 200,
              height: 200,
              child: Center(
                child: Text(
                  '75%', // Set the desired percentage value
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PercentageIndicatorPainter extends CustomPainter {
  final double percentage;
  final double strokeWidth;
  final Color primaryColor;
  final Color backgroundColor;

  PercentageIndicatorPainter({
    required this.percentage,
    required this.strokeWidth,
    required this.primaryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final startAngle = -pi / 2;
    final sweepAngle = 2 * pi * (percentage / 100);

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(Offset(centerX, centerY), radius, backgroundPaint);

    // Draw percentage arc
    final arcPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
