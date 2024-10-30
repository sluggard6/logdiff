import 'package:flutter/widgets.dart';
import 'package:logdiff/model/database.dart';

class Global {
  static Global? _instance;
  Global._internal();
  late final LogdiffDatabase database;

  // 工厂构造函数
  factory Global() {
    _instance ??= Global._internal();
    return _instance!;
  }
  static Global get instance => _instance ??= Global._internal();
  // Global({required this.database});

  void init() async {
    WidgetsFlutterBinding.ensureInitialized();
    database =
        await $FloorFlutterDatabase.databaseBuilder('logdiff.db').build();
  }
}
