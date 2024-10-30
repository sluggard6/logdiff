import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:logdiff/components/db.dart';
import 'package:logdiff/model/position.dart';
import 'package:logdiff/model/station.dart';

class ExcelTool {
  static importStations(String stationName, String filePath) async {
    int stationId =
        await Db.insertModel('stations', Station(name: stationName));
    File file = File(filePath);

    var excel = Excel.decodeBytes(await file.readAsBytes());
    // Excel.decodeBuffer(FileinputStream(File(filePath).openSync()));
    excel.sheets['遥信']!.rows.asMap().entries.forEach((e) {
      // if (e.key < 2) {
      //   print('---------------------------------------');
      //   print(e.key);
      //   print(e.value);
      //   print('---------------------------------------');
      // }
      // json.decoder.cast()
      // json.encode(value)
      if (e.key > 1) {
        for (var cell in e.value) {
          if (cell != null && e.key < 5) {
            print('${e.key} : ${cell.cellIndex.columnIndex} : ${cell.value}');
          }
        }
        if (e.value[0] != null) {
          Db.insertModel(
            "positions",
            Position(
              stationId: stationId,
              type: PositionType.yx.value,
              serialNumber: (e.value[0]!.value as IntCellValue).value,
              name: e.value[2]!.value.toString(),
              location: (e.value[3]!.value as IntCellValue).value,
              valueDesc: Map.of({
                0: e.value[4]!.value.toString(),
                1: e.value[5]!.value.toString(),
              }).toString(),
              state: readState(e.value[6]!.value.toString()),
              alarmLevel: e.value[7]!.value == null
                  ? 0
                  : (e.value[7]!.value as IntCellValue).value,
              description: e.value[8]!.value.toString(),
            ),
          );
        }
      }
    });
  }

  static readState(String value) {
    return value == '启用' ? 0 : 1;
  }
}
