import 'dart:convert';

import 'package:floor/floor.dart';

@entity
class Position {
  @primaryKey
  final int? id;
  @ColumnInfo(name: 'station_id')
  final int stationId;
  final int type;
  @ColumnInfo(name: 'serial_number')
  final int serialNumber;
  final String name;
  final int location;
  final int? value;
  @ColumnInfo(name: 'value_desc')
  final String valueDesc;
  final int state;
  @ColumnInfo(name: 'alarm_level')
  final int alarmLevel;
  final String? description;

  Position({
    this.id,
    required this.stationId,
    required this.type,
    required this.serialNumber,
    required this.name,
    required this.location,
    this.value,
    required this.valueDesc,
    required this.state,
    required this.alarmLevel,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'station_id': stationId,
      'type': type,
      'serial_number': serialNumber,
      'name': name,
      'location': location,
      'value': value,
      'value_desc': valueDesc,
      'state': state,
      'alarm_level': alarmLevel,
      'description': description,
    };
  }

  String getValueDescString(int value) {
    return jsonDecode(valueDesc)[value.toString()] ?? "未知";
  }
}

enum PositionType {
  /// 遥信
  yx(value: 0, name: "遥信"),

  /// 遥测
  yc(value: 1, name: "遥测"),

  /// 遥控
  yk(value: 2, name: "遥控"),

  /// 遥调
  yt(value: 3, name: "遥调");

  const PositionType({
    required this.value,
    required this.name,
  });
  final int value;
  final String name;
}

extension PositionTypes on PositionType {
  static PositionType fromValue(int value) {
    return PositionType.values.firstWhere((element) => element.value == value);
  }

  static List<PositionType> get values => PositionType.values;
}

extension PositionValueDesc on Position {
  String getValueDescString() {
    return jsonDecode(valueDesc)[value];
    // if (valueDesc.containsKey(value)) {
    //   return valueDesc[value]!;
    // }
    // return "unkown";
  }
}

extension PositionStateDesc on Position {
  String stateDesc() {
    return state == 0 ? "未启用" : "启用";
  }
}

// class ValueDesc {
//   final int value;
//   final String desc;
//   const ValueDesc(
//     this.value,
//     this.desc,
//   );

//   factory ValueDesc.fromJson(Map<int, String> json) {
//     return ValueDesc(json[], json['desc']);
//   }
// }
