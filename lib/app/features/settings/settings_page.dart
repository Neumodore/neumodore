import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neumodore/app/widgets/neumorphic/neumo_circle.dart';
import 'package:neumodore/themes.dart';
import 'package:neumorphic/neumorphic.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final NeuProgressController neuProgressController = NeuProgressController();

  String currentTheme = 'light';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.backgroundColor,
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("Switch theme"),
                NeuSwitch(
                  backgroundColor: Get.theme.backgroundColor,
                  groupValue: currentTheme,
                  children: {
                    'dark': Icon(Icons.brightness_5),
                    'light': Icon(Icons.brightness_7)
                  },
                  onValueChanged: (val) {
                    val == 'dark'
                        ? Get.changeTheme(NeumodoreThemes.dark())
                        : Get.changeTheme(NeumodoreThemes.light());
                    setState(() {
                      currentTheme = val;
                    });
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[],
            ),
          ],
        ),
      ),
    );
  }
}
