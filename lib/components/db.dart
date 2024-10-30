// import 'package:logdiff/model/position.dart';
// import 'package:logdiff/model/station.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:flutter/widgets.dart';
// import 'package:path/path.dart';
// // import 'package:floor/floor.dart';

// class Db {
//   static late final Database db;

//   static Future<Database> open() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     db = await openDatabase(
//       join(await getDatabasesPath(), 'logdiff.db'),
//       onCreate: (db, version) {
//         print("run on create db");
//         db.execute('CREATE TABLE STATIONS(id INTEGER PRIMARY KEY, name TEXT)');
//         db.execute('insert into stations(id, name) values(1, "测试站")');
//         db.execute('''
//           CREATE TABLE POSITIONS(id INTEGER PRIMARY KEY, 
//             station_id INTEGER, 
//             type INTEGER, 
//             serial_number INTEGER, 
//             name TEXT, 
//             location INTEGER, 
//             value INTEGER, 
//             value_desc TEXT, 
//             state INTEGER, 
//             alarm_level INTEGER, 
//             description TEXT)
//           ''');
//       },
//       version: 1,
//     );
//     return db;
//   }

//   static Future<int> insertModel(String table, dynamic model) async {
//     // final db = await open();
//     int ret = await db.insert(
//       table,
//       model.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     // db.close();
//     return ret;
//   }

//   static Future<List<Map<String, dynamic>>> queryModel(String table) async {
//     // final db = await open();
//     final List<Map<String, dynamic>> maps = await db.query(table);
//     db.close();
//     return List.generate(maps.length, (i) {
//       return maps[i];
//     });
//   }

//   static Future<List<Station>> queryStations() async {
//     return (await queryModel('stations'))
//         .map<Station>((e) => Station.fromMap(e))
//         .toList();
//   }

//   static Future<int> countField(
//       String table, String field, dynamic value) async {
//     // final db = await open();
//     var ret = await db
//         .rawQuery("SELECT COUNT (*) from $table where $field = '$value'");
//     // db.close();
//     return Sqflite.firstIntValue(ret) ?? 0;
//   }

//   static Future<int> updateModel(String table, dynamic model) async {
//     // final db = await open();
//     int ret = await db
//         .update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);
//     // db.close();
//     return ret;
//   }
// }


