import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neumodore/app/widgets/neumorphic/neumo_button.dart';
import 'package:neumodore/infra/controllers/settings_controller/settings_controller.dart';

import 'package:neumorphic/neumorphic.dart' as neumoLib;

class SettingsScreen extends StatelessWidget {
  static String name = '/settings';
  final SettingsController _settingsCtrl = Get.find();

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GetBuilder<SettingsController>(
          builder: (_) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildTextSeparator(context, 'durations_section'.tr),
              _buildStepperRow(
                context,
                name: "pomodore_duration".tr,
                value: _.pomodoreInterval,
                onPlus: () =>
                    _settingsCtrl.plusPomodoreDuration(Duration(minutes: 1)),
                onMinus: () =>
                    _settingsCtrl.decreasePomodore(Duration(minutes: 1)),
              ),
              _buildStepperRow(
                context,
                name: "shortbreak_duration".tr,
                value: _.shortBreakInterval,
                onPlus: () =>
                    _settingsCtrl.plusShortBreakDuration(Duration(minutes: 1)),
                onMinus: () =>
                    _settingsCtrl.decreaseShortBreak(Duration(minutes: 1)),
              ),
              _buildStepperRow(
                context,
                name: "longbreak_duration".tr,
                value: _.longBreakInterval,
                onPlus: () =>
                    _settingsCtrl.plusLongBreakDuration(Duration(minutes: 1)),
                onMinus: () =>
                    _settingsCtrl.decreaseLongBreak(Duration(minutes: 1)),
              ),
              _buildTextSeparator(context, 'appearence_section'.tr),
              _buildNightModeSwitch(context),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildStepperRow(
    BuildContext context, {
    String name,
    String value,
    onPlus,
    onMinus,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(
            name,
            style: Theme.of(context).textTheme.button,
          ),
        ),
        _buildStepper(
          context,
          value: value,
          onPlus: onPlus,
          onMinus: onMinus,
        ),
      ],
    );
  }

  Widget _buildStepper(
    BuildContext context, {
    String value,
    VoidCallback onPlus,
    VoidCallback onMinus,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: NeumoButton(
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: Icon(Icons.remove),
            onPressed: onMinus,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            value,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: NeumoButton(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Icon(Icons.add),
            onPressed: onPlus,
          ),
        )
      ],
    );
  }

  _buildTextSeparator(context, text) => _buildSeparator(
        context,
        child: Text(
          text,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      );

  Widget _buildNightModeSwitch(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              "enable_night_mode".tr,
              style: Theme.of(context).textTheme.button,
            ),
          ),
          neumoLib.NeuSwitch(
            backgroundColor: Get.theme.backgroundColor,
            groupValue: Get.isDarkMode ? (Get.isPlatformDarkMode ? 1 : 2) : 1,
            children: {
              1: Icon(Icons.brightness_high),
              2: Icon(Icons.brightness_3)
            },
            onValueChanged: (themeMode) {
              _settingsCtrl.setTheme(themeMode);
            },
          )
        ],
      ),
    );
  }

  Widget _buildSeparator(context, {Widget child}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ClayContainer(
          color: Theme.of(context).backgroundColor,
          borderRadius: 100,
          depth: 10,
          spread: 2,
          curveType: CurveType.none,
          emboss: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 15,
            ),
            child: child,
          ),
        ),
      ],
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
                  Get.offAndToNamed('/home');
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
