import 'package:flutter/material.dart';
import 'package:neumodore/infra/repositories/configuration/configuration_repository.dart';
import 'package:neumodore/shared/core/use_case.dart';

class SetDarkModeCase implements UseCase<ThemeMode, ThemeMode> {
  ConfigurationRepo _configRepo;

  SetDarkModeCase(this._configRepo);

  @override
  Future<ThemeMode> execute(ThemeMode argument) async {
    return argument;
  }
}
