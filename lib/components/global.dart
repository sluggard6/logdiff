import 'package:flutter/widgets.dart';
import 'package:logdiff/model/database.dart';

class Global {
  static Global? _instance;
  Global._internal(this.database);
  final LogdiffDatabase database;

  // 工厂构造函数
  factory Global() {
    if (_instance == null) {
      WidgetsFlutterBinding.ensureInitialized();
    }
    _instance ??= Global._internal(database);
    return _instance!;
  }
  static Global get instance => _intance ??= Global._internal(database);
  // Global({required this.database});

  init() async {}
}
