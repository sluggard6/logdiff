import 'package:floor/floor.dart';
import 'package:logdiff/model/station.dart';

@dao
abstract class StationDao {
  @Query('SELECT * FROM Stations') // SELECT * FROM Station
  Future<List<Station>> findAllStations();
  @Query('SELECT * FROM Stations WHERE id = :id')
  Future<Station?> findStationById(int id);
  @Query('SELECT * FROM Stations WHERE name = :name')
  Future<List<Station>> findStationByName(String name);
  @Query('SELECT COUNT(*) FROM stations where name = :name')
  Future<int> countStationName(String name);
  @insert
  Future<int> insertStation(Station station);
  @delete
  Future<int> deleteStation(Station station);
  @update
  Future<int> updateStation(Station station);
}
