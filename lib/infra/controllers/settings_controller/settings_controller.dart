import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neumodore/infra/repositories/istate_repository.dart';

class SettingsController extends GetxController {
  IThemeRepository _themeRepo;

  ThemeMode _themeMode = ThemeMode.light;

  set themeMode(ThemeMode val) {
    _themeMode = val;
    update();
  }

  ThemeMode get themeMode => _themeMode;

  SettingsController(this._themeRepo) {
    _themeRepo.loadThemeMode().then((value) {
      themeMode = value;
      Get.changeThemeMode(themeMode);
    }).catchError((error) {
      print({'[LOAD THEME ERROR]': error});
      return Get.changeThemeMode(
        Get.isPlatformDarkMode ? ThemeMode.dark : ThemeMode.light,
      );
    });
  }

  @override
  void onInit() {
    super.onInit();
  }

  void switchTheme() async {
    ThemeMode curTheme = await _themeRepo.loadThemeMode();
    _themeRepo.saveThemeMode(
      curTheme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
    );
    update();
  }

  void setTheme(int val) async {
    try {
      await _themeRepo.saveThemeMode(_themeRepo.themeModeFromIndex(val));
      Get.changeThemeMode(_themeRepo.themeModeFromIndex(val));
    } catch (e) {
      print({'[----ERROR]': e});
    }

    update();
  }

  void refreshTheme() async {
    try {
      ThemeMode curTheme = await _themeRepo.loadThemeMode();
      Get.changeThemeMode(curTheme);
    } catch (e) {
      Get.changeThemeMode(
        Get.isPlatformDarkMode ? ThemeMode.dark : ThemeMode.light,
      );
    }
  }
}
