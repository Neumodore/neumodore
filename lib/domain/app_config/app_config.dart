import 'dart:convert';

class AppConfig {
  AppConfig();

  Duration pomodoreDuration = Duration(minutes: 25);
  Duration shortBreakDuration = Duration(minutes: 5);
  Duration longBreakDuration = Duration(minutes: 15);

  AppConfig fromJson(String string) {
    var appConfig = new AppConfig();

    final parsed = jsonDecode(string);

    appConfig.longBreakDuration = Duration(
      milliseconds: parsed['long_break'],
    );

    appConfig.shortBreakDuration = Duration(
      milliseconds: parsed['short_break'],
    );

    appConfig.pomodoreDuration = Duration(
      milliseconds: parsed['pomodore_duration'],
    );
    return appConfig;
  }

  String toJson() {
    final stringfy = jsonEncode(
      {
        'long_break': longBreakDuration.inMilliseconds,
        'short_break': shortBreakDuration.inMilliseconds,
        'pomodore_duration': pomodoreDuration.inMilliseconds,
      },
    );
    return stringfy;
  }
}
