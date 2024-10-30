import 'package:logdiff/model/position.dart';

import 'package:floor/floor.dart';

@entity
class Station {
  @primaryKey
  late int? id;
  final String name;
  @ignore
  late List<Position> positions;

  Station({
    this.id,
    required this.name,
    // required this.points,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      // 'points': points,
    };
  }

  static Station fromMap(Map<String, Object?> map) {
    return Station(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
