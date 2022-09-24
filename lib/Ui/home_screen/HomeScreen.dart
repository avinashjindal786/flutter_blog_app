import 'package:blogapp/Ui/blog/Blogs.dart';
import 'package:blogapp/Ui/blog/addBlog_viewModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:stacked/stacked.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
                backgroundColor: Color(0xffEEEEFF),
                body: Blogs(
                  url: "/blogpost/getOtherBlog",
                ),
              ),
        ));
  }
}
