import 'package:flutter/foundation.dart';
import 'package:neumodore/domain/data/app_config/settings_entries.dart';

class ChangeDurationRequest {
  ConfigurationEntry configEntry;
  Duration ammount;

  ChangeDurationRequest({@required configuration, @required value})
      : this.configEntry = configuration,
        this.ammount = value;
}
