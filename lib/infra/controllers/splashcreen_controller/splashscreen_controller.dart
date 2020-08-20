import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neumodore/infra/repositories/theme/itheme_repository.dart';

class SplashScreenController extends GetxController {
  IThemeRepository themeRepository;
  SplashScreenController(this.themeRepository);

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  @override
  void onInit() async {
    super.onInit();

    Future.delayed(Duration(milliseconds: 10), () {
      print({"Theme mode setted": themeRepository.getThemeMode()});
      Get.changeThemeMode(themeRepository.getThemeMode());
    });

    update();
    Future.delayed(Duration(milliseconds: 1500), () {
      Get.offAllNamed("/home");
    });
  }
}
