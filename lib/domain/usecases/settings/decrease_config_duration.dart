import 'package:neumodore/domain/data/app_config/settings_entries.dart';
import 'package:neumodore/domain/usecases/settings/change_duration_request.dart';
import 'package:neumodore/infra/repositories/configuration/configuration_repository.dart';
import 'package:neumodore/shared/core/use_case.dart';

class DecreaseConfigDurationCase
    implements UseCase<ChangeDurationRequest, ConfigurationEntry> {
  ConfigurationRepo _configRepo;

  DecreaseConfigDurationCase(this._configRepo);

  @override
  Future<ConfigurationEntry> execute(ChangeDurationRequest argument) async {
    await _decreaseDuration(argument.configEntry, argument.ammount);
    return argument.configEntry;
  }

  _decreaseDuration(
    ConfigurationEntry config,
    Duration duration,
  ) async {
    final newValue = _storedValue(config) - duration;
    if (newValue.inMinutes > 0)
      await _configRepo.setConfiguration(config, newValue);
  }

  dynamic _storedValue(ConfigurationEntry config) {
    final fromStore = _configRepo.getConfiguration(config);
    return fromStore;
  }
}
