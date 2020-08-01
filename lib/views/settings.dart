import 'package:flutter/material.dart';
import 'package:neumodore/widgets/neumorphic/neumo_circle.dart';
import 'package:neumorphic/neumorphic.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
              children: <Widget>[],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 50),
                  child: NeuButton(
                    onPressed: () async {
                      updateProgress(.01);
                    },
                    padding: EdgeInsets.all(20),
                    child: Text("- -"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 50),
                  child: NeuButton(
                    onPressed: () {},
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "${_progressValue.toStringAsFixed(2)}",
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 50),
                  child: NeuButton(
                    onPressed: () async {
                      updateProgress(1);
                    },
                    padding: EdgeInsets.all(20),
                    child: Text("++"),
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
      neuProgressController.animateTo(
        newvalue,
      );
    });
  }
}
