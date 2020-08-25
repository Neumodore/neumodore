import 'package:neumodore/domain/data/activity/activity.dart';

import 'change_settings_duration.dart';

class ChangeDurationRequest {
  ChangeType changeType;
  Duration duration;
  ActivityType activity;

  ChangeDurationRequest({
    this.activity,
    this.duration,
    this.changeType,
  });
}
