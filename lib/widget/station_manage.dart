import 'package:flutter/material.dart';
import 'package:logdiff/components/global.dart';
import 'package:logdiff/components/import_station_dialog.dart';
import 'package:logdiff/components/main_menu.dart';
import 'package:logdiff/model/position.dart';
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
  late List<Position> positions = [];
  // late List<>
  // GlobalKey stationKey = GlobalKey();

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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    const Text("选择站："),
                    FutureBuilder(
                        future: _loadStation(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return DropdownButton<int>(
                              // key: stationKey,
                              value: stationId,
                              onChanged: (int? id) {
                                // stationKey.currentState?.setState(() {
                                //   stationId = stations
                                //       .firstWhere((element) => element.id == id)
                                //       .id!;
                                // });
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
                            );
                          }
                          return const CircularProgressIndicator();
                        }),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: MaterialButton(
                        onPressed: () {
                          if (stationId > 0) {
                            setState(() {});
                          }
                        },
                        color: Colors.blue,
                        child: const Text("加载数据"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: MaterialButton(
                        onPressed: () async {
                          bool refalsh = await showDialog(
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
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    MaterialButton(
                                      // color: Colors.blue,
                                      child: const Text("确定"),
                                      onPressed: () {
                                        stationName =
                                            _stationNameController.text;
                                        updateStationName(stationName, context);
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                          if (refalsh) {
                            setState(() {});
                          }
                        },
                        color: Colors.blue,
                        child: const Text("修改站名"),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          MaterialButton(
                            onPressed: () async {
                              bool? reflush = await showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    const ImportStationDialog(),
                              );
                              if (reflush != null && reflush) {
                                setState(() {});
                              }
                              print(reflush);
                            },
                            color: Colors.blue,
                            child: const Text("导入新站"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Scrollable(viewportBuilder: viewportBuilder)
              // Row(children: [],),
              FutureBuilder(
                  future: _loadPostions(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Position>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: positions.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return const PositionListItem();
                            }
                            return PositionListItem(
                                position: positions[index - 1]);
                          });
                    } else {
                      return const Center(child: Text("暂无数据"));
                    }
                  }),
            ],
          ),
        ),
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

  Future<List<Position>> _loadPostions() async {
    if (stationId <= 0) {
      return [];
    } else {
      positions =
          await Global.database.positionDao.findPositionsByStationId(stationId);
    }
    return positions;
  }
}

class PositionListItem extends StatelessWidget {
  final Position? position;
  // final Function(Position) onDelete;
  // final Function(Position) onEdit;

  const PositionListItem({
    super.key,
    this.position,
    // required this.onDelete,
    // required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xffe5e5e5))),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child:
                  Text('${position == null ? "序号" : position!.serialNumber}'),
            ),
          ),
          Expanded(
            child: Text(position == null ? "标准描述" : position!.name),
          ),
          Expanded(
            child: Text('${position == null ? "转发地址" : position!.location}'),
          ),
          Expanded(
            child:
                Text(position == null ? "0" : position!.getValueDescString(0)),
          ),
          Expanded(
            child:
                Text(position == null ? "1" : position!.getValueDescString(1)),
          ),
          Expanded(
            child: Text(position == null ? "备注" : position!.stateDesc()),
          ),
          Expanded(
            child: Text('${position == null ? "告警等级" : position!.alarmLevel}'),
          ),
          Expanded(
            child: Text(position == null ? "说明" : position!.description ?? ""),
          ),
        ],
      ),
    );
  }
}
