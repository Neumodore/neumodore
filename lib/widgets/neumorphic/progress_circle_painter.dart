import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressCirclePainter extends CustomPainter {
  Color filledColor;

  double width;
  double filledPercentage;

  double thickness;

  bool onlyFill;

  double embossHeight = 1.0;

  ProgressCirclePainter(
      {this.filledColor = Colors.white,
      this.filledPercentage,
      this.thickness,
      this.width,
      this.embossHeight = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    int colorStep = 100;
    double blurSize = 6 * embossHeight;

    Offset center = Offset(size.width / 2, size.height / 2);

    double radius = min(size.width / 2, size.height / 2);

    double fillArcAngle = 2 * pi * (filledPercentage / 100);
    double translate = 13 * embossHeight;

    buildFillment(
      canvas,
      center,
      radius,
      fillArcAngle,
      blurSize,
    );
  }

  void buildFillment(
    Canvas canvas,
    Offset center,
    double radius,
    double fillArcAngle,
    double blurSize,
  ) {
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      fillArcAngle,
      false,
      Paint()
        ..color = filledColor
        ..strokeWidth = thickness
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawPath(
      Path()
        ..addArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
            fillArcAngle),
      Paint()
        ..color = filledColor
        ..strokeWidth = thickness / 2
        ..imageFilter = ImageFilter.blur(
          sigmaX: blurSize,
          sigmaY: blurSize,
        )
        ..style = PaintingStyle.stroke
        ..blendMode = BlendMode.plus
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
