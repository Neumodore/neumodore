import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:neumodore/domain/data/activity/activity.dart';
import 'package:neumodore/domain/data/session/session_settings.dart';
import 'package:neumodore/infra/configuration/configuration_repository.dart';
import 'package:neumodore/infra/repositories/activity/activity_repository.dart';
import 'package:neumodore/infra/repositories/activity/iactivity_repo.dart';
import 'package:neumodore/infra/repositories/session/isession_repository.dart';
import 'package:neumodore/infra/repositories/session/session_repository.dart';
import 'package:neumodore/infra/repositories/theme/itheme_repository.dart';
import 'package:neumodore/infra/repositories/theme/theme_repository.dart';
import 'package:neumodore/infra/services/audio/audio_service_concrete.dart';
import 'package:neumodore/infra/services/audio/iaudio_service.dart';
import 'package:neumodore/infra/services/local_reminder_service.dart';
import 'package:neumodore/infra/services/screen/iscreen_service.dart';
import 'package:neumodore/infra/services/screen/screen_service_concrete.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'session_controller.dart';

class SessionControllerBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut<IAudioService>(
      () => AudioServiceConcrete(),
    );
    Get.lazyPut<IScreenService>(
      () => ScreenServiceConcrete(),
    );

    Get.lazyPut<ISettingsRepository>(
      () => SettingsRepo(
        Get.find<SharedPreferences>(),
      ),
    );

    Get.lazyPut<IThemeRepository>(
      () => ThemeRepository(
        Get.find<ISettingsRepository>(),
      ),
    );

    Get.lazyPut<IActivityRepository>(
      () => ActivityRepository(
        Get.find<SharedPreferences>(),
      ),
    );

    Get.lazyPut<ISessionRepository>(
      () => SessionRepository(
        Get.find<SharedPreferences>(),
        SessionSettings(
          PomodoreActivity(duration: Duration(minutes: 25)),
          ShortBreakActivity(duration: Duration(minutes: 5)),
          LongBreakActivity(duration: Duration(minutes: 15)),
          4,
        ),
      ),
    );

    Get.put<FlutterLocalNotificationsPlugin>(
      FlutterLocalNotificationsPlugin(),
    );

    Get.put<LocalReminderService>(
      LocalReminderService(
        Get.find<FlutterLocalNotificationsPlugin>(),
      ),
    );

    Get.put<SessionController>(
      SessionController(
        Get.find<ISessionRepository>(),
        Get.find<ISettingsRepository>(),
        Get.find<IScreenService>(),
        Get.find<LocalReminderService>(),
      ),
      permanent: true,
    );
  }
}
