import 'package:final_exercises/models/post.dart';
import 'package:final_exercises/providers/UserProvider.dart';
import 'package:final_exercises/providers/post.state.dart';
import 'package:final_exercises/screens/listPost/feedpost.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ListPostWidget extends StatefulWidget {
  const ListPostWidget({super.key});

  @override
  State<ListPostWidget> createState() => _ListPostWidgetState();
}

class _ListPostWidgetState extends State<ListPostWidget> {
  ScrollController _scrollController = ScrollController();

  bool isExpanded = false;
  bool showMoreButton = false;

  String imagePath =
      "https://fastly.picsum.photos/id/9/250/250.jpg?hmac=tqDH5wEWHDN76mBIWEPzg1in6egMl49qZeguSaH9_VI";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: Lottie.network(
            "https://assets3.lottiefiles.com/packages/lf20_Ht77kFLXYw.json",
            height: 50),
        toolbarHeight: 37,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<List<PostModel>>(
        stream: Provider.of<PostState>(context).feedStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No posts available'));
          }
          List<PostModel> posts = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return FeedPost(
                  postModel: posts[index],
                  currentUserId:
                      Provider.of<UserProvider>(context, listen: false)
                          .currentUser
                          ?.id,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
