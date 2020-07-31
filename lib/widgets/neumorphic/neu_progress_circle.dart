import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:neumodore/widgets/neumorphic/emboss_circle_painter.dart';
import 'package:neumodore/widgets/neumorphic/progress_circle_painter.dart';
import 'package:neumorphic/neumorphic.dart';

class NeuProgressCircle extends StatefulWidget {
  final Color backgroundColor;

  NeuProgressCircle({this.backgroundColor = Colors.grey});

  @override
  _NeuProgressCircleState createState() => _NeuProgressCircleState();
}

class _NeuProgressCircleState extends State<NeuProgressCircle>
    with SingleTickerProviderStateMixin {
  double filledPercent = 0;
  double embossHeight = 1;

  AnimationController fillAnimationCtrl;

  @override
  void initState() {
    super.initState();
    initControllers();
  }

  double _nextPercentage = 0;

  void initControllers() {
    this.fillAnimationCtrl =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
          ..addListener(
            () {
              setState(
                () {
                  filledPercent = lerpDouble(
                      filledPercent, _nextPercentage, fillAnimationCtrl.value);
                },
              );
            },
          );
  }

  void startProgress() {
    setState(() {
      if (_nextPercentage > 0)
        _nextPercentage = 0;
      else
        _nextPercentage = 100;
    });
    fillAnimationCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          height: 200,
          width: 200,
          child: Stack(
            children: <Widget>[
              CustomPaint(
                child: Center(
                    child: Text('${_nextPercentage.toStringAsFixed(2)}')),
                foregroundPainter: EmbossCirclePainter(
                    filledColor: this.widget.backgroundColor,
                    filledPercentage: 100,
                    thickness: 20,
                    width: 300,
                    embossHeight: embossHeight),
              ),
              // circleFill(),
              _glowCircle(),
              buildGlowFX()
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 50),
          child: NeuButton(
            onPressed: () {
              startProgress();
            },
            padding: EdgeInsets.all(20),
            child: Text("Animar"),
          ),
        )
      ],
    );
  }

  Widget buildGlowFX() {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: _glowCircle(),
    );
  }

  CustomPaint _glowCircle() {
    return CustomPaint(
      child: Center(child: Text('')),
      foregroundPainter: ProgressCirclePainter(
        filledColor: Colors.greenAccent[400],
        filledPercentage: filledPercent,
        thickness: 25,
        width: 20,
      ),
    );
  }
}
