import 'package:blogapp/Ui/blog/addBlog.dart';
import 'package:blogapp/Ui/home_screen/HomePage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Ui/auth_screen/LoadingPage.dart';
import 'Ui/auth_screen/WelcomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = LoadingPage();
  final storage = FlutterSecureStorage();
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings = new InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin!.initialize(initializationSettings);
    checkLogin();
  }

  Future<void> onSelectNotification(String payload) async {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }

  showNotification() async {
    var android = new AndroidNotificationDetails('channel id', 'channel NAME', priority: Priority.high, importance: Importance.max);

    var platform = new NotificationDetails(
      android: android,
    );
    await flutterLocalNotificationsPlugin!.show(0, 'New Blog is out', 'Flutter Local Notification', platform, payload: '');
  }

  void checkLogin() async {
    String? token = await storage.read(key: "token");
    String? username1 = await storage.read(key: "name");
    String? profile = await storage.read(key: "image");
    String? email = await storage.read(key: "email");
    // print(profile);
    if (token != null) {
      showNotification();
      setState(() {
        page = HomePage(
          username: username1 != null ? username1 : "",
          emailId: email != null ? email : "",
          profileImage: profile != null ? profile : "",
        );
      });
    } else {
      setState(() {
        page = WelcomePage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: page,
    );
  }
}
