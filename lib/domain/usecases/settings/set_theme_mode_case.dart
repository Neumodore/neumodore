import 'package:flutter/material.dart';
import 'package:neumodore/infra/repositories/itheme_repository.dart';
import 'package:neumodore/shared/core/use_case.dart';

class SetThemeModeUseCase implements UseCase<Future<ThemeMode>, ThemeMode> {
  IThemeRepository _themeRepo;

  SetThemeModeUseCase(this._themeRepo);

  @override
  Future<ThemeMode> execute(ThemeMode themeMode) async {
    await _themeRepo.setThemeMode(themeMode);
    return _themeRepo.getThemeMode();
  }
}
