import 'package:final_exercises/models/post.dart';
import 'package:final_exercises/providers/UserProvider.dart';
import 'package:final_exercises/screens/listPost/detail/detailPost.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  final PostModel postModel;

  DetailPage({Key? key, required this.postModel}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 29, 29, 29),
        elevation: 0,
        title: Text(
          "Threads",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: currentUser != null
          ? DetailPost(
              postModel: widget.postModel,
              currentUserId: currentUser.id!,
            )
          : Center(
              child: Text('User not logged in'),
            ),
    );
  }
}
