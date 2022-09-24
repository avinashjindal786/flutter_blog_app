import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:blogapp/Ui/blog/addBlog_viewModel.dart';
import 'package:blogapp/core/CustumWidget/OverlayCard.dart';
import 'package:blogapp/Model/addBlogModels.dart';
import 'package:blogapp/Ui/home_screen/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:stacked/stacked.dart';

class AddBlog extends StatefulWidget {
  AddBlog({Key? key}) : super(key: key);

  @override
  _AddBlogState createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  final _globalkey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _body = TextEditingController();
  ImagePicker _picker = ImagePicker();
  XFile? _image;
  IconData iconphoto = Icons.image;
  final selectedImage = null;

  final storage = FlutterSecureStorage();
  String username = "";
  String profileImage = "";
  String emailId = "";

  String filter = "Movie";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => AddBlogViewModel(),
        builder: (context, model, child) => LoadingOverlay(
              isLoading: model.isBusy,
              progressIndicator: CircularProgressIndicator(
                color: Colors.white,
              ),
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                      icon: Icon(Icons.clear, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                bottomNavigationBar: Material(
                  color: Colors.teal,
                  child: InkWell(
                    onTap: () async {
                      //print('called on tap');
                      await model.uploadBlog(_image!, username, emailId, _title.text, _body.text,filter);
                      Navigator.pop(context);
                    },
                    child: const SizedBox(
                      height: kToolbarHeight,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'Add Blog',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                body: Form(
                  key: _globalkey,
                  child: ListView(
                    children: <Widget>[
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
                                decoration: BoxDecoration(color: filter == "Movie" ? Colors.teal : Color(0xFF303030), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white)),
                                child: Center(
                                  child: Text(
                                    "Movie",
                                    style: TextStyle(color: Colors.white),
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
                                decoration: BoxDecoration(color: filter == "Sport" ? Colors.teal : Color(0xFF303030), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white)),
                                child: Center(
                                  child: Text(
                                    "Sport",
                                    style: TextStyle(color: Colors.white),
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
                      GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: _image != null
                              ? Container(
                                  margin: EdgeInsets.symmetric(horizontal: 12),
                                  height: 170,
                                  width: MediaQuery.of(context).size.width,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.file(
                                      File(_image!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.symmetric(horizontal: 12),
                                  height: 170,
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                                  width: MediaQuery.of(context).size.width,
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.black45,
                                  ),
                                )),
                      titleTextField(),
                      bodyTextField(),
                    ],
                  ),
                ),
              ),
            ));
  }

  Widget titleTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: TextFormField(
        controller: _title,
        validator: (value) {
          if (value!.isEmpty) {
            return "Title can't be empty";
          } else if (value.length > 100) {
            return "Title length should be <=100";
          }
          return null;
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.teal,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.teal,
                width: 2,
              ),
            ),
            labelText: "Add Image and Title",
            labelStyle: TextStyle(color: Colors.white)
            // prefixIcon: IconButton(
            //   icon: Icon(
            //     iconphoto,
            //     color: Colors.teal,
            //   ),
            //   onPressed: takeCoverPhoto,
            // ),
            ),
        maxLength: 100,
        maxLines: null,
      ),
    );
  }

  Widget bodyTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: TextFormField(
        controller: _body,
        validator: (value) {
          if (value!.isEmpty) {
            return "Body can't be empty";
          }
          return null;
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.teal,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.teal,
                width: 2,
              ),
            ),
            labelText: "Provide Body Your Blog",
            labelStyle: TextStyle(color: Colors.white)),
        maxLines: 10,
        minLines: 1,
      ),
    );
  }

  // Widget addButton() {
  //   return InkWell(
  //     onTap: () async {
  //       if (_imageFile != null && _globalkey.currentState!.validate()) {
  //         // AddBlogModel addBlogModel =
  //         //     AddBlogModel(body: _body.text, title: _title.text);
  //         // var response = await networkHandler.post1(
  //         //     "/blogpost/Add", addBlogModel.toJson());
  //         // print(response.body);

  //         // if (response.statusCode == 200 || response.statusCode == 201) {
  //         //   String id = json.decode(response.body)["data"];
  //         //   var imageResponse = await networkHandler.patchImage(
  //         //       "/blogpost/add/coverImage/$id", _imageFile!.path);
  //         //   print(imageResponse.statusCode);
  //         //   if (imageResponse.statusCode == 200 ||
  //         //       imageResponse.statusCode == 201) {
  //         //     Navigator.pushAndRemoveUntil(
  //         //         context,
  //         //         MaterialPageRoute(builder: (context) => HomePage()),
  //         //         (route) => false);
  //         //   }
  //         // }
  //       }
  //     },
  //     child: Center(
  //       child: Container(
  //         height: 50,
  //         width: 200,
  //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.teal),
  //         child: Center(
  //             child: Text(
  //           "Add Blog",
  //           style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
  //         )),
  //       ),
  //     ),
  //   );
  // }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      iconphoto = Icons.check_box;
    });
  }
}
