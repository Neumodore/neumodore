import 'package:neumodore/domain/data/activity/activity.dart';

abstract class IActivityRepository {
  Activity getActivity();
  Future<bool> updateActivity(Activity activity);
  Activity clearActivity(Activity activity);
}
