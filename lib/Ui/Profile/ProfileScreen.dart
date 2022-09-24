
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final storage = FlutterSecureStorage();
  String username = "";
  String profileImage = "";
  String emailId = "";

  @override
  void initState() {
    super.initState();
    // checkProfile();
    check();
  }

  void check() async {
    String? token = await storage.read(key: "token");
    String? username1 = await storage.read(key: "name");
    String? profile = await storage.read(key: "image");
    String? email = await storage.read(key: "email");
    // print(profile);
    if (token != null) {
      setState(() {
        username = username1!;
        profileImage = profile!;
        emailId = email!;
      });
    } else {
      setState(() {});
    }
  }
  // void checkProfile() async {
  //   var response = await networkHandler.get("/profile/checkProfile");
  //   if (response["status"] == true) {
  //     setState(() {
  //       page = MainProfile();
  //     });
  //   } else {
  //     setState(() {
  //       page = button();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEEEFF),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
        profileImage != ""
            ? Center(
              child: Container(
                  height: 100.0,
                  width: 100.0,
                  decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: new NetworkImage(profileImage!), fit: BoxFit.cover)),
                ),
            )
            : Center(
              child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Color(0xFF303030),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                      child: Icon(
                    Icons.person,
                    color: Colors.white,
                  )),
                ),
            ),
        SizedBox(
          height: 10,
        ),
        Center(child: Text(username,style: TextStyle(color: Colors.black,fontSize: 20),)),SizedBox(
          height: 10,
        ),
        Center(child: Text(emailId,style: TextStyle(color: Colors.black,fontSize: 20),)),
      ]),
    );
  }
}
