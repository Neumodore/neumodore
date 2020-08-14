import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neumodore/infra/repositories/istate_repository.dart';
import 'package:neumodore/routes.dart';

class SplashScreenController extends GetxController {
  IThemeRepository themeRepository;
  SplashScreenController(this.themeRepository);

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();

    Get.changeThemeMode(await themeRepository.loadThemeMode());
    update();
    Future.delayed(Duration(milliseconds: 1000), () {
      Get.offNamedUntil("/home", (route) => false);
    });
  }
}
