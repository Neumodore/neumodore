import 'package:neumodore/clean/data/neumodore_state.dart';

abstract class PomodorePresenterContract {
  void onLoadPresenter(PomodoreState pomodore);
  void onLoadStateError();
}

class PomodorePresenter {
  PomodorePresenterContract _view;
  PomodorePresenter(this._view);

  void loadPomodoreState() async {
    _view.onLoadPresenter(
      PomodoreState.shortBreak(),
    );
  }
}
