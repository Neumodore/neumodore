import 'package:get/get.dart';
import 'package:neumodore/app/features/home/home_page.dart';
import 'package:neumodore/app/features/settings/settings_page.dart';
import 'package:neumodore/infra/controllers/pomodore_controller/pomodore_controller_binding.dart';

final routes = [
  //Simple GetPage
  GetPage(
    name: '/home',
    page: () => HomeScreen(),
    binding: PomodoreControllerBinding(),
  ), // GetPage with custom transitions and bindings
  GetPage(
    name: '/settings',
    page: () => SettingsScreen(),
  ),
];
