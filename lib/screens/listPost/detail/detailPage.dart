import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_exercises/helper/utility.dart';
import 'package:final_exercises/models/post.dart';
import 'package:final_exercises/providers/UserProvider.dart';
import 'package:final_exercises/providers/post.state.dart';
import 'package:final_exercises/screens/listPost/comments/commentPage.dart';
import 'package:final_exercises/screens/listPost/comments/commentPost.dart';
import 'package:final_exercises/screens/listPost/detail/feedpostDetail.dart';
import 'package:final_exercises/screens/listPost/feedpost.dart';
import 'package:final_exercises/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  final PostModel postModel;
  final String? currentUserId;

  DetailPage({super.key, required this.postModel, required this.currentUserId});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isExpanded = false;
  double textHeight = 0;
  bool isLiked = false;
  int likeCount = 0;
  int commentCount = 0;
  bool onPressedValue = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    likeCount = widget.postModel.likes ?? 0;
    commentCount = widget.postModel.commentsCount ?? 0;
    isLiked = widget.postModel.likedUsers!.contains(widget.currentUserId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostState>(context, listen: false)
          .getPostsByPostIdRepply(widget.postModel.key!);
    });
  }

  Future<void> _refreshPosts() async {
    await Provider.of<PostState>(context, listen: false)
        .getPostsByPostIdRepply(widget.postModel.key!);
  }

// Hàm xử lý sự kiện nhấn vào biểu tượng like
  void _toggleLike() async {
    if (isLiked) {
      await unlikePost(widget.postModel, widget.currentUserId!);
      setState(() {
        isLiked = false;
        likeCount--;
        onPressedValue = false;
      });
      // Timer để kích hoạt lại nút sau 30 giây
      _timer = Timer(Duration(seconds: 1), () {
        setState(() {
          onPressedValue = true;
        });
      });
    } else {
      await likePost(widget.postModel, widget.currentUserId!);
      setState(() {
        isLiked = true;
        likeCount++;
        onPressedValue = false;
      });
      // Timer để kích hoạt lại nút sau 30 giây
      _timer = Timer(Duration(seconds: 1), () {
        setState(() {
          onPressedValue = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
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
      body: Consumer<PostState>(builder: (context, state, child) {
        return Container(
          color: Colors.black,
          child: RefreshIndicator(
            onRefresh: _refreshPosts,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 0.2,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey,
                ),
                Container(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          widget.postModel.user!.profileImageUrl.toString()),
                    ),
                    Text(
                      widget.postModel.user!.username.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                    ),
                    Text(
                      Utility.getdob(widget.postModel.createdAt.toString()),
                      style: TextStyle(
                          color: const Color.fromARGB(255, 78, 78, 78)),
                    ),
                    Container(
                      width: 5,
                    ),
                    Icon(Icons.more_horiz, color: Colors.white)
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.postModel.bio.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                widget.postModel.imagePath == null
                    ? SizedBox.shrink()
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(left: 15, right: 10),
                                child: widget.postModel.imagePath == null
                                    ? SizedBox.shrink()
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: CachedNetworkImage(
                                            height: 300,
                                            width: 290,
                                            fit: BoxFit.cover,
                                            imageUrl: widget.postModel.imagePath
                                                .toString()))),
                          ],
                        ),
                      ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: onPressedValue ? _toggleLike : null,
                            icon: AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return ScaleTransition(
                                    scale: animation, child: child);
                              },
                              child: Icon(
                                isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                key: ValueKey<bool>(isLiked),
                                color: isLiked ? Colors.red : Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Xử lý sự kiện nhấn vào biểu tượng bình luận
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CommentScreen(
                                        postModel: widget.postModel)),
                              ).then((_) {
                                _refreshPosts();
                              });
                            },
                            icon: Icon(
                              Icons.comment,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        children: [
                          Text('$likeCount likes',
                              style: TextStyle(color: Colors.grey)),
                          SizedBox(width: 10),
                          Text('$commentCount replies',
                              style: TextStyle(color: Colors.grey)),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 0.2,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey,
                ),
                Expanded(
                  child: state.isBusy
                      ? Center(child: CircularProgressIndicator())
                      : state.feedlistForPost == null ||
                              state.feedlistForPost!.isEmpty
                          ? Center(
                              child: Text(
                                'No posts available',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : ListView.builder(
                              itemCount: state.feedlistForPost!.length,
                              itemBuilder: (context, index) {
                                return FeedPostOfParentPost(
                                  postModel: state.feedlistForPost![index],
                                  currentUserId: widget.currentUserId,
                                  onItemTap: _refreshPosts,
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
