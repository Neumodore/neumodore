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

  final Curve introDefaultCurve;

  final Duration introDuration;

  NeuProgressCircle({
    Key key,
    this.controller,
    this.initialValue,
    this.child,
    this.defaultCurve = Curves.fastOutSlowIn,
    this.defaultDuration = const Duration(seconds: 1),
    this.initialColor = Colors.greenAccent,
    this.finalColor = Colors.redAccent,
    this.backgroundColor,
    this.introDefaultCurve = Curves.easeInOutCubic,
    this.introDuration = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  _NeuProgressCircleState createState() => _NeuProgressCircleState();
}

class _NeuProgressCircleState extends State<NeuProgressCircle>
    with TickerProviderStateMixin {
  double _currPercent = 0.0;

  Color _currColor;
  AnimationController fillController;

  AnimationController elevationController;
  double _currElevation = 0.0;

  Timer _drawUpdater;

  @override
  void initState() {
    super.initState();

    _drawUpdater = Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {});
    });
    initControllers();

    widget.controller.progressChangeStream.listen(this.animateTo);
    widget.controller.animateTo(widget.initialValue);

    elevationController.animateTo(
      1,
      curve: widget.introDefaultCurve,
      duration: widget.introDuration,
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
  void dispose() {
    _drawUpdater.cancel();
    this.fillController.dispose();
    this.elevationController.dispose();
    super.dispose();
  }

  void initControllers() {
    _currColor = widget.initialColor;

    elevationController = AnimationController(
      vsync: this,
      animationBehavior: AnimationBehavior.normal,
      lowerBound: 0,
      upperBound: 1,
      duration: Duration(seconds: 5),
    )..addListener(() {
        setState(() {
          _currElevation = lerpDouble(
            0,
            1,
            elevationController.value,
          );
        });
      });

    fillController = AnimationController(
      vsync: this,
      duration: widget.defaultDuration,
    )..addListener(() {
        setState(() {
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
        });
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
            painter: EmbossCirclePainter(
              100,
              backgroundColor:
                  widget.backgroundColor ?? Theme.of(context).backgroundColor,
              thickness: 9,
              width: 20,
              embossHeight: _currElevation,
            ),
          ),
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
        thickness: _currElevation * 25,
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
    this.value,
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

  Stream<ProgressRequest> get progressChangeStream =>
      _percentStreamController.stream;

  void dispose() {
    _percentStreamController.close();
  }
}
