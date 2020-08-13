import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const THEME_STORAGE_KEY = 'theme_key';

class ThemeModeRepository {
  ThemeModeRepository();

  Future<ThemeMode> getThemeMode() async {
    return fromIndex(int.parse((await SharedPreferences.getInstance())
        .getString(THEME_STORAGE_KEY)
        .toString()));
  }

  Future setThemeMode(ThemeMode mode) async {
    await (await SharedPreferences.getInstance())
        .setString(THEME_STORAGE_KEY, mode.index.toString());
  }

  ThemeMode fromIndex(int inx) {
    return ThemeMode.values.elementAt(inx);
  }
}
