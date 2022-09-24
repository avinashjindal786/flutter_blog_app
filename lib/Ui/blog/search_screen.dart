import 'package:blogapp/Ui/blog/BlogList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

import '../../Model/addBlogModels.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEEEFF),
     
        appBar: AppBar(
            title: Card(
          child: TextField(
            decoration: InputDecoration(prefixIcon: Icon(Icons.search,color: Colors.white,), hintText: 'Search...'),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        )),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('blogs').snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data() as Map<String, dynamic>;

                      if (name.isEmpty) {
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return BlogDetail(
                                addBlogModel: AddBlogModel(body: data["body"], comment: data["comment"], count: data["count"], coverImage: data["coverImage"], share: data["share"], title: data["title"], username: data["username"], email: data["email"]),
                              );
                            }));
                          },
                          child: ListTile(
                            title: Text(
                              data['username'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              data['email'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            leading: ProfilePicture(
                              name: data["username"],
                              radius: 25,
                              fontsize: 21,
                            ),
                          ),
                        );
                      }
                      if (data['username'].toString().toLowerCase().startsWith(name.toLowerCase())) {
                        return ListTile(
                          title: Text(
                            data['username'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            data['email'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          leading: ProfilePicture(
                      name: data["username"],
                    radius: 31,
                    
                      fontsize: 21,
                        ),
                        );
                      }
                      return Container();
                    });
          },
        ));
  }
}
