abstract class Log {
  final int time;
  final String stationName;
  final String type;
  final String name;
  final int location;

  Log({
    required this.time,
    required this.stationName,
    required this.type,
    required this.name,
    required this.location,
  });
}

class ZhuZhan extends Log {
  final int index;
  // final int time;
  // final String stationName;
  // final String type;
  // final String name;
  final String value;

  ZhuZhan({
    required this.index,
    required super.time,
    required super.stationName,
    required super.type,
    required super.name,
    required this.value,
    required super.location,
  });

  @override
  String toString() {
    return 'ZhuZhan{index: $index, time: $time, stationName: $stationName, type: $type, name: $name, value: $value, location: $location}';
  }
}

class TongGuan extends Log {
  final int index;
  // final int time;
  // final String stationName;
  // final String type;
  // final String name;
  final String alarmLevel;
  final String value;

  TongGuan({
    required this.index,
    required super.time,
    required super.stationName,
    required super.type,
    required super.name,
    required this.alarmLevel,
    required this.value,
    required super.location,
  });

  @override
  String toString() {
    return 'TongGuan{index: $index, time: $time, stationName: $stationName, type: $type, name: $name, alarmLevel: $alarmLevel, value: $value, location: $location}';
  }
}
