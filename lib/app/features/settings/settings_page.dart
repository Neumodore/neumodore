import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neumodore/app/widgets/neumorphic/neumo_circle.dart';
import 'package:neumodore/infra/controllers/settings_controller/settings_controller.dart';
import 'package:neumorphic/neumorphic.dart' as neumoLib;

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final NeuProgressController neuProgressController = NeuProgressController();

  final SettingsController _settingsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headline5,
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
                Text("Change theme mode"),
                GetBuilder<SettingsController>(
                  builder: (_) {
                    return neumoLib.NeuSwitch(
                      backgroundColor: Get.theme.backgroundColor,
                      groupValue: _settingsController.themeMode.index,
                      children: {
                        1: Icon(Icons.brightness_high),
                        2: Icon(Icons.brightness_3)
                      },
                      onValueChanged: (themeMode) {
                        _settingsController.setTheme(themeMode);
                      },
                    );
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
