import 'package:flutter/material.dart';

class MainFrame extends StatefulWidget {
  const MainFrame({Key? key}) : super(key: key);

  @override
  _MainFrameState createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  int index = 0;

  final screens = [
    Center(child: Text('Employee ID')),
    Center(child: Text('Attendance')),
    Center(child: Text('Notifications')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Byaheros Express'),
        backgroundColor: Colors.red,
      ),
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(indicatorColor: Colors.grey.shade400),
        child: NavigationBar(
          height: 60,
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() {
            this.index = index;
          }),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.badge_outlined),
              label: 'Employee ID',
            ),
            NavigationDestination(
              icon: Icon(Icons.check_box_outlined),
              label: 'Attendance',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_none),
              label: 'Notifications',
            ),
          ],
        ),
      ),
    );
  }
}
