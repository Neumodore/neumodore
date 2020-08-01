import 'package:flutter/material.dart';
import 'package:neumodore/clean/data/neumodore_state.dart';
import 'package:neumodore/clean/presenters/neumodore_presenter.dart';
import 'package:neumodore/widgets/neumorphic/neumo_circle.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    implements PomodorePresenterContract {
  Color backgroundColor = true ? Color(0xFFefeeee) : Color(0xFF1c1f27);

  final neuProgressEndColor = Colors.redAccent;
  final neuProgressStartColor = Colors.greenAccent;

  final NeuProgressController neuProgressController = NeuProgressController();

  double _progressValue = 0.30;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                NeuProgressCircle(
                  initialValue: _progressValue,
                  backgroundColor: backgroundColor,
                  defaultDuration: Duration(seconds: 1),
                  controller: neuProgressController,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 50),
                  child: NeuButton(
                    onPressed: () async {
                      updateProgress(0);
                    },
                    padding: EdgeInsets.all(20),
                    child: Icon(Icons.remove),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 50),
                  child: NeuButton(
                    onPressed: () {
                      Get.toNamed('settings');
                    },
                    padding: EdgeInsets.all(20),
                    child: Icon(Icons.play_arrow),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 50),
                  child: NeuButton(
                    onPressed: () async {
                      updateProgress(1);
                    },
                    padding: EdgeInsets.all(20),
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void updateProgress(double newvalue) {
    setState(() {
      _progressValue = newvalue;
      neuProgressController.animateTo(newvalue);
    });
  }

  @override
  void onLoadPresenter(PomodoreState pomodore) {
    // TODO: implement onLoadPomodore
  }

  @override
  void onLoadStateError() {
    // TODO: implement onLoadPomodoreError
  }
}
