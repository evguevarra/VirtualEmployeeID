import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'views/loginpage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'key1',
        channelName: 'Reminders',
        channelDescription: 'You are running late for your work shift!',
        defaultColor: Colors.red,
        ledColor: Colors.white,
        playSound: true,
        enableLights: true,
        enableVibration: true,
        importance: NotificationImportance.High,
      )
    ]
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState(){
    super.initState();
    notify();
    AwesomeNotifications().createdStream.listen((notification) { 
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
      //   'Notification Created'
      // ),));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }

  void notify() async{
    String timezone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey:'key1',
        title: 'Reminders',
        body: 'You are running late for your work shift!',
        notificationLayout: NotificationLayout.BigPicture,
       ),
       schedule: NotificationCalendar(hour: 8, minute: 0,repeats: true)
       
       );
  }
}
