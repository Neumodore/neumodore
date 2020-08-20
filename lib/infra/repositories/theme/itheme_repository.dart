import 'package:flutter/material.dart';

abstract class IThemeRepository {
  Future<bool> setThemeMode(ThemeMode state);
  ThemeMode getThemeMode();
}
