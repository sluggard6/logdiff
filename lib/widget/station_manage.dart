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
              Row(
                children: [
                  const Text("选择站："),
                  FutureBuilder(
                      future: _loadStation(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return DropdownButton<int>(
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
                          );
                        }
                        return const CircularProgressIndicator();
                      }),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: MaterialButton(
                      onPressed: _loadPostions,
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
                                      stationName = _stationNameController.text;
                                      updateStationName(stationName, context);
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
              // Scrollable(viewportBuilder: viewportBuilder)
              // Row(children: [],),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: positions.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return const Row(
                        children: [
                          Expanded(
                            child: Text('序号'),
                          ),
                          Expanded(
                            child: Text('标准描述'),
                          ),
                          Expanded(
                            child: Text('转发地址'),
                          ),
                          Expanded(
                            child: Text('0'),
                          ),
                          Expanded(
                            child: Text('1'),
                          ),
                          Expanded(
                            child: Text('备注'),
                          ),
                          Expanded(
                            child: Text('报警等级'),
                          ),
                          Expanded(
                            child: Text('备注'),
                          ),
                        ],
                      );
                    }
                    return PositionListItem(position: positions[index - 1]);
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

  void _loadPostions() async {
    positions =
        await Global.database.positionDao.findPositionsByStationId(stationId);
    setState(() {});
  }
}

class PositionListItem extends StatelessWidget {
  final Position position;
  // final Function(Position) onDelete;
  // final Function(Position) onEdit;

  const PositionListItem({
    super.key,
    required this.position,
    // required this.onDelete,
    // required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text('${position.serialNumber}'),
        ),
        Expanded(
          child: Text(position.name),
        ),
        Expanded(
          child: Text('${position.location}'),
        ),
        Expanded(
          child: Text(position.getValueDescString(0)),
        ),
        Expanded(
          child: Text(position.getValueDescString(1)),
        ),
        Expanded(
          child: Text(position.stateDesc()),
        ),
        Expanded(
          child: Text('${position.alarmLevel}'),
        ),
        Expanded(
          child: Text(position.description ?? ""),
        ),
      ],
    );
  }
}
