import 'dart:math';

import 'package:blogapp/Ui/blog/addBlog.dart';
import 'package:blogapp/Ui/auth_screen/auth_view_model.dart';
import 'package:blogapp/Ui/blog/search_screen.dart';
import 'package:blogapp/Ui/home_screen/HomeScreen.dart';
import 'package:blogapp/Ui/Profile/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../auth_screen/WelcomePage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.emailId, required this.profileImage, required this.username}) : super(key: key);

  String username;
  String profileImage;
  String emailId;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentState = 0;

  List<String> titleString = ["Blogs", "Profile Page"];
  final storage = FlutterSecureStorage();
  final auth = AuthanticationViewModel();

  String user = "";
  String profile = "";
  String email = "";
  @override
  void initState() {
    super.initState();
    // checkProfile();
    setState(() {
      user = widget.username;
      profile = widget.profileImage;
      email = widget.emailId;
    });
  }

  List<Widget> widgets = [HomeScreen(), ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEEEFF),
      drawer: Drawer(
        backgroundColor: Color(0xFF303030),
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  widget.profileImage != ""
                      ? Container(
                          height: 100.0,
                          width: 100.0,
                          decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: new NetworkImage(widget.profileImage), fit: BoxFit.cover)),
                        )
                      : Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                              child: Icon(
                            Icons.person,
                            color: Colors.white,
                          )),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(widget.username),
                ],
              ),
            ),
            ListTile(
              title: Text("All Post"),
              trailing: Icon(Icons.launch),
              onTap: () {},
            ),
            ListTile(
              title: Text("New Story"),
              trailing: Icon(Icons.add),
              onTap: () {},
            ),
            ListTile(
              title: Text("Settings"),
              trailing: Icon(Icons.settings),
              onTap: () {},
            ),
            ListTile(
              title: Text("Feedback"),
              trailing: Icon(Icons.feedback),
              onTap: () {},
            ),
            ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.power_settings_new),
              onTap: logout,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF303030)),
        title: Text(titleString[currentState]),
        titleTextStyle: TextStyle(color: Color(0xFF303030), fontSize: 25, fontWeight: FontWeight.w700),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: Color(0xFF303030),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
              }),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF303030),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddBlog()));
        },
        child: Text(
          "+",
          style: TextStyle(fontSize: 40, color: Colors.white),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 12,
        child: Container(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home),
                  color: currentState == 0 ? Colors.white : Colors.white54,
                  onPressed: () {
                    setState(() {
                      currentState = 0;
                    });
                  },
                  iconSize: 40,
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  color: currentState == 1 ? Colors.white : Colors.white54,
                  onPressed: () {
                    setState(() {
                      currentState = 1;
                    });
                  },
                  iconSize: 40,
                )
              ],
            ),
          ),
        ),
      ),
      body: widgets[currentState],
    );
  }

  void logout() async {
    final value = await storage.read(key: "accountType");
    if (value == "google") {
      await auth.googleSignOut(context: context);
      await storage.delete(key: "token");
      await storage.delete(key: "image");
      await storage.delete(key: "name");
      await storage.delete(key: "email");
      await storage.delete(key: "accountType");
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => WelcomePage()), (route) => false);
    } else {
      await auth.signOut();
      await storage.delete(key: "token");
      await storage.delete(key: "image");
      await storage.delete(key: "name");
      await storage.delete(key: "email");
      await storage.delete(key: "accountType");
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => WelcomePage()), (route) => false);
    }
  }
}
