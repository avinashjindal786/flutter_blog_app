import 'package:blogapp/Ui/blog/BlogList.dart';
import 'package:blogapp/Ui/blog/addBlog_viewModel.dart';
import 'package:blogapp/core/CustumWidget/BlogCard.dart';
import 'package:blogapp/Model/SuperModel.dart';
import 'package:blogapp/Model/addBlogModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Blogs extends StatefulWidget {
  Blogs({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  _BlogsState createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  AddBlogViewModel _addBlogViewModel = AddBlogViewModel();
  String filter = "Movie";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    filter = "Movie";
                  });
                },
                child: Container(
                  width: 80,
                  height: 30,
                  decoration: BoxDecoration(color: filter == "Movie" ? Color(0xFF303030) : Colors.transparent, borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFF303030))),
                  child: Center(
                    child: Text(
                      "Movie",
                      style: TextStyle(color: filter == "Movie" ? Colors.white : Color(0xFF303030)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    filter = "Sport";
                  });
                },
                child: Container(
                  width: 80,
                  height: 30,
                  decoration: BoxDecoration(color: filter == "Sport" ? Color(0xFF303030) : Colors.transparent, borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFF303030))),
                  child: Center(
                    child: Text(
                      "Sport",
                      style: TextStyle(color: filter == "Sport" ? Colors.white : Color(0xFF303030)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("blogs").snapshots(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      return doc["type"] == filter
                          ? InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return BlogDetail(
                                    addBlogModel: AddBlogModel(
                                      body: doc["body"],
                                      comment: doc["comment"],
                                      count: doc["count"],
                                      coverImage: doc["coverImage"],
                                      share: doc["share"],
                                      title: doc["title"],
                                      username: doc["username"],
                                      email: doc["email"]
                                    ),
                                  );
                                }));
                              },
                              child: BlogCard(
                                addBlogModel: AddBlogModel(
                                  body: doc["body"],
                                  comment: doc["comment"],
                                  count: doc["count"],
                                  coverImage: doc["coverImage"],
                                  share: doc["share"],
                                  title: doc["title"],
                                  email: doc["email"],
                                  username: doc["username"],
                                ),
                              ),
                            )
                          : Container();
                    })
                : Center(
                    child: Text("No data"),
                  );
          },
        ),
      ],
    );
  }
}
