class LogDiffInfo {
  static const int MAX_TIME_DIFF = 500;
  final int timeDiff;
  final String stationName;
  final String positionName;
  final int location;
  final String zzValue;
  final String tgValue;
  // final bool com
  LogDiffInfo({
    required this.timeDiff,
    required this.stationName,
    required this.positionName,
    required this.location,
    required this.zzValue,
    required this.tgValue,
  });

  get valueState => zzValue != tgValue;
  get timeState => timeDiff > MAX_TIME_DIFF;
  get ok => timeState && valueState;
}
