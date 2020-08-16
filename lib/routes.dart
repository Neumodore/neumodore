import 'package:get/get.dart';
import 'package:neumodore/app/features/home/home_page.dart';
import 'package:neumodore/app/features/settings/settings_page.dart';
import 'package:neumodore/infra/controllers/pomodore_controller/pomodore_controller_binding.dart';
import 'package:neumodore/infra/controllers/settings_controller/settings_controler_bindings.dart';
import 'package:neumodore/infra/controllers/splashcreen_controller/splashscreen_binding.dart';

import 'app/features/intro/intro.dart';

final routes = [
  GetPage(
    name: IntroScreen.name,
    page: () => IntroScreen(),
    bindings: [
      SplashScreenBinding(),
      SettingsScreenBinding(),
    ],
  ),
  //Simple GetPage
  GetPage(
    name: HomeScreen.name,
    page: () => HomeScreen(),
    transition: Transition.leftToRight,
    bindings: [
      PomodoreControllerBinding(),
    ],
  ),
  GetPage(
    name: SettingsScreen.name,
    page: () => SettingsScreen(),
    transition: Transition.rightToLeft,
    title: "Settings",
    binding: SettingsScreenBinding(),
  ),
];
