import 'package:neumodore/domain/data/activity/activity.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'iactivity_repo.dart';

const ACTIVITYKEY = 'active_activity';

class ActivityRepository implements IActivityRepository {
  SharedPreferences _dbContext;

  ActivityRepository(this._dbContext);

  @override
  Activity getActivity() {
    return Activity.fromJSON(_dbContext.getString(ACTIVITYKEY));
  }

  @override
  Future<bool> updateActivity(Activity activity) async {
    return _dbContext.setString(ACTIVITYKEY, activity.toJson());
  }

  @override
  Activity clearActivity(Activity activity) {}
}
