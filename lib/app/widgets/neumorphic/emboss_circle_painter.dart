import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmbossCirclePainter extends CustomPainter {
  double currentPercentage;

  Color backgroundColor;
  double width;
  double thickness;
  double embossHeight;

  Paint fillPaint = Paint();
  Paint lightPaint = Paint();
  Paint shadowPaint = Paint();

  EmbossCirclePainter(
    this.currentPercentage, {
    this.backgroundColor = Colors.white,
    this.thickness,
    this.width = 20,
    this.embossHeight = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double blurSize = 9 * embossHeight;

    Offset center = Offset(size.width / 2, size.height / 2);

    double radius = min(size.width / 2, size.height / 2);
    double arcAngle = 2 * pi * (currentPercentage);
    double shadowDistance = 5 * embossHeight;

    double outerRadius = radius * 1.05;
    Function innerRadius = (multiplier) {
      final calced = outerRadius - (thickness * multiplier);
      return calced > outerRadius - 6 ? outerRadius - 6 : calced;
    };
    Function innerShadowRadius = (multiplier) {
      final calced = innerRadius(multiplier);
      return calced > outerRadius - 5 ? outerRadius - 5 : calced;
    };

    var fillCenter = center;
    Path fillBorder = Path.combine(
      PathOperation.difference,
      Path()..addOval(Rect.fromCircle(center: fillCenter, radius: outerRadius)),
      Path()
        ..addOval(Rect.fromCircle(center: fillCenter, radius: innerRadius(1))),
    );

    var lightCenter = center.translate(-shadowDistance, -shadowDistance);
    Path lightBorder = Path.combine(
      PathOperation.difference,
      Path.combine(
        PathOperation.difference,
        Path()
          ..addOval(
            Rect.fromCircle(center: lightCenter, radius: outerRadius * 0.97),
          ),
        Path()
          ..addOval(
              Rect.fromCircle(center: lightCenter, radius: innerRadius(0.7))),
      ),
      fillBorder,
    );
    Offset shadowCenter = center.translate(shadowDistance, shadowDistance);
    Path shadowBorder = Path.combine(
      PathOperation.difference,
      Path.combine(
        PathOperation.difference,
        Path()
          ..addOval(
              Rect.fromCircle(center: shadowCenter, radius: outerRadius * 1.0)),
        Path()
          ..addOval(Rect.fromCircle(
              center: shadowCenter, radius: innerShadowRadius(1))),
      ),
      fillBorder,
    );

    canvas
      ..drawPath(
        shadowBorder,
        Paint()
          ..color = Colors.black.withOpacity(0.5)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSize)
          ..blendMode = BlendMode.colorBurn,
      );

    canvas
      ..drawPath(
        lightBorder,
        Paint()
          ..color = Colors.white.withOpacity(0.5)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSize)
          ..blendMode = BlendMode.plus,
      );

    Rect boundingSquare = Rect.fromCircle(center: center, radius: radius);

    gradientPaint(List<Color> colors,
        {double startAngle = 0.0, double endAngle = pi * 2}) {
      final Gradient gradient = LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

      return Paint()
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
        ..shader = gradient.createShader(boundingSquare);
    }

    var gradientStartAngle = 2 * pi / 2;
    var gradientEndAngle = 6 * pi / 2;
    var lightlerp = Color.lerp(backgroundColor, Colors.white, 0.05);
    var shadowlerp = Color.lerp(backgroundColor, Colors.black, 0.05);

    var startColor = Color.lerp(shadowlerp, lightlerp, 1 * embossHeight);
    var endCOlor = Color.lerp(lightlerp, shadowlerp, 1 * embossHeight);
    canvas
      ..drawPath(
        fillBorder,
        gradientPaint(
          [startColor, endCOlor],
          endAngle: gradientEndAngle,
          startAngle: gradientStartAngle,
        ),
      );
  }

  @override
  bool shouldRepaint(EmbossCirclePainter oldDelegate) => true;
}
