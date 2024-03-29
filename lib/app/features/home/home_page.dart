import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neumodore/app/features/clickup/clickup_controller.dart';
import 'package:neumodore/app/widgets/neumorphic/animated_neumo_button.dart';
import 'package:neumodore/app/widgets/neumorphic/neumo_circle.dart';
import 'package:neumodore/domain/data/activity/activity.dart';
import 'package:neumodore/infra/controllers/session_controller/session_controller.dart';
import 'package:neumodore/shared/helpers/colors.dart';

class HomeScreen extends StatelessWidget {
  static String name = '/home';

  final SessionController _homePageCtrl = Get.find();
  final ClickupController _clickupCtrl = Get.find();

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
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildClickupLoginBtn(),
                ],
              ),
            ),
            Stack(
              fit: StackFit.loose,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildDotIndicator(context),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: Get.mediaQuery.size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GetBuilder<SessionController>(
                  builder: (_) {
                    return NeuProgressCircle(
                      child: Opacity(
                        opacity: 0.9,
                        child: Text(
                          '${_.timerOSD}',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.button.color),
                        ),
                      ),
                      initialValue: 0.01,
                      defaultDuration: Duration(seconds: 4),
                      defaultCurve: Curves.easeOutCirc,
                      initialColor: _getInitialColor(),
                      finalColor: _getFinalColor(),
                      controller: _homePageCtrl.neuProgressController,
                    );
                  },
                ),
              ],
            ),
            GetBuilder<SessionController>(
              builder: (_) {
                return _buildControlls(_.currentState);
              },
            ),
            SizedBox(
              height: 15,
            ),
            GetBuilder<ClickupController>(
              builder: (_) {
                return _buildClickupControlls(_);
              },
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildDotIndicator(BuildContext context) {
    return Container(
      height: 50,
      child: GetBuilder<SessionController>(
        builder: (_) {
          List<Widget> dots = [];
          for (int dotIdx = 0;
              dotIdx < _.session.sessionSettings.longIntervalLimit;
              dotIdx++) {
            dots.add(_buildLight(
              context,
              dotIdx,
              _.session.pastActivities,
              _.progressPercentage,
              _.session.currentActivity,
            ));
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: dots,
          );
        },
      ),
    );
  }

  Widget _buildLight(
    BuildContext context,
    int dotIndex,
    List<Activity> pastActivities,
    double percentageComplete,
    Activity currentActivity,
  ) {
    var empty = SizedBox();
    var poomoIndicator = _buildDot([
      Color.lerp(
        Colors.greenAccent[100],
        Colors.redAccent[100],
        percentageComplete,
      ),
      Color.lerp(
        Colors.greenAccent,
        Colors.redAccent,
        percentageComplete,
      ),
      Get.theme.backgroundColor.withOpacity(0)
    ]);
    var breakIndicator = _buildDot([
      Color.lerp(
        Colors.blueAccent[100],
        Colors.greenAccent[100],
        percentageComplete,
      ),
      Color.lerp(
        Colors.blue,
        Colors.green,
        percentageComplete,
      ),
      Get.theme.backgroundColor.withOpacity(0)
    ]);
    var longbreakIndicator = _buildDot([
      Color.lerp(
        Colors.purpleAccent[100],
        Colors.greenAccent[100],
        percentageComplete,
      ),
      Color.lerp(
        Colors.purple,
        Colors.green,
        percentageComplete,
      ),
      Get.theme.backgroundColor.withOpacity(0)
    ]);
    var finishIndicator = _buildDot([
      Color.lerp(
        Colors.orangeAccent[100],
        Colors.redAccent[100],
        1,
      ),
      Color.lerp(
        Colors.orangeAccent,
        Colors.redAccent,
        1,
      ),
      Get.theme.backgroundColor.withOpacity(0)
    ]);
    Widget usedDot = empty;

    Function isFinished = () {
      return (dotIndex < _homePageCtrl.finishedPomodores);
    };

    Function isCurrent = () {
      return (dotIndex == _homePageCtrl.finishedPomodores);
    };

    Function isInBreak = () {
      return !isFinished() && currentActivity.type == ActivityType.SHORT_BREAK;
    };
    Function isInLongBreak = () {
      return !isFinished() && currentActivity.type == ActivityType.LONG_BREAK;
    };
    Function isPomodore = () {
      return currentActivity.type == ActivityType.POMODORE;
    };

    if (isFinished()) {
      usedDot = finishIndicator;
    } else if (isCurrent()) {
      if (isPomodore()) {
        usedDot = poomoIndicator;
      }
      if (isInBreak()) {
        usedDot = breakIndicator;
      }
      if (isInLongBreak()) {
        usedDot = longbreakIndicator;
      }
    } else {
      usedDot = empty;
    }

    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeInOutCirc,
      duration: Duration(seconds: 1),
      builder: (ctx, val, child) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClayContainer(
          width: 20,
          height: 20,
          emboss: true,
          spread: 2,
          borderRadius: 100,
          depth: (30 * val).round(),
          color: Theme.of(context).backgroundColor,
          child: usedDot,
        ),
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
    final stopBtn = Container(
      padding: EdgeInsets.only(top: 50),
      child: FadedNeumoButton(
        onPressed: () {
          _homePageCtrl.stopSession();
        },
        child: Icon(Icons.stop),
      ),
    );
    final resumeBtn = Container(
      padding: EdgeInsets.only(top: 50),
      child: FadedNeumoButton(
        onPressed: () async {
          _homePageCtrl.resumeActivity();
        },
        padding: EdgeInsets.all(20),
        child: Icon(Icons.play_arrow),
      ),
    );

    final pauseBtn = Container(
      padding: EdgeInsets.only(top: 50),
      child: FadedNeumoButton(
        onPressed: () async {
          _homePageCtrl.pauseActivity();
        },
        padding: EdgeInsets.all(20),
        child: Icon(Icons.pause),
      ),
    );
    List<Widget> buttons = [];
    switch (state) {
      case ActivityState.COMPLETED:
        buttons = [_buildSkipBtn()];
        break;
      case ActivityState.PAUSED:
        buttons = [resumeBtn, _buildSkipBtn()];
        break;
      case ActivityState.RUNING:
        buttons = [pauseBtn, _buildPlusMinuteBtn(), _buildSkipBtn()];
        break;
      case ActivityState.STOPPED:
        buttons = [_buildStartBtn(), _buildPlusMinuteBtn(), _buildSkipBtn()];
        break;
    }

    if (_homePageCtrl.finishedPomodores > 0 || state != ActivityState.STOPPED) {
      buttons.insert(0, stopBtn);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons,
    );
  }

  Widget _buildClickupLoginBtn() {
    return Container(
      width: 50,
      child: GestureDetector(
        onTapUp: (tap) async {
          _clickupCtrl.authenticateOrLaunchClickup();
        },
        child: Image.asset(
          'assets/icons/clickup.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildPlusMinuteBtn() {
    return Container(
      padding: EdgeInsets.only(top: 50),
      child: FadedNeumoButton(
        onPressed: () async {
          _homePageCtrl.increaseDuration();
        },
        padding: EdgeInsets.all(20),
        child: Icon(Icons.exposure_plus_1),
      ),
    );
  }

  _buildSkipBtn() {
    IconData skipIcon = Icons.skip_next;

    switch (_homePageCtrl.session.currentActivity.type) {
      case ActivityType.POMODORE:
        if (_homePageCtrl.finishedPomodores < 3) {
          skipIcon = Icons.free_breakfast;
        } else {
          skipIcon = Icons.directions_run;
        }
        break;
      case ActivityType.SHORT_BREAK:
        skipIcon = Icons.work;
        break;
      default:
        skipIcon = Icons.repeat;
        break;
    }

    final skipBtn = Container(
      padding: EdgeInsets.only(top: 50),
      child: FadedNeumoButton(
        onPressed: () async {
          _homePageCtrl.skipActivity();
        },
        padding: EdgeInsets.all(20),
        child: Icon(skipIcon),
      ),
    );
    return skipBtn;
  }

  _buildStartBtn() {
    var workicon = Icons.play_arrow;

    final startBtn = Container(
      padding: EdgeInsets.only(top: 50),
      child: FadedNeumoButton(
        onPressed: () async {
          _homePageCtrl.startActivity();
        },
        padding: EdgeInsets.all(20),
        child: Icon(workicon),
      ),
    );
    return startBtn;
  }

  Color _getInitialColor() {
    return _homePageCtrl.session.currentActivity.type == ActivityType.POMODORE
        ? Colors.greenAccent
        : Colors.blue;
  }

  Color _getFinalColor() {
    return _homePageCtrl.session.currentActivity.type == ActivityType.POMODORE
        ? Colors.red
        : Colors.greenAccent;
  }

  Widget _buildClickupControlls(ClickupController click) {
    if (click.fromStatus != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ClayContainer(
              height: Get.height * 0.08,
              depth: 10,
              emboss: true,
              borderRadius: 20,
              curveType: CurveType.concave,
              color: Theme.of(Get.context).backgroundColor,
              child: PageView(
                physics: AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                controller: click.activePageView,
                scrollDirection: Axis.vertical,
                children: click
                    .fromTasks()
                    .map<Widget>(
                      (val) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Container(
                                  height: 5,
                                  width: 5,
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                        color: HexColor.fromHex(
                                            val["creator"]["color"]),
                                        blurRadius: 5,
                                        spreadRadius: 5)
                                  ], borderRadius: BorderRadius.circular(100)),
                                ),
                              ),
                              Container(
                                child: Text(val['name']),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.check,
                                  color: Colors.greenAccent,
                                ),
                                padding: EdgeInsets.all(10),
                                onPressed: () {
                                  click.closeTask();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }
}
