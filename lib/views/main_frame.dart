import 'package:flutter/material.dart';
import 'package:virtual_emp/views/attendance_page.dart';
import 'package:virtual_emp/views/emp_page.dart';
import 'package:virtual_emp/views/loginpage.dart';

class MainFrame extends StatefulWidget {
  const MainFrame({Key? key}) : super(key: key);

  @override
  _MainFrameState createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  int index = 0;

  final screens = [
    const EmployeePage(),
    const AttendancePage(),
    const Center(child: Text('No Notifications')),
  ];

   Future logoutDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Logout Confirmation'),
              content: Text('Are you sure you want to logout?'),
              actions: [
                TextButton(onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LoginPage()));
                }, child: Text('LOGOUT')),
                TextButton(onPressed: () {}, child: Text('CANCEL')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Byaheros Express'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            onPressed: () {
              logoutDialog(context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.grey.shade400,
        ),
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
            // NavigationDestination(
            //   icon: Icon(Icons.notifications_none),
            //   label: 'Notifications',
            // ),
          ],
        ),
      ),
    );
  }

 
}
