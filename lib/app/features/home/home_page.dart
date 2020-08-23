import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:neumodore/app/widgets/neumorphic/animated_neumo_button.dart';
import 'package:neumodore/domain/data/activity/activity.dart';
import 'package:neumodore/app/widgets/neumorphic/neumo_circle.dart';
import 'package:neumodore/infra/controllers/session_controller/session_controller.dart';

class HomeScreen extends StatelessWidget {
  static String name = '/home';
  final neuProgressEndColor = Colors.redAccent;
  final neuProgressStartColor = Colors.greenAccent;

  final SessionController _homePageCtrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          leading: SizedBox(),
          elevation: 0,
          backgroundColor: Colors.transparent,
          primary: true,
          flexibleSpace: _buildTopBar(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildDotIndicator(context),
            SizedBox(
              height: Get.mediaQuery.size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                NeuProgressCircle(
                  child: GetBuilder<SessionController>(
                    builder: (_) {
                      return ClayText(
                        '${_.timerOSD}',
                        emboss: true,
                        depth: 40,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.button.color),
                      );
                    },
                  ),
                  initialValue: 0.01,
                  defaultDuration: Duration(seconds: 4),
                  defaultCurve: Curves.easeOutCirc,
                  controller: _homePageCtrl.neuProgressController,
                ),
              ],
            ),
            GetBuilder<SessionController>(builder: (_) {
              return _buildControlls(_.currentState);
            }),
            SizedBox(
              height: 50,
            ),
//             GetBuilder<SessionController>(
//               builder: (_) => Text(
//                 """Duration
// ${_.durationOSD}
// Pomodores: ${_.finishedPomodores}
// State: ${_.currentState.toString()}
// Type: ${_.session.currentActivity.type.toString()}""",
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.headline6,
//               ),
//             ),
          ],
        ),
      ),
    );
  }

  Padding _buildDotIndicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 50,
              child: GetBuilder<SessionController>(
                builder: (_) {
                  List<Widget> dots = [];
                  for (var currentDot = 0; currentDot < 4; currentDot++) {
                    dots.add(_buildLight(
                      context,
                      currentDot,
                      _.finishedPomodores,
                      _.progressPercentage,
                    ));
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: dots,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildLight(
    BuildContext context,
    int currentDot,
    int finishedPomodores,
    double percentageComplete,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClayContainer(
        width: 20,
        height: 20,
        emboss: true,
        spread: 2,
        borderRadius: 100,
        depth: 30,
        color: Theme.of(context).backgroundColor,
        child: currentDot < finishedPomodores
            ? _buildDot(currentDot == finishedPomodores && finishedPomodores > 0
                ? [
                    Color.lerp(
                      Colors.orangeAccent[100],
                      Colors.redAccent[100],
                      percentageComplete,
                    ),
                    Color.lerp(
                      Colors.orangeAccent,
                      Colors.redAccent,
                      percentageComplete,
                    ),
                    Get.theme.backgroundColor.withOpacity(0)
                  ]
                : [
                    Colors.redAccent[100],
                    Colors.redAccent,
                    Get.theme.backgroundColor.withOpacity(0)
                  ])
            : SizedBox(),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'title'.tr,
              style:
                  Theme.of(context).textTheme.headline6.copyWith(fontSize: 34),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FadedNeumoButton(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Icon(Icons.settings),
                onPressed: _homePageCtrl.goToSettings,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDot(colors) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeInOutCubic,
      duration: Duration(seconds: 1),
      builder: (ctx, val, child) => Opacity(
          opacity: val,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: colors,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: child,
          )),
      child: SizedBox(),
    );
  }

  Widget _buildControlls(ActivityState state) {
    switch (state) {
      case ActivityState.PAUSED:
        return _buildPausedControlls();
        break;
      case ActivityState.RUNING:
        return _buildPlayingControlls();
        break;
      case ActivityState.STOPPED:
        return _buildStoppedControlls();
        break;
      case ActivityState.COMPLETED:
        return _buildStoppedControlls();
        break;
    }
    return _buildPlayingControlls();
  }

  Row _buildStoppedControlls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 50),
          child: FadedNeumoButton(
            onPressed: () async {
              _homePageCtrl.startActivity();
            },
            padding: EdgeInsets.all(20),
            child: Icon(Icons.play_arrow),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 50),
          child: FadedNeumoButton(
            onPressed: () async {
              _homePageCtrl.skipActivity();
            },
            padding: EdgeInsets.all(20),
            child: Icon(Icons.skip_next),
          ),
        ),
      ],
    );
  }

  Row _buildPlayingControlls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 50),
          child: FadedNeumoButton(
            onPressed: () {
              _homePageCtrl.stopSession();
            },
            child: Icon(Icons.stop),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 50),
          child: FadedNeumoButton(
            onPressed: () async {
              _homePageCtrl.pauseActivity();
            },
            padding: EdgeInsets.all(20),
            child: Icon(Icons.pause),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 50),
          child: FadedNeumoButton(
            onPressed: () async {
              _homePageCtrl.increaseDuration();
            },
            padding: EdgeInsets.all(20),
            child: Icon(Icons.exposure_plus_1),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 50),
          child: FadedNeumoButton(
            onPressed: () async {
              _homePageCtrl.skipActivity();
            },
            padding: EdgeInsets.all(20),
            child: Icon(Icons.skip_next),
          ),
        ),
      ],
    );
  }

  Row _buildPausedControlls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 50),
          child: FadedNeumoButton(
            onPressed: () {
              _homePageCtrl.stopSession();
            },
            child: Icon(Icons.stop),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 50),
          child: FadedNeumoButton(
            onPressed: () async {
              _homePageCtrl.resumeActivity();
            },
            padding: EdgeInsets.all(20),
            child: Icon(Icons.play_arrow),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 50),
          child: FadedNeumoButton(
            onPressed: () async {
              _homePageCtrl.increaseDuration();
            },
            padding: EdgeInsets.all(20),
            child: Icon(Icons.exposure_plus_1),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 50),
          child: FadedNeumoButton(
            onPressed: () async {
              _homePageCtrl.skipActivity();
            },
            padding: EdgeInsets.all(20),
            child: Icon(Icons.skip_next),
          ),
        ),
      ],
    );
  }
}
