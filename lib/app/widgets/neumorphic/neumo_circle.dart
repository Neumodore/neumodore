import 'dart:async';
import 'dart:ui';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

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

  Color _filledColor;
  AnimationController fillController;

  AnimationController fillColorController;
  double _embossAnimation = 0.0;
  AnimationController embossController;
  double _fillAnimation = 0.0;
  AnimationController thicknessController;
  double _thicknessAnimation = 0.0;

  StreamSubscription<ProgressRequest> subscription;

  @override
  void initState() {
    super.initState();

    initControllers();

    subscription = widget.controller.progressChangeStream.listen(animateTo);
    widget.controller.animateTo(widget.initialValue);
  }

  void animateTo(ProgressRequest value) {
    if (this != null) {
      setState(() {
        fillController?.animateTo(
          value.value,
          curve: value.curve ?? widget.defaultCurve,
          duration: value.duration ?? widget.defaultDuration,
        );
      });
    }
  }

  @override
  void dispose() {
    fillController?.dispose();
    fillColorController?.dispose();
    thicknessController?.dispose();
    embossController?.dispose();
    subscription.cancel();
    super.dispose();
  }

  void initControllers() async {
    _filledColor = widget.initialColor;

    fillColorController = AnimationController(
      vsync: this,
      animationBehavior: AnimationBehavior.normal,
      lowerBound: 0,
      upperBound: 1,
      duration: Duration(seconds: 5),
    )..addListener(() {
        setState(() {
          _fillAnimation = lerpDouble(
            0,
            1,
            fillColorController.value,
          );
        });
      });

    embossController = AnimationController(
      vsync: this,
      animationBehavior: AnimationBehavior.normal,
      duration: Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {
          _embossAnimation = lerpDouble(
            0,
            1,
            embossController.value,
          );
        });
      });

    thicknessController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..addListener(() {
        setState(() {
          _thicknessAnimation = lerpDouble(
            0,
            1,
            thicknessController.value,
          );
        });
      });

    fillController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..addListener(() {
        setState(() {
          _filledColor = Color.lerp(
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

    fillColorController.animateTo(
      .01,
      curve: widget.introDefaultCurve,
      duration: Duration(milliseconds: 100),
    )..whenComplete(() {
        embossController.animateTo(
          1,
          curve: widget.introDefaultCurve,
          duration: widget.introDuration * .2,
        )..whenComplete(
            () {
              thicknessController.animateTo(
                1,
                curve: widget.introDefaultCurve,
                duration: widget.introDuration * .4,
              )..whenComplete(() => fillColorController.animateTo(
                    1,
                    curve: widget.introDefaultCurve,
                    duration: widget.introDuration * .5,
                  ));
            },
          );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      height: 200,
      width: 200,
      child: Stack(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: ClayContainer(
                color: Theme.of(context).backgroundColor,
                borderRadius: 100,
                depth: (_embossAnimation * 10).toInt(),
                spread: 5,
                emboss: true,
                curveType: CurveType.concave,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: ClayContainer(
                color: Theme.of(context).backgroundColor,
                borderRadius: 100,
                depth: (_embossAnimation * 10).toInt(),
                spread: 10,
                emboss: false,
                curveType: CurveType.concave,
              ),
            ),
          ),
          Opacity(
            opacity: _thicknessAnimation * 1,
            child: Center(
              child: widget.child,
            ),
          ),
          _buildColorFill(),
          _buildGlowFX()
        ],
      ),
    );
  }

  Widget _buildGlowFX() {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: _buildColorFill(),
    );
  }

  Widget _buildColorFill() {
    return Container(
      padding: EdgeInsets.all(15),
      child: CustomPaint(
        isComplex: true,
        child: Column(children: <Widget>[Row()]),
        foregroundPainter: ProgressCirclePainter(
          fillColor: _filledColor,
          filledPercentage: _fillAnimation * _currPercent,
          thickness: _thicknessAnimation * 25,
          width: 20,
        ),
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
