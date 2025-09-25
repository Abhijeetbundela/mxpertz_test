import 'dart:math' as math;

import 'package:flutter/material.dart';

class DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final int numberOfDashes;
  final double dashSpaceRatio;
  final double startAngleOffset;

  DashedCirclePainter({
    this.color = Colors.orange,
    this.strokeWidth = 2.0,
    this.numberOfDashes = 12,
    this.dashSpaceRatio = 0.6,
    this.startAngleOffset = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double radius = size.width / 2 - strokeWidth / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    final double totalCircumference = 2 * math.pi * radius;
    final double totalDashSpaceUnits = numberOfDashes * (1 + dashSpaceRatio);
    final double dashLength = totalCircumference / totalDashSpaceUnits;
    final double spaceLength = dashLength * dashSpaceRatio;

    double startAngle = -math.pi / 2 + startAngleOffset; // Apply static offset

    for (int i = 0; i < numberOfDashes; i++) {
      final double sweepAngle = (dashLength / radius);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle + (spaceLength / radius);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is DashedCirclePainter) {
      return oldDelegate.color != color ||
          oldDelegate.strokeWidth != strokeWidth ||
          oldDelegate.numberOfDashes != numberOfDashes ||
          oldDelegate.dashSpaceRatio != dashSpaceRatio ||
          oldDelegate.startAngleOffset != startAngleOffset;
    }
    return true;
  }
}
