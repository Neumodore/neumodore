import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neumodore/app/features/home/home_page_controller.dart';
import 'package:neumodore/app/widgets/neumorphic/neumo_button.dart';
import 'package:neumodore/app/widgets/neumorphic/neumo_circle.dart';
import 'package:neumorphic/neumorphic.dart';

class HomeScreen extends StatelessWidget {
  final Color backgroundColor = true ? Color(0xFFefeeee) : Color(0xFF1c1f27);
  final neuProgressEndColor = Colors.redAccent;
  final neuProgressStartColor = Colors.greenAccent;

  final NeuProgressController _neuProgressController = NeuProgressController();

  final HomePageController _homePageCtrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Neumodore',
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GetBuilder<HomePageController>(
                builder: (_) => Text(
                      """Duration
${_.durationOSD}
Pomodores: ${_.finishedPomodores}""",
                      style: Theme.of(context).primaryTextTheme.headline6,
                      textAlign: TextAlign.center,
                    )),
            SizedBox(
              height: Get.mediaQuery.size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                NeuProgressCircle(
                  child: GetBuilder<HomePageController>(
                    builder: (_) {
                      _neuProgressController.animateTo(_.progressPercentage);
                      return Text(
                        '${_.timerOSD}',
                        style: TextStyle(fontSize: 24),
                      );
                    },
                  ),
                  initialValue: 0.1,
                  backgroundColor: backgroundColor,
                  defaultDuration: Duration(seconds: 1),
                  controller: _neuProgressController,
                ),
              ],
            ),
            GetBuilder<HomePageController>(builder: (_) {
              return _buildControlls(_.currentState);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildControlls(HomePageState state) {
    switch (state) {
      case HomePageState.PAUSED:
        return _buildPausedControlls();
        break;
      case HomePageState.RUNING:
        return _buildPlayingControlls();
        break;
      case HomePageState.STOPPED:
        return _buildStoppedControlls();
        break;
      case HomePageState.FINISHED:
        return _buildStoppedControlls();
        break;
    }
    return _buildPlayingControlls();
  }

  Row _buildStoppedControlls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 50),
          child: NeumoButton(
            onPressed: () async {
              _homePageCtrl.startPomodore();
            },
            padding: EdgeInsets.all(20),
            backgroundColor: backgroundColor,
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
            backgroundColor: backgroundColor,
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
            backgroundColor: backgroundColor,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 50),
          child: NeumoButton(
            onPressed: () async {
              _homePageCtrl.pausePomodore();
            },
            padding: EdgeInsets.all(20),
            backgroundColor: backgroundColor,
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
            backgroundColor: backgroundColor,
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
            backgroundColor: backgroundColor,
            child: Icon(Icons.skip_next),
          ),
        ),
      ],
    );
  }

  Row _buildPausedControlls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 50),
          child: NeumoButton(
            onPressed: () async {
              _homePageCtrl.resumePomodore();
            },
            padding: EdgeInsets.all(20),
            backgroundColor: backgroundColor,
            child: Icon(Icons.play_arrow),
          ),
        ),
      ],
    );
  }
}
