import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logdiff/components/global.dart';
import 'package:logdiff/model/file_template.dart';
import 'package:logdiff/model/log_diff.dart';
import 'package:logdiff/model/position.dart';
import 'package:logdiff/model/station.dart';
import 'package:logdiff/util/file_tool.dart';
import 'package:toastification/toastification.dart';

List<PositionType> types = PositionTypes.values;
Station zeroStation = Station(id: 0, name: "无数据");
List<LogDiffInfo> diffInfos = [
  // LogDiffInfo(
  //     timeDiff: 50,
  //     stationName: "松江大学城",
  //     positionName: "测试点",
  //     location: 25,
  //     value: 1)
];

class TitleSection extends StatefulWidget {
  // final StationDao stationDao;
  const TitleSection({
    super.key,
    // required this.stationDao,
  });

  // final String file1;
  // final String file2;
  // final int type;
  // final int station;

  @override
  State<StatefulWidget> createState() => _TitleSectionState();
}

class _TitleSectionState extends State<TitleSection> {
  int type = 0;
  String file1 = "";
  String file2 = "";
  int? stationId;
  // Station station = zeroStation;
  Station? station;

  // @override
  // void initState() async {
  //   super.initState();
  //   station = await Db.queryStations().then((value) => value.first);
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          /*文件1 */
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
            child: Row(children: [
              Expanded(
                child: Row(
                  children: [
                    const Text("主站日志文件："),
                    MaterialButton(
                      color: Colors.blue,
                      onPressed: selectFile1,
                      child: const Text("选择文件"),
                    ),
                    Expanded(
                      child: Text(file1),
                    )
                  ],
                ),
              ),
            ]),
          ),
          /*文件2 */
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
            child: Row(children: [
              Expanded(
                child: Row(
                  children: [
                    const Text("通管日志文件："),
                    MaterialButton(
                      color: Colors.blue,
                      onPressed: selectFile2,
                      child: const Text("选择文件"),
                    ),
                    Expanded(
                      child: Text(file2),
                    )
                  ],
                ),
              )
            ]),
          ),
          /* 选择条 */
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
            child: Row(
              children: [
                const Text("对比类型："),
                DropdownButton<int>(
                  value: type,
                  onChanged: (int? value) {
                    setState(() {
                      changeType(value);
                    });
                  },
                  items: types
                      .asMap()
                      .keys
                      .map<DropdownMenuItem<int>>((int index) {
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text(PositionTypes.fromValue(index).name),
                    );
                  }).toList(),
                ),
                const Text("选择站："),
                FutureBuilder<List<Station>>(
                  future: _loadStation(context),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return DropdownButton<int>(
                        value: stationId,
                        onChanged: (int? id) {
                          setState(() {
                            station = snapshot.data
                                .firstWhere((element) => element.id == id);
                            stationId = station!.id;
                          });
                        },
                        items: snapshot.data.map<DropdownMenuItem<int>>(
                          (Station station) {
                            return DropdownMenuItem<int>(
                              value: station.id,
                              child: Text(station.name),
                            );
                          },
                        ).toList(),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
                MaterialButton(
                  color: Colors.blue,
                  onPressed: runCompare,
                  child: const Text("开始对比"),
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
          //   child: Row(
          //     children: [
          /* "对比结果" */
          getDiffs()
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }

  Widget getDiffs() {
    if (diffInfos.isEmpty) {
      return const Text("暂无数据");
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: diffInfos.length,
        itemBuilder: (context, index) {
          var diff = diffInfos[index];
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    diffInfos[index].timeDiff.toString(),
                    style: TextStyle(
                      background: Paint()
                        ..color = diffInfos[index].timeState
                            ? Colors.red
                            : Colors.white,
                    ),
                  ),
                ),
                Expanded(child: Text(diffInfos[index].stationName)),
                Expanded(child: Text(diffInfos[index].positionName)),
                Expanded(child: Text(diffInfos[index].location.toString())),
                Expanded(
                  child: Text(
                    "${diff.zzValue}:${diff.tgValue}",
                    style: TextStyle(
                        background: Paint()
                          ..color =
                              diff.valueState ? Colors.red : Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Future<void> selectFile1() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      print(file.path);
      setState(() {
        file1 = file.path;
      });
    } else {
      // User canceled the picker
    }
  }

  Future<void> selectFile2() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      print(file.path);
      setState(() {
        file2 = file.path;
      });
    } else {
      // User canceled the picker
    }
  }

  bool checkParamCompare() {
    if (file1 == "" || file2 == "") {
      return false;
    }
    return true;
  }

  void runCompare() async {
    if (kDebugMode) {
      print("runCompare");
    }
    if (!checkParamCompare()) {
      toastification.show(
        title: const Text("请先选择文件"),
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
    File zhuzhanFile = File(file1);
    File tongguanFile = File(file2);
    var fields = await zhuzhanFile
        .openRead()
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    int index = 0;
    List<ZhuZhan> zhuzhans =
        fields.where((field) => field[2] == '遥信').map((field) {
      String name = field[4];
      return ZhuZhan(
        index: index,
        time: FileTool.readDateTime(field[0]),
        stationName: field[1],
        type: PositionType.yx.name,
        name: name,
        value: name.substring(name.length - 2).trim(),
        location: field[3] as int,
        // value: field[5][3],
      );
    }).toList();
    // for (var field in fields) {
    //   print(field);
    //   if (field[2] == '遥信') {
    //     index++;
    //     String name = field[4];
    //     print(index);
    //     ZhuZhan zhuZhan = ZhuZhan(
    //       index: index,
    //       time: FileTool.readDateTime(field[0]),
    //       stationName: field[1],
    //       type: PositionType.yx.name,
    //       name: name,
    //       value: name.substring(0, name.length - 2).trim(),
    //       // value: field[5][3],
    //     );
    //     print(zhuZhan);
    //   }
    // }
    fields = await tongguanFile
        .openRead()
        .transform(utf8.decoder)
        .transform(const CsvToListConverter(eol: "\n"))
        .toList();
    print(fields.length);
    for (var field in fields) {
      print(field);
    }
    List<TongGuan> tongguan = fields.where((field) {
      print(field);
      return (field[4] as String).trim() == '状态量变位';
    }).map((field) {
      String name = field[2];
      //       return [];
      return TongGuan(
        index: index,
        time: FileTool.readDateTime(field[0]),
        stationName: field[1],
        type: PositionType.yx.name,
        name: name,
        value: name.substring(name.length - 2).trim(),
        alarmLevel: field[3],
        location: field[5] as int,
        // value: field[5][3],
      );
    }).toList();
    // for (var zz in zhuzhan) {
    //   print(zz);
    // }
    for (var zz in zhuzhans) {
      print(zz);
      for (var tg in tongguan) {
        print(tg);
        if (isSame(zz, tg)) {
          diffInfos.add(
            LogDiffInfo(
              timeDiff: tg.time - zz.time,
              stationName: zz.stationName,
              positionName: zz.name,
              location: zz.location,
              zzValue: zz.value,
              tgValue: tg.value,
            ),
          );
        }
        zhuzhans.remove(zz);
      }
    }
    // for (var tg in tongguan) {}
  }

  bool isSame(ZhuZhan zz, TongGuan tg) {
    return zz.stationName == tg.stationName && zz.location == zz.location;
  }

  void changeType(int? type) {
    this.type = type!;
  }

  Future<List<Station>> _loadStation(BuildContext context) async {
    // List<Station> dbs = await Db.queryStations();
    // List<Station> stations = [];
    // List<Station> dbs = await Global.database.stationDao.findAllStations();
    // if (dbs.isEmpty) {
    //   stations.add(zeroStation);
    // } else {
    // stations.addAll(dbs);
    // if (stationId == 0) {
    //   stationId = stations.first.id!;
    // }
    // }
    return await Global.database.stationDao.findAllStations();
  }
}
