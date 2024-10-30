import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logdiff/components/db.dart';
import 'package:logdiff/components/excel_tool.dart';
import 'package:logdiff/components/global.dart';
import 'package:toastification/toastification.dart';

class ImportStationDialog extends StatefulWidget {
  const ImportStationDialog({super.key});

  @override
  State<StatefulWidget> createState() => _ImportStationDialogState();
}

class _ImportStationDialogState extends State<ImportStationDialog> {
  final TextEditingController _stationNameController = TextEditingController();
  late String file;
  late String stationName;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("导入新站"),
        content: const Text("请输入站点名称"),
        actions: [
          TextField(
            controller: _stationNameController,
          ),
          MaterialButton(
            color: Colors.blue,
            onPressed: selectExcel,
            child: const Text("选择文件"),
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
                  checkParams(context);
                  // updateStationName(stationName, context);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ]);
  }

  void selectExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      print(file.path);
      // setState(() {
      this.file = file.path;
      // });
    } else {
      // User canceled the picker
    }
  }

  Future<void> checkParams(BuildContext context) async {
    String message = "操作成功";
    try {
      if (stationName.trim().isEmpty) {
        message = "名称不能为空";
      } else if (await Global.instance.database.stationDao
              .countStationName(stationName) >
          0) {
        // } else if (await Db.countField("stations", "name", stationName) > 0) {
        message = "名称重复";
      } else if (file.isEmpty) {
        message = "请选择文件";
      } else {
        ExcelTool.importStations(stationName, file);
      }
    } catch (e, s) {
      print('exception details:\n $e');
      print('stack trace:\n $s');
      message = "操作失败";
    }
    toastification.show(
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 3),
    );
  }
}
