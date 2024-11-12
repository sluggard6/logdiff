class ZhuZhan {
  final int index;
  final int time;
  final String stationName;
  final String type;
  final String name;
  final String value;

  ZhuZhan({
    required this.index,
    required this.time,
    required this.stationName,
    required this.type,
    required this.name,
    required this.value,
  });

  @override
  String toString() {
    return 'ZhuZhan{index: $index, time: $time, stationName: $stationName, type: $type, name: $name, value: $value}';
  }
}

class TongGuan {
  final int index;
  final int time;
  final String stationName;
  final String type;
  final String name;
  final String alarmLevel;
  final String value;

  TongGuan({
    required this.index,
    required this.time,
    required this.stationName,
    required this.type,
    required this.name,
    required this.alarmLevel,
    required this.value,
  });

  @override
  String toString() {
    return 'TongGuan{index: $index, time: $time, stationName: $stationName, type: $type, name: $name, alarmLevel: $alarmLevel, value: $value}';
  }
}
