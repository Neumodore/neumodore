import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmbossCirclePainter extends CustomPainter {
  Color filledColor;

  double width;
  double filledPercentage;

  double thickness;

  bool onlyFill;

  double embossHeight = 1.0;

  EmbossCirclePainter(
      {this.filledColor = Colors.white,
      this.filledPercentage,
      this.thickness,
      this.width,
      this.embossHeight = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    double blurSize = 6 * embossHeight;

    Offset center = Offset(size.width / 2, size.height / 2);

    double radius = min(size.width / 2, size.height / 2);

    double fillArcAngle = 2 * pi * (filledPercentage / 100);
    double translate = 13 * embossHeight;
    buildLight(
      canvas,
      center.translate(-translate, -translate),
      radius,
      fillArcAngle,
      blurSize / 1.5,
    );
    buildShadow(
      canvas,
      center.translate(translate, translate),
      radius,
      fillArcAngle,
      blurSize,
    );
    buildFillment(canvas, center, radius, fillArcAngle);
  }

  void buildFillment(
      Canvas canvas, Offset center, double radius, double fillArcAngle) {
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
  }

  void buildLight(Canvas canvas, Offset center, double radius,
      double fillArcAngle, double blurSize) {
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      fillArcAngle,
      false,
      Paint()
        ..color = Colors.grey[700]
        ..strokeWidth = thickness * 5 / (radius)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..blendMode = BlendMode.plus
        ..imageFilter = ImageFilter.blur(sigmaX: blurSize, sigmaY: blurSize),
    );
  }

  void buildShadow(
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
        ..color = Colors.grey[700]
        ..strokeWidth = thickness * 10 / (radius)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..blendMode = BlendMode.darken
        ..imageFilter = ImageFilter.blur(sigmaX: blurSize, sigmaY: blurSize),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
