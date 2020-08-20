import 'package:flutter/material.dart';

import 'package:neumodore/infra/repositories/theme/itheme_repository.dart';
import 'package:neumodore/shared/core/use_case.dart';

class LoadThemeModeUseCase implements UseCase<ThemeMode, ThemeMode> {
  IThemeRepository _themeRepo;

  LoadThemeModeUseCase(this._themeRepo);

  @override
  ThemeMode execute(ThemeMode defaultMode) =>
      _themeRepo?.getThemeMode() ?? defaultMode;
}
