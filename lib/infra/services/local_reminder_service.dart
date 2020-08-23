import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalReminderService {
  FlutterLocalNotificationsPlugin localNotifications;

  LocalReminderService(this.localNotifications) {
    var iosInitializationSettings = IOSInitializationSettings(
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );
    var androidInitializationSettings = AndroidInitializationSettings(
      '@drawable/ic_timer',
    );

    var initializationSettings = InitializationSettings(
      androidInitializationSettings,
      iosInitializationSettings,
    );

    localNotifications.initialize(
      initializationSettings,
      onSelectNotification: _onSelectNotification,
    );
  }

  scheduleProgress({
    Duration timeoutDuration = const Duration(seconds: 1),
    String msgTitle = "Activity runing",
    String msgBody = 'Activity end...',
    int notificationID = 21,
    bool showWhenStamp = false,
    Color iconColor = Colors.blue,
    String channelID = "notification_progress",
    String channelTitle = "Progress from pomodores",
    String channelDescription = "Notifications that remind the pomodore",
    String iconResName = "ic_timer",
  }) async {
    Int64List vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    localNotifications.schedule(
      notificationID,
      msgTitle,
      msgBody,
      DateTime.now().add(timeoutDuration),
      NotificationDetails(
        AndroidNotificationDetails(
          channelID,
          channelTitle,
          channelDescription,
          channelAction: AndroidNotificationChannelAction.CreateIfNotExists,
          vibrationPattern: vibrationPattern,
          enableVibration: true,
          playSound: true,
          largeIcon: DrawableResourceAndroidBitmap(iconResName),
          icon: iconResName,
          color: iconColor,
          showWhen: showWhenStamp,
          sound: RawResourceAndroidNotificationSound("quiet_silent"),
          importance: Importance.Max,
          priority: Priority.High,
          visibility: NotificationVisibility.Public,
        ),
        IOSNotificationDetails(
          presentSound: true,
        ),
      ),
      androidAllowWhileIdle: true,
    );
  }

  Future cancelAnyNotifications() async {
    await localNotifications?.cancelAll();
  }

  Future _onSelectNotification(String payload) async {
    print(payload);
  }

  Future _onDidReceiveLocalNotification(
    int id,
    String title,
    String body,
    String payload,
  ) async {
    print(payload);
  }
}
