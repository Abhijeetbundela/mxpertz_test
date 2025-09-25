import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'dashed_circle_painter.dart';

class GradientButtonWithDoubleDashedBorder extends StatelessWidget {
  final VoidCallback onPressed;
  final double buttonSize;
  final double iconSize;
  final List<Color>? gradientColors;
  final Color iconColor;
  final Color? outerDashColor;
  final double outerDashStrokeWidth;
  final int outerNumberOfDashes;
  final double outerDashSpaceRatio;
  final double outerBorderPadding;
  final double outerBorderStartAngleOffset;
  final Color? innerDashColor;
  final double innerDashStrokeWidth;
  final int innerNumberOfDashes;
  final double innerDashSpaceRatio;
  final double innerBorderPadding;
  final double innerBorderStartAngleOffset;

  const GradientButtonWithDoubleDashedBorder({
    super.key,
    required this.onPressed,
    this.buttonSize = 42,
    this.iconSize = 24.0,
    this.gradientColors,
    this.iconColor = Colors.white,
    this.outerDashColor,
    this.outerDashStrokeWidth = 2.0,
    this.outerNumberOfDashes = 1,
    this.outerDashSpaceRatio = 0.5,
    this.outerBorderPadding = 4.0,
    this.outerBorderStartAngleOffset = math.pi / 1,
    this.innerDashColor,
    this.innerDashStrokeWidth = 2,
    this.innerNumberOfDashes = 1,
    this.innerDashSpaceRatio = 0.7,
    this.innerBorderPadding = 3.0,
    this.innerBorderStartAngleOffset = 5.4,
  });

  @override
  Widget build(BuildContext context) {
    final double innerDashesPainterSize =
        buttonSize + (innerBorderPadding * 2) + (innerDashStrokeWidth * 2);
    final double outerDashesPainterSize =
        innerDashesPainterSize +
        (outerBorderPadding * 2) +
        (outerDashStrokeWidth * 2);

    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: Size(outerDashesPainterSize, outerDashesPainterSize),
          painter: DashedCirclePainter(
            color: outerDashColor ?? Colors.orange.shade300,
            strokeWidth: outerDashStrokeWidth,
            numberOfDashes: outerNumberOfDashes,
            dashSpaceRatio: outerDashSpaceRatio,
            startAngleOffset: outerBorderStartAngleOffset,
          ),
        ),
        CustomPaint(
          size: Size(innerDashesPainterSize, innerDashesPainterSize),
          painter: DashedCirclePainter(
            color: innerDashColor ?? Colors.orange.shade700,
            strokeWidth: innerDashStrokeWidth,
            numberOfDashes: innerNumberOfDashes,
            dashSpaceRatio: innerDashSpaceRatio,
            startAngleOffset: innerBorderStartAngleOffset,
          ),
        ),
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors:
                    gradientColors ??
                    [Colors.yellow.shade700, Colors.orange.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Icon(Icons.arrow_forward, color: iconColor, size: iconSize),
          ),
        ),
      ],
    );
  }
}
