import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'emboss_circle_painter.dart';
import 'progress_circle_painter.dart';

class NeuProgressCircle extends StatefulWidget {
  /// Initial value from circle goes from 0.0 to 1.0
  final double initialValue;

  /// Default animation duration
  final Duration defaultDuration;
  final Curve defaultCurve;

  final Color backgroundColor;
  final Color finalColor;

  final Color initialColor;
  final double embossHeight = 1;

  final NeuProgressController controller;

  final Widget child;

  NeuProgressCircle({
    this.controller,
    this.initialValue,
    this.child,
    this.defaultCurve = Curves.fastOutSlowIn,
    this.defaultDuration = const Duration(seconds: 1),
    this.backgroundColor = Colors.grey,
    this.initialColor = Colors.greenAccent,
    this.finalColor = Colors.redAccent,
  });

  @override
  _NeuProgressCircleState createState() => _NeuProgressCircleState();
}

class _NeuProgressCircleState extends State<NeuProgressCircle>
    with SingleTickerProviderStateMixin {
  double _currPercent = 0.0;
  Color _currColor;
  AnimationController fillController;

  @override
  void initState() {
    super.initState();

    initControllers();

    widget.controller.animationStream.listen(this.animateTo);
    widget.controller.animateTo(widget.initialValue);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initControllers() {
    _currColor = widget.initialColor;
    fillController = AnimationController(
      vsync: this,
      duration: widget.defaultDuration,
    )..addListener(
        () {
          setState(
            () {
              _currColor = Color.lerp(
                widget.initialColor,
                widget.finalColor,
                fillController.value,
              );
              _currPercent = lerpDouble(
                0,
                100,
                fillController.value,
              );
            },
          );
        },
      );
  }

  void animateTo(ProgressRequest value) {
    setState(() {
      fillController.animateTo(
        value.value,
        curve: value.curve ?? widget.defaultCurve,
        duration: value.duration ?? widget.defaultDuration,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 200,
      width: 200,
      child: Stack(
        children: <Widget>[
          CustomPaint(
            child: Center(
              child: widget.child,
            ),
            isComplex: true,
            foregroundPainter: EmbossCirclePainter(
              backgroundColor: widget.backgroundColor,
              filledPercentage: 100,
              thickness: 20,
              width: 20,
              embossHeight: widget.embossHeight,
            ),
          ),
          // circleFill(),
          _buildColorFill(),
          buildGlowFX()
        ],
      ),
    );
  }

  Widget buildGlowFX() {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: _buildColorFill(),
    );
  }

  CustomPaint _buildColorFill() {
    return CustomPaint(
      isComplex: true,
      child: Column(children: <Widget>[Row()]),
      foregroundPainter: ProgressCirclePainter(
        fillColor: _currColor,
        filledPercentage: _currPercent,
        thickness: 25,
        width: 20,
      ),
    );
  }
}

class ProgressRequest {
  final double value;
  final Curve curve;
  final Duration duration;

  ProgressRequest({
    this.value = 0.0,
    this.curve,
    this.duration,
  });
}

class NeuProgressController {
  final _percentStreamController =
      StreamController<ProgressRequest>.broadcast();

  void animateTo(
    double progressPercentage, {
    Curve curve,
    Duration animationDuration,
  }) {
    _percentStreamController.sink.add(ProgressRequest(
      value: progressPercentage,
      curve: curve,
      duration: animationDuration,
    ));
  }

  Stream<ProgressRequest> get animationStream =>
      _percentStreamController.stream;

  void dispose() {
    _percentStreamController.close();
  }
}
