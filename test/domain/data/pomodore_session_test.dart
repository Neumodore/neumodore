import 'package:flutter_test/flutter_test.dart';
import 'package:neumodore/domain/data/activity/activity.dart';
import 'package:neumodore/domain/data/session/session.dart';
import 'package:neumodore/domain/data/session/session_settings.dart';

main() {
  test('Test pomodore session lifecycle', () async {
    var pomodoreSession = PomodoreSession(
      SessionSettings(
        PomodoreActivity(duration: Duration(seconds: 5)),
        LongBreakActivity(),
        ShortBreakActivity(),
        2,
      ),
    );

    pomodoreSession.startSession();
    // reach 2 seconds
    await Future.delayed(Duration(seconds: 2));
    expect(pomodoreSession.activityState, ActivityState.RUNING);
    expect(pomodoreSession.elapsedTime.inSeconds, 2);
    // reach 3 seconds
    await Future.delayed(Duration(seconds: 1));
    expect(pomodoreSession.elapsedTime.inSeconds, 3);
    // pause in 3 seconds stay on 3 paused
    pomodoreSession.pauseSession();
    await Future.delayed(Duration(seconds: 2));
    expect(pomodoreSession.elapsedTime.inSeconds, 3);
    expect(pomodoreSession.activityState, ActivityState.PAUSED);
    pomodoreSession.resumeSession();
    // go to 4 seconds
    await Future.delayed(Duration(seconds: 1));
    expect(pomodoreSession.activityState, ActivityState.RUNING);
    expect(pomodoreSession.elapsedTime.inSeconds, 4);
    // go to 5 seconds and complete
    await Future.delayed(Duration(seconds: 1));
    expect(pomodoreSession.elapsedTime.inSeconds, 5);
    expect(pomodoreSession.activityState, ActivityState.COMPLETED);

    pomodoreSession.resetSession();
    // simply reset whole app
    await Future.delayed(Duration(seconds: 1));
    expect(pomodoreSession.elapsedTime.inSeconds, 0);
    expect(pomodoreSession.remainingTime.inSeconds, 5);
    expect(pomodoreSession.activityState, ActivityState.STOPPED);

    pomodoreSession.startSession();
    // reach 2 seconds
    await Future.delayed(Duration(seconds: 1));
    pomodoreSession.pauseSession();
    expect(pomodoreSession.activityState, ActivityState.PAUSED);
    expect(pomodoreSession.elapsedTime.inSeconds, 1);
    await Future.delayed(Duration(seconds: 1));
    expect(pomodoreSession.remainingTime.inSeconds, 3);
  });
}
