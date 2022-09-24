import 'dart:io';
import 'dart:math';

import 'package:blogapp/Model/addBlogModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddBlogViewModel extends BaseViewModel {
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Future<void> addData(blogData) async {
    FirebaseFirestore.instance.collection("blogs").add(blogData).catchError((e) {
      print(e);
    });
  }

  getData() async {
    return await FirebaseFirestore.instance.collection("blogs").snapshots();
  }

  Future<void> uploadBlog(XFile selectedImage, String authName, String email, String title, String desc, String type) async {
    setBusy(true);
    final firebaseStorageRef = FirebaseStorage.instance.ref().child("blogImages").child("${randomAlphaNumeric(9)}.jpg");

    final task = await firebaseStorageRef.putFile(File(selectedImage.path));

    var downloadUrl = await firebaseStorageRef.getDownloadURL();
    print("this is url $downloadUrl");
    final blog = AddBlogModel(
      body: desc,
      title: title,
      coverImage: downloadUrl,
      count: 0,
      share: 2,
      comment: 0,
      id: randomNumeric(2),
      username: authName,
      email: email,
      type: type,
    );

    await addData(blog.toJson()).then((result) {});
    // showNotification(authName);
    setBusy(false);
  }

  // showNotification(String username) async {
  //   var android = new AndroidNotificationDetails('channel id', 'channel NAME', importance: Importance.max);

  //   var platform = new NotificationDetails(android: android);
  //   await flutterLocalNotificationsPlugin.show(0, 'New Blog is out', 'Flutter Local Notification', platform, payload: username);
  // }
}
