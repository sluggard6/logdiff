import 'package:flutter/material.dart';
import 'package:logdiff/components/db.dart';
import 'package:logdiff/components/global.dart';
import 'package:logdiff/components/import_station_dialog.dart';
import 'package:logdiff/components/main_menu.dart';
import 'package:logdiff/model/station.dart';
import 'package:toastification/toastification.dart';

class StationManage extends StatefulWidget {
  const StationManage({super.key});

  @override
  State<StatefulWidget> createState() => _StationManageState();
}

class _StationManageState extends State<StationManage> {
  late List<Station> stations = [];
  late int stationId = 0;
  late String stationName = "";
  final TextEditingController _stationNameController = TextEditingController();
  // late List<>

  @override
  Widget build(BuildContext context) {
    return MainMenu(
      child: Scaffold(
        // appBar: const MainMenu(),
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("管理站数据"),
        ),
        body: SingleChildScrollView(
            child: FutureBuilder<void>(
          future: _loadStation(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                    child: Row(children: [
                      const Text("选择站："),
                      DropdownButton<int>(
                        value: stationId,
                        onChanged: (int? id) {
                          setState(() {
                            stationId = stations
                                .firstWhere((element) => element.id == id)
                                .id!;
                          });
                        },
                        items: stations.map<DropdownMenuItem<int>>(
                          (Station station) {
                            return DropdownMenuItem<int>(
                              value: station.id,
                              child: Text(station.name),
                            );
                          },
                        ).toList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: MaterialButton(
                          onPressed: () {},
                          color: Colors.blue,
                          child: const Text("加载数据"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: MaterialButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text("修改站名"),
                                content: const Text("请输入站点名称"),
                                actions: [
                                  TextField(
                                    controller: _stationNameController,
                                  ),
                                  Row(
                                    children: [
                                      MaterialButton(
                                        child: const Text("取消"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      MaterialButton(
                                        // color: Colors.blue,
                                        child: const Text("确定"),
                                        onPressed: () {
                                          stationName =
                                              _stationNameController.text;
                                          updateStationName(
                                              stationName, context);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          color: Colors.blue,
                          child: const Text("修改站名"),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            MaterialButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        const ImportStationDialog());
                              },
                              color: Colors.blue,
                              child: const Text("导入新站"),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  // Expanded(
                  //   child: ListView.builder(
                  //       itemBuilder: (BuildContext context, int index) {
                  //     return const CircularProgressIndicator();
                  //   }),
                  // ),
                ],
              );
            }
            return const CircularProgressIndicator();
          },
        )),
      ),
    );
  }

  Future<void> _loadStation() async {
    List<Station> stations = await Global.database.stationDao.findAllStations();
    // List<Station> stations = await Db.queryStations();
    this.stations = stations;
    if (stationId == 0) {
      stationId = stations.first.id!;
    }
  }

  Future<void> updateStationName(
      String stationName, BuildContext context) async {
    String message = "操作成功";
    try {
      if (stationName.trim().isEmpty) {
        message = "名称不能为空";
      } else if ((await Global.database.stationDao
              .countStationName(stationName))! >
          0) {
        // } else if (await Db.countField("stations", "name", stationName) > 0) {
        message = "名称重复";
      } else {
        await Global.database.stationDao
            .updateStation(Station(id: stationId, name: stationName));
        // await Db.updateModel(
        //     "stations", Station(id: stationId, name: stationName));
      }
    } catch (e, s) {
      print('exception details:\n $e');
      print('stack trace:\n $s');
      message = "操作失败";
    }
    setState(() {});
    toastification.show(
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  // Future<> _getTabRows(int stationId) async {
  //   // FutureBuilder
  //   ListView.builder(
  //     itemBuilder: (BuildContext context, int index) {},
  //     itemCount: 10,
  //   );

  //   List<TableRow> rows = [];
  //   rows.add(const TableRow(children: [
  //     TableCell(
  //       child: Text("序号"),
  //     ),
  //     TableCell(
  //       child: Text("名称"),
  //     ),
  //     TableCell(
  //       child: Text("类型"),
  //     ),
  //     TableCell(
  //       child: Text("地址"),
  //     )
  //   ]));
  //   return rows;
  // }
}
