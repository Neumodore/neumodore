import 'package:neumodore/infra/configuration/configuration_repository.dart';
import 'package:neumodore/shared/core/use_case.dart';
import 'package:neumodore/domain/app_config/settings_entries.dart';
import 'package:neumodore/domain/usecases/settings/change_duration_request.dart';

class IncreaseConfigDurationCase
    implements UseCase<Future<ConfigurationEntry>, ChangeDurationRequest> {
  ISettingsRepository _configRepo;

  IncreaseConfigDurationCase(this._configRepo);

  @override
  Future<ConfigurationEntry> execute(ChangeDurationRequest argument) async {
    _increaseDuration(argument.configEntry, argument.ammount);
    return argument.configEntry;
  }

  void _increaseDuration(
    ConfigurationEntry config,
    Duration duration,
  ) async {
    final newValue = _storedValue(config) + duration;
    if (newValue.inMinutes <= 60)
      await _configRepo.setConfiguration(config, newValue);
  }

  Duration _storedValue(ConfigurationEntry config) {
    return _configRepo.getConfiguration(config);
  }
}
