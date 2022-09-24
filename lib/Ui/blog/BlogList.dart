import 'package:blogapp/Model/addBlogModels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

class BlogDetail extends StatelessWidget {
  const BlogDetail({Key? key,required this.addBlogModel,})
      : super(key: key);
  final AddBlogModel addBlogModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color(0xffEEEEFF),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Container(
              height: 100,
              
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                     ProfilePicture(
                      name: addBlogModel.username!,
                    radius: 31,
                    
                      fontsize: 21,
                        ),
                      SizedBox(width: 16,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            addBlogModel.username!,
                            style: TextStyle(color: Color(0xFF303030),fontSize: 20),
                          ),
                         
                          Text(
                           addBlogModel.email!,
                            style: TextStyle(color:  Color(0xFF303030)),
                          )
                        ],
                      ),
                    ],
                  ),
                  
                ],
              ),
            ),
          
            Container(
              height: MediaQuery.of(context).size.height *0.45,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 230,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:NetworkImage(addBlogModel.coverImage!),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Center(
                    child: Text(
                      addBlogModel.title!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF303030),
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble,color: Color(0xFF303030),
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        addBlogModel.comment.toString(),
                        style: TextStyle(fontSize: 15,color: Color(0xFF303030)),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Icon(
                        Icons.thumb_up,color: Color(0xFF303030),
                        size: 18,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        addBlogModel.count.toString(),
                        style: TextStyle(fontSize: 15,color: Color(0xFF303030)),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Icon(
                        Icons.share,color: Color(0xFF303030),
                        size: 18,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        addBlogModel.share.toString(),
                        style: TextStyle(fontSize: 15,color: Color(0xFF303030)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                child: Text(addBlogModel.body!,
                textAlign: TextAlign.center,
                style: TextStyle(color:  Color(0xFF303030)),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
