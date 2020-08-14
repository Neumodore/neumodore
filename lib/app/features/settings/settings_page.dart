import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neumodore/app/features/home/home_page.dart';
import 'package:neumodore/app/widgets/neumorphic/neumo_button.dart';
import 'package:neumodore/app/widgets/neumorphic/neumo_circle.dart';
import 'package:neumodore/infra/controllers/settings_controller/settings_controller.dart';
import 'package:neumorphic/neumorphic.dart' as neumoLib;

class SettingsScreen extends StatefulWidget {
  static String name = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final NeuProgressController neuProgressController = NeuProgressController();

  final SettingsController _settingsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          leading: SizedBox(),
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: _buildTopBar(context),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Get.back();
          return false;
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    "enable_night_mode".tr,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  GetBuilder<SettingsController>(
                    builder: (_) {
                      return neumoLib.NeuSwitch(
                        backgroundColor: Get.theme.backgroundColor,
                        groupValue: Get.isDarkMode ? 2 : 1,
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
              'settings_title'.tr,
              style:
                  Theme.of(context).textTheme.headline6.copyWith(fontSize: 34),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: NeumoButton(
                onPressed: () {
                  Get.back();
                },
                child: Icon(Icons.chevron_left),
              ),
            )
          ],
        ),
      ),
    );
  }
}
