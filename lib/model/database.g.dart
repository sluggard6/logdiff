// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $FlutterDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $FlutterDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $FlutterDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<FlutterDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorFlutterDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $FlutterDatabaseBuilderContract databaseBuilder(String name) =>
      _$FlutterDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $FlutterDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$FlutterDatabaseBuilder(null);
}

class _$FlutterDatabaseBuilder implements $FlutterDatabaseBuilderContract {
  _$FlutterDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $FlutterDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $FlutterDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<FlutterDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$FlutterDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$FlutterDatabase extends FlutterDatabase {
  _$FlutterDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PositionDao? _positionDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Position` (`id` INTEGER, `station_id` INTEGER NOT NULL, `type` INTEGER NOT NULL, `serial_number` INTEGER NOT NULL, `name` TEXT NOT NULL, `location` INTEGER NOT NULL, `value` INTEGER, `value_desc` TEXT NOT NULL, `state` INTEGER NOT NULL, `alarm_level` INTEGER NOT NULL, `description` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PositionDao get positionDao {
    return _positionDaoInstance ??= _$PositionDao(database, changeListener);
  }
}

class _$PositionDao extends PositionDao {
  _$PositionDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _positionInsertionAdapter = InsertionAdapter(
            database,
            'Position',
            (Position item) => <String, Object?>{
                  'id': item.id,
                  'station_id': item.stationId,
                  'type': item.type,
                  'serial_number': item.serialNumber,
                  'name': item.name,
                  'location': item.location,
                  'value': item.value,
                  'value_desc': item.valueDesc,
                  'state': item.state,
                  'alarm_level': item.alarmLevel,
                  'description': item.description
                }),
        _positionUpdateAdapter = UpdateAdapter(
            database,
            'Position',
            ['id'],
            (Position item) => <String, Object?>{
                  'id': item.id,
                  'station_id': item.stationId,
                  'type': item.type,
                  'serial_number': item.serialNumber,
                  'name': item.name,
                  'location': item.location,
                  'value': item.value,
                  'value_desc': item.valueDesc,
                  'state': item.state,
                  'alarm_level': item.alarmLevel,
                  'description': item.description
                }),
        _positionDeletionAdapter = DeletionAdapter(
            database,
            'Position',
            ['id'],
            (Position item) => <String, Object?>{
                  'id': item.id,
                  'station_id': item.stationId,
                  'type': item.type,
                  'serial_number': item.serialNumber,
                  'name': item.name,
                  'location': item.location,
                  'value': item.value,
                  'value_desc': item.valueDesc,
                  'state': item.state,
                  'alarm_level': item.alarmLevel,
                  'description': item.description
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Position> _positionInsertionAdapter;

  final UpdateAdapter<Position> _positionUpdateAdapter;

  final DeletionAdapter<Position> _positionDeletionAdapter;

  @override
  Future<List<Position>> findAllPositions() async {
    return _queryAdapter.queryList('SELECT * FROM Position',
        mapper: (Map<String, Object?> row) => Position(
            id: row['id'] as int?,
            stationId: row['station_id'] as int,
            type: row['type'] as int,
            serialNumber: row['serial_number'] as int,
            name: row['name'] as String,
            location: row['location'] as int,
            value: row['value'] as int?,
            valueDesc: row['value_desc'] as String,
            state: row['state'] as int,
            alarmLevel: row['alarm_level'] as int,
            description: row['description'] as String));
  }

  @override
  Future<Position?> findPositionById(int id) async {
    return _queryAdapter.query('SELECT * FROM Position WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Position(
            id: row['id'] as int?,
            stationId: row['station_id'] as int,
            type: row['type'] as int,
            serialNumber: row['serial_number'] as int,
            name: row['name'] as String,
            location: row['location'] as int,
            value: row['value'] as int?,
            valueDesc: row['value_desc'] as String,
            state: row['state'] as int,
            alarmLevel: row['alarm_level'] as int,
            description: row['description'] as String),
        arguments: [id]);
  }

  @override
  Future<List<Position>> findPositionsByStationId(int stationId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Position WHERE stationId = ?1',
        mapper: (Map<String, Object?> row) => Position(
            id: row['id'] as int?,
            stationId: row['station_id'] as int,
            type: row['type'] as int,
            serialNumber: row['serial_number'] as int,
            name: row['name'] as String,
            location: row['location'] as int,
            value: row['value'] as int?,
            valueDesc: row['value_desc'] as String,
            state: row['state'] as int,
            alarmLevel: row['alarm_level'] as int,
            description: row['description'] as String),
        arguments: [stationId]);
  }

  @override
  Future<List<Position>> findPositionsByType(int type) async {
    return _queryAdapter.queryList('SELECT * FROM Position WHERE type = ?1',
        mapper: (Map<String, Object?> row) => Position(
            id: row['id'] as int?,
            stationId: row['station_id'] as int,
            type: row['type'] as int,
            serialNumber: row['serial_number'] as int,
            name: row['name'] as String,
            location: row['location'] as int,
            value: row['value'] as int?,
            valueDesc: row['value_desc'] as String,
            state: row['state'] as int,
            alarmLevel: row['alarm_level'] as int,
            description: row['description'] as String),
        arguments: [type]);
  }

  @override
  Future<void> insertPosition(Position position) async {
    await _positionInsertionAdapter.insert(position, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePosition(Position position) async {
    await _positionUpdateAdapter.update(position, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePosition(Position position) async {
    await _positionDeletionAdapter.delete(position);
  }
}
