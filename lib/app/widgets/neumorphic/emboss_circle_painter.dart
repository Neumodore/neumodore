import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmbossCirclePainter extends CustomPainter {
  double currentPercentage;

  Color backgroundColor;
  double width;
  double thickness;
  double embossHeight = 1.0;

  Paint fillPaint = Paint();
  Paint lightPaint = Paint();
  Paint shadowPaint = Paint();

  EmbossCirclePainter(
    this.currentPercentage, {
    this.backgroundColor = Colors.white,
    this.thickness,
    this.width,
    this.embossHeight = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double blurSize = 6 * embossHeight;

    Offset center = Offset(size.width / 2, size.height / 2);

    double radius = min(size.width / 2, size.height / 2);

    double fillArcAngle = 2 * pi * (currentPercentage / 100);
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
      fillPaint
        ..color = backgroundColor
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
      lightPaint
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
      shadowPaint
        ..color = Colors.black87
        ..strokeWidth = thickness * 10 / (radius)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..blendMode = BlendMode.darken
        ..imageFilter = ImageFilter.blur(sigmaX: blurSize, sigmaY: blurSize),
    );
  }

  @override
  bool shouldRepaint(EmbossCirclePainter oldDelegate) =>
      oldDelegate.currentPercentage != this.currentPercentage;
}
