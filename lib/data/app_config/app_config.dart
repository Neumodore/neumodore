import 'dart:convert';

class AppConfig {
  AppConfig() {}

  Duration pomodoreDuration = Duration(minutes: 25);
  Duration shortBreakDuration = Duration(minutes: 5);
  Duration longBreakDuration = Duration(minutes: 15);

  AppConfig.fromJson(String string) {
    final parsed = jsonDecode(string);
    this.longBreakDuration = Duration(milliseconds: parsed['long_break']);
    this.shortBreakDuration = Duration(milliseconds: parsed['short_break']);
    this.pomodoreDuration = Duration(milliseconds: parsed['pomodore_duration']);
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
