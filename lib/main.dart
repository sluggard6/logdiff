import 'package:flutter/material.dart';
import 'package:logdiff/components/global.dart';
import 'package:logdiff/components/main_menu.dart';
import 'package:logdiff/model/database.dart';
import 'package:logdiff/widget/title_section.dart';
import 'package:toastification/toastification.dart';
// import 'package:logdiff/database/app_database.dart';

void main() async {
  await startTest();

  // if (Platform.isWindows || Platform.isLinux) {
  //   // Initialize FFI
  //   sqfliteFfiInit();
  //   // Change the default factory
  //   databaseFactory = databaseFactoryFfi;
  // }
  runApp(const MyApp());
}

Future<void> startTest() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  // final callback = Callback(
  //   onCreate: (database, version) {
  //     database
  //         .execute('CREATE TABLE STATIONS(id INTEGER PRIMARY KEY, name TEXT)');
  //     database.execute('''
  //         CREATE TABLE POSITIONS(id INTEGER PRIMARY KEY,
  //           station_id INTEGER,
  //           type INTEGER,
  //           serial_number INTEGER,
  //           name TEXT,
  //           location INTEGER,
  //           value INTEGER,
  //           value_desc TEXT,
  //           state INTEGER,
  //           alarm_level INTEGER,
  //           description TEXT)
  //         ''');
  //   },
  // );
  final database = await $FloorLogdiffDatabase
      .databaseBuilder('logdiff.db')
      // .addCallback(callback)
      .build();
  Global.database = database;
  // final PositionDao personDao = database.positionDao;
  // // final person = await database.findPersonById(1);
  // await personDao.insertPosition(Position(
  //     id: 1,
  //     stationId: 1,
  //     type: 1,
  //     serialNumber: 1,
  //     name: "name",
  //     location: 1,
  //     value: 1,
  //     valueDesc: Map.of({1: "1", 2: "2"}).toString(),
  //     state: 1,
  //     alarmLevel: 1,
  //     description: "description"));
  // Global(database);
  // return database;
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: '信息对比工具'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
          title: Text(widget.title),
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              // const Expanded(
              // child: TitleSection(file1: "", file2: "", type: 0, station: 1),
              // ),
              TitleSection(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
