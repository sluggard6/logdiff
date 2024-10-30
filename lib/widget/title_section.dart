import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logdiff/components/db.dart';
import 'package:logdiff/components/global.dart';
import 'package:logdiff/model/position.dart';
import 'package:logdiff/model/station.dart';

List<PositionType> types = PositionTypes.values;
Station zeroStation = Station(id: 0, name: "未选择");

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
  Station station = zeroStation;
  // late Station station;

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
                      print(snapshot.data.length);
                      return DropdownButton<int>(
                        value: station.id,
                        onChanged: (int? id) {
                          setState(() {
                            station = snapshot.data
                                .firstWhere((element) => element.id == id);
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
        ],
      ),
    );
  }

  Future<void> selectFile1() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

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
    FilePickerResult? result = await FilePicker.platform.pickFiles();

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

  void runCompare() {
    print("runCompare");
  }

  void changeType(int? type) {
    this.type = type!;
  }

  Future<List<Station>> _loadStation(BuildContext context) async {
    // List<Station> dbs = await Db.queryStations();
    List<Station> dbs =
        await Global.instance.database.stationDao.findAllStations();
    List<Station> stations = [];
    stations.add(zeroStation);
    stations.addAll(dbs);
    return stations;
  }
}
