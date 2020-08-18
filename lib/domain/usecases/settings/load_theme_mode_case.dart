import 'package:flutter/material.dart';

import 'package:neumodore/infra/repositories/itheme_repository.dart';
import 'package:neumodore/shared/core/use_case.dart';

class LoadThemeModeUseCase implements UseCase<Future<ThemeMode>, dynamic> {
  IThemeRepository _themeRepo;

  LoadThemeModeUseCase(this._themeRepo);

  @override
  Future<ThemeMode> execute(_) async => _themeRepo.getThemeMode();
}
