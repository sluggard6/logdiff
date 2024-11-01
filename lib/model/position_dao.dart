import 'package:floor/floor.dart';
import 'package:logdiff/model/position.dart';

@dao
abstract class PositionDao {
  @Query('SELECT * FROM Position')
  Future<List<Position>> findAllPositions();

  @Query('SELECT * FROM Position WHERE id = :id')
  Future<Position?> findPositionById(int id);

  @Query('SELECT * FROM Position WHERE station_id = :stationId')
  Future<List<Position>> findPositionsByStationId(int stationId);

  @Query('SELECT * FROM Position WHERE type = :type')
  Future<List<Position>> findPositionsByType(int type);

  @insert
  Future<void> insertPosition(Position position);

  @delete
  Future<void> deletePosition(Position position);

  @update
  Future<void> updatePosition(Position position);
}
