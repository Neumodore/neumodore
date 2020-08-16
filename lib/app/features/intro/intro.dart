import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:neumodore/infra/controllers/settings_controller/settings_controller.dart';
import 'package:neumodore/themes.dart';

class IntroScreen extends StatelessWidget {
  static String name = '/intro';

  // ignore: unused_field
  final SettingsController _settingsCtrl = Get.find();

  @override
  Widget build(context) => TweenAnimationBuilder(
        duration: Duration(seconds: 1),
        tween: Tween<double>(begin: 0, end: 1),
        curve: Curves.easeInOutCubic,
        child: Container(),
        builder: (ctx, value, widget) {
          return Scaffold(
            backgroundColor: Color.lerp(
              NeumodoreThemes.light().backgroundColor,
              Get.theme.backgroundColor,
              value,
            ),
          );
        },
      );
}
