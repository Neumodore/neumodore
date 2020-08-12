import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neumodore/infra/controllers/pomodore_controller/pomodore_controller.dart';
import 'package:neumodore/app/widgets/neumorphic/neumo_button.dart';
import 'package:neumodore/app/widgets/neumorphic/neumo_circle.dart';

class HomeScreen extends StatelessWidget {
  final neuProgressEndColor = Colors.redAccent;
  final neuProgressStartColor = Colors.greenAccent;

  final PomodoreController _homePageCtrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
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
            GetBuilder<PomodoreController>(
                builder: (_) => Text(
                      """Duration
${_.durationOSD}
Pomodores: ${_.finishedPomodores}""",
                      textAlign: TextAlign.center,
                    )),
            SizedBox(
              height: Get.mediaQuery.size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                NeuProgressCircle(
                  child: GetBuilder<PomodoreController>(
                    builder: (_) {
                      return Text(
                        '${_.timerOSD}',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      );
                    },
                  ),
                  initialValue: 0.01,
                  defaultDuration: Duration(seconds: 4),
                  defaultCurve: Curves.easeOutQuart,
                  controller: _homePageCtrl.neuProgressController,
                ),
              ],
            ),
            NeumoButton(
                child: Icon(Icons.refresh),
                onPressed: () {
                  _homePageCtrl.animateTo(0.5);
                }),
            GetBuilder<PomodoreController>(builder: (_) {
              return _buildControlls(_.getState());
            }),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 50,
                      child: GetBuilder<PomodoreController>(builder: (_) {
                        List<Widget> dots = [];
                        if (_.finishedPomodores > 0) {
                          for (var i = 0; i < _.finishedPomodores; i++) {
                            dots.add(_buildDot());
                          }
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: dots,
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
              'Neumodore',
              style:
                  Theme.of(context).textTheme.headline6.copyWith(fontSize: 34),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: NeumoButton(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Icon(Icons.settings),
                onPressed: () => Get.toNamed('settings'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _buildDot() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Colors.redAccent[100],
            Colors.redAccent,
            Colors.white.withOpacity(0)
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildControlls(ControllerState state) {
    switch (state) {
      case ControllerState.PAUSED:
        return _buildPausedControlls();
        break;
      case ControllerState.RUNING:
        return _buildPlayingControlls();
        break;
      case ControllerState.STOPPED:
        return _buildStoppedControlls();
        break;
      case ControllerState.COMPLETED:
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
          child: NeumoButton(
            onPressed: () async {
              _homePageCtrl.startPomodore();
            },
            padding: EdgeInsets.all(20),
            child: Icon(Icons.play_arrow),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 50),
          child: NeumoButton(
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
          child: NeumoButton(
            onPressed: () {
              _homePageCtrl.stopPomodore();
            },
            child: Icon(Icons.stop),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 50),
          child: NeumoButton(
            onPressed: () async {
              _homePageCtrl.pausePomodore();
            },
            padding: EdgeInsets.all(20),
            child: Icon(Icons.pause),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 50),
          child: NeumoButton(
            onPressed: () async {
              _homePageCtrl.addOneMinute();
            },
            padding: EdgeInsets.all(20),
            child: Icon(Icons.exposure_plus_1),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 50),
          child: NeumoButton(
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
          child: NeumoButton(
            onPressed: () {
              _homePageCtrl.stopPomodore();
            },
            child: Icon(Icons.stop),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 50),
          child: NeumoButton(
            onPressed: () async {
              _homePageCtrl.resumePomodore();
            },
            padding: EdgeInsets.all(20),
            child: Icon(Icons.play_arrow),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 50),
          child: NeumoButton(
            onPressed: () async {
              _homePageCtrl.addOneMinute();
            },
            padding: EdgeInsets.all(20),
            child: Icon(Icons.exposure_plus_1),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 50),
          child: NeumoButton(
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
