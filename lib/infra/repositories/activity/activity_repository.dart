import 'dart:convert';

import 'package:neumodore/domain/data/activity/activity.dart';
import 'package:neumodore/infra/repositories/activity/iactivity_repo.dart';

import 'package:shared_preferences/shared_preferences.dart';

const ACTIVITYKEY = 'active_activity';

class ActivityRepository implements IActivityRepository {
  SharedPreferences _dbContext;

  ActivityRepository(this._dbContext);

  @override
  Activity getActivity() {
    return Activity.fromJson(jsonDecode(_dbContext.getString(ACTIVITYKEY)));
  }

  @override
  Future<bool> updateActivity(Activity activity) async {
    return _dbContext.setString(ACTIVITYKEY, jsonEncode(activity.toJson()));
  }

  @override
  Activity clearActivity(Activity activity) {
    updateActivity(Activity());
    return getActivity();
  }
}
