import 'package:get/get.dart';
import 'package:neumodore/app/features/home/home_page.dart';
import 'package:neumodore/app/features/intro/intro.dart';
import 'package:neumodore/app/features/purchases/purchases_page.dart';
import 'package:neumodore/app/features/settings/settings_page.dart';
import 'package:neumodore/infra/controllers/purchases_controller/purchases_controller_binding.dart';
import 'package:neumodore/infra/controllers/session_controller/session_controller_binding.dart';
import 'package:neumodore/infra/controllers/settings_controller/settings_controler_bindings.dart';
import 'package:neumodore/infra/controllers/splashcreen_controller/splashscreen_binding.dart';

final routes = [
  GetPage(
    name: IntroScreen.name,
    page: () => IntroScreen(),
    bindings: [
      SettingsScreenBinding(),
      SplashScreenBinding(),
    ],
  ),
  //Simple GetPage
  GetPage(
    name: HomeScreen.name,
    page: () => HomeScreen(),
    transition: Transition.leftToRight,
    bindings: [
      SessionControllerBinding(),
    ],
  ),
  GetPage(
    name: SettingsScreen.name,
    page: () => SettingsScreen(),
    transition: Transition.rightToLeft,
    title: "Settings",
    binding: SettingsScreenBinding(),
  ),
  GetPage(
    name: PurchasesPage.name,
    page: () => PurchasesPage(),
    transition: Transition.native,
    title: "Purchases",
    binding: PurchasesBinding(),
  )
];
