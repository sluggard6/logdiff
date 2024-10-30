import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:logdiff/model/position.dart';

class PositionTypeConverter extends TypeConverter<PositionType, int> {
  @override
  PositionType decode(int databaseValue) {
    return PositionType.values
        .firstWhere((element) => element.value == databaseValue);
  }

  @override
  int encode(PositionType value) {
    return value.value;
  }
}

class PositionValueDescConverter
    extends TypeConverter<Map<int, String>, String> {
  @override
  Map<int, String> decode(String databaseValue) {
    return json.decode(databaseValue);
  }

  @override
  String encode(Map<int, String> value) {
    return json.encode(value);
  }
}
