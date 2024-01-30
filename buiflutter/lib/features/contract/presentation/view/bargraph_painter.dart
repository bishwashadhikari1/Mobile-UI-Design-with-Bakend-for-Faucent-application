import 'package:flutter/material.dart';
import 'package:talab/config/theme/app_color_constant.dart';

class BarGraphPainter extends CustomPainter {
  final double value;
  final double maxValue;
  final int divisions;

  BarGraphPainter(
      {required this.value, required this.maxValue, required this.divisions});

  @override
  void paint(Canvas canvas, Size size) {
    double barWidth = size.width / divisions;
    double divisionValue = maxValue / divisions;
    double minHeight = size.height * 0.2; // Minimum height of the first bar
    double heightIncrement = (size.height - minHeight) /
        (divisions - 1); // Incremental height increase for each bar

    Paint greyPaint = Paint()..color = Colors.grey[300]!;
    Paint bluePaint = Paint()..color = AppColorConstant.black;

    for (int i = 0; i < divisions; i++) {
      double left = i * barWidth;
      double barHeight = minHeight + heightIncrement * i;
      double top = size.height - barHeight;
      canvas.drawRect(
          Rect.fromLTWH(left, top, barWidth - 4, barHeight), greyPaint);
    }

    int highlightIndex =
        (value / divisionValue).floor().clamp(0, divisions - 1);
    double highlightLeft = highlightIndex * barWidth;
    double highlightHeight = minHeight + heightIncrement * highlightIndex;
    double highlightTop = size.height - highlightHeight;
    canvas.drawRect(
        Rect.fromLTWH(
            highlightLeft, highlightTop, barWidth - 4, highlightHeight),
        bluePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
