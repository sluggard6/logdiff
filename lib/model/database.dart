import 'dart:async';

import 'package:floor/floor.dart';
import 'package:logdiff/model/position.dart';
import 'package:logdiff/model/position_dao.dart';
import 'package:logdiff/model/station.dart';
import 'package:logdiff/model/station_dao.dart';
import 'package:logdiff/model/type_converter.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [Station, Position])
@TypeConverters([PositionTypeConverter])
abstract class LogdiffDatabase extends FloorDatabase {
  StationDao get stationDao;
  PositionDao get positionDao;
}
