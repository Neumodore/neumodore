import 'dart:math';

extension RandomListItem<T> on List<T> {
  T getRandom() {
    int randomLocation = Random.secure().nextInt(this.length);
    return this.elementAt(randomLocation);
  }
}
