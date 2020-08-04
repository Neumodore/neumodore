import 'package:flutter/material.dart';
import 'package:neumodore/app/features/home/home_presenter.dart';
import 'package:neumodore/app/features/home/home_presenter_contract.dart';
import 'package:neumodore/app/widgets/neumorphic/neumo_button.dart';
import 'package:neumodore/app/widgets/neumorphic/neumo_circle.dart';
import 'package:neumorphic/neumorphic.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    implements HomePresenterContract {
  Color backgroundColor = true ? Color(0xFFefeeee) : Color(0xFF1c1f27);
  final neuProgressEndColor = Colors.redAccent;
  final neuProgressStartColor = Colors.greenAccent;

  final NeuProgressController _neuProgressController = NeuProgressController();

  HomePresenter _presenter;

  _HomeScreenState() {
    _presenter = HomePresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _presenter.loadPomodoreState();
  }

  @override
  void onLoadState(HomePresenterState pomodore) {
    _updateProgress(pomodore);
  }

  @override
  void onUpdateState(HomePresenterState pomodore) {
    _updateProgress(pomodore);
  }

  void _updateProgress(HomePresenterState newvalue) {
    setState(() {
      _neuProgressController.animateTo(newvalue.percentageComplete);
    });
  }

  @override
  void onLoadStateError(Error pomod) {
    // TODO: implement onLoadStateError
  }
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
                  child: Text("${_presenter.getState.remainingTime}"),
                  initialValue: 0.01,
                  backgroundColor: backgroundColor,
                  defaultDuration: Duration(seconds: 1),
                  controller: _neuProgressController,
                ),
              ],
            ),
            _buildControlls(),
          ],
        ),
      ),
    );
  }

  Widget _buildControlls() {
    switch (_presenter.getState.activityState) {
      case ActivityState.PAUSED:
        return _buildPausedControlls();
        break;
      case ActivityState.RUNING:
        return _buildPlayingControlls();
        break;
      case ActivityState.STOPPED:
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
          child: NeuButton(
            onPressed: () async {},
            padding: EdgeInsets.all(20),
            child: Icon(Icons.exposure_plus_1),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 50),
          child: NeuButton(
            onPressed: () async {},
            padding: EdgeInsets.all(20),
            child: Icon(Icons.play_arrow),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 50),
          child: NeuButton(
            onPressed: () async {},
            padding: EdgeInsets.all(20),
            child: Icon(Icons.skip_next),
          ),
        ),
      ],
    );
  }

  Row _buildPlayingControlls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 50),
          child: NeumoButton(
            onPressed: () {},
            child: Icon(Icons.stop),
            backgroundColor: backgroundColor,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 50),
          child: NeumoButton(
            onPressed: () async {
              _presenter.pausePomodore();
            },
            padding: EdgeInsets.all(20),
            backgroundColor: backgroundColor,
            child: Icon(Icons.pause),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 50),
          child: NeumoButton(
            onPressed: () async {},
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
              _presenter.resumePomodore();
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
