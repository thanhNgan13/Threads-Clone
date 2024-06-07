import 'package:final_exercises/providers/UserProvider.dart';
import 'package:final_exercises/providers/post.state.dart';
import 'package:final_exercises/screens/listPost/feedpost.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../helper/utility.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostState>(context, listen: false).getPosts();
    });
  }

  Future<void> _refreshPosts() async {
    await Provider.of<PostState>(context, listen: false).getPosts();
  }

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
      body: Consumer<PostState>(
        builder: (context, state, child) {
          if (state.isBusy) {
            return Center(child: CircularProgressIndicator());
          } else if (state.feedlist == null || state.feedlist!.isEmpty) {
            return Center(
                child: Text(
              'No posts available',
              style: TextStyle(color: Colors.white),
            ));
          } else {
            return RefreshIndicator(
              onRefresh: _refreshPosts,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.feedlist!.length,
                itemBuilder: (context, index) {
                  return FeedPost(
                    postModel: state.feedlist![index],
                    currentUserId:
                        Provider.of<UserProvider>(context).currentUser?.id,
                    onItemTap: _refreshPosts,
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
