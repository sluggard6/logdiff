import 'package:flutter/material.dart';
import 'package:logdiff/widget/station_manage.dart';
import 'package:menu_bar/menu_bar.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<StatefulWidget> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return MenuBarWidget(
      // The buttons in this List are displayed as the buttons on the bar itself
      barButtons: [
        BarButton(
          text: const Text('File', style: TextStyle(color: Colors.black)),
          submenu: SubMenu(
            menuItems: [
              MenuButton(
                text: const Text('Save'),
                onTap: () {},
                icon: const Icon(Icons.save),
                shortcutText: 'Ctrl+S',
              ),
              const MenuDivider(),
              MenuButton(
                text: const Text('Exit'),
                onTap: () {},
                icon: const Icon(Icons.exit_to_app),
                shortcutText: 'Ctrl+Q',
              ),
            ],
          ),
        ),
        BarButton(
          text: const Text("管理"),
          submenu: SubMenu(
            menuItems: [
              MenuButton(
                text: const Text("管理站点"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StationManage()),
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        BarButton(
          text: const Text('帮助', style: TextStyle(color: Colors.black)),
          submenu: SubMenu(
            menuItems: [
              MenuButton(
                text: const Text('View License'),
                onTap: () {},
              ),
              MenuButton(
                text: const Text('About'),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => const AlertDialog(
                            title: Text("关于"),
                            content: Text("信息对比工具v1.0"),
                          ));
                },
                icon: const Icon(Icons.info),
              ),
            ],
          ),
        ),
      ],
      child: widget.child,
    );
  }

  void toStationManage() {}
}
