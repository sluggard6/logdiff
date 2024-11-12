class LogDiffInfo {
  static const int MAX_TIME_DIFF = 500;
  final int timeDiff;
  final String stationName;
  final String positionName;
  final int location;
  final int value;
  LogDiffInfo({
    required this.timeDiff,
    required this.stationName,
    required this.positionName,
    required this.location,
    required this.value,
  });
}
