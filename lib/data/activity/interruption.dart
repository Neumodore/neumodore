class Interruption {
  DateTime startDate;
  DateTime endDate;

  Duration get inDuration {
    return endDate?.difference(startDate ?? DateTime.now()) ?? Duration.zero;
  }
}
