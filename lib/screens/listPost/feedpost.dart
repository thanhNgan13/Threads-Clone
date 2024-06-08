import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:final_exercises/helper/utility.dart';
import 'package:final_exercises/models/post.dart';
import 'package:final_exercises/screens/listPost/comments/commentPage.dart';
import 'package:final_exercises/screens/listPost/detail/detailPage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:final_exercises/screens/listPost/detail/EditPostScreen.dart';
import 'package:final_exercises/services/post_service.dart';

class FeedPost extends StatefulWidget {
  late final PostModel postModel;
  final String? currentUserId;
  final VoidCallback? onItemTap;

  FeedPost(
      {super.key, required this.postModel, this.currentUserId, this.onItemTap});

  @override
  _FeedPostState createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {
  bool isExpanded = false;
  bool showMoreButton = false;
  double textHeight = 0;
  bool isLiked = false;
  int likeCount = 0;
  int commentCount = 0;
  bool onPressedValue = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.postModel.bio != null && widget.postModel.bio!.length > 500) {
      showMoreButton = true;
    }
    likeCount = widget.postModel.likes ?? 0;
    commentCount = widget.postModel.commentsCount ?? 0;
    isLiked =
        widget.postModel.likedUsers?.contains(widget.currentUserId) ?? false;
    textHeight = calculateTextHeight(
        widget.postModel.bio!,
        TextStyle(color: Colors.white),
        300); // 300 là độ rộng giới hạn của văn bản
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  double calculateTextHeight(String text, TextStyle style, double maxWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(maxWidth: maxWidth);

    return textPainter.size.height;
  }

  void _toggleLike() async {
    if (isLiked) {
      await unlikePost(widget.postModel, widget.currentUserId!);
      setState(() {
        isLiked = false;
        likeCount--;
        onPressedValue = false;
      });
      // Timer để kích hoạt lại nút sau 30 giây
      _timer = Timer(Duration(seconds: 2), () {
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
      _timer = Timer(Duration(seconds: 2), () {
        setState(() {
          onPressedValue = true;
        });
      });
    }
  }

  void _editPost() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => EditPostScreen(postModel: widget.postModel)),
    // ).then((updatedPost) {
    //   if (updatedPost != null) {
    //     setState(() {
    //       widget.postModel = updatedPost;
    //     });
    //   }
    // });
  }

  void _deletePost() async {
    // if (widget.postModel.key == null || widget.currentUserId == null) {
    //   print('Error: Post key or currentUserId is null.');
    //   return;
    // }

    // bool? confirmed = await showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: Text('Delete Post'),
    //     content: Text('Are you sure you want to delete this post?'),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.pop(context, false),
    //         child: Text('Cancel', style: TextStyle(color: Colors.blue)),
    //       ),
    //       TextButton(
    //         onPressed: () => Navigator.pop(context, true),
    //         child: Text('Delete', style: TextStyle(color: Colors.red)),
    //       ),
    //     ],
    //   ),
    // );

    // if (confirmed == true) {
    //   try {
    //     await deletePost(widget.postModel.key!, widget.currentUserId!);
    //     if (Navigator.canPop(context)) {
    //       Navigator.pop(context); // Navigate back to the previous screen
    //     }
    //   } catch (e) {
    //     print('Failed to delete post: $e');
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Failed to delete post. Please try again.')),
    //     );
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(widget.postModel.key.toString());

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPage(
                    postModel: widget.postModel,
                    currentUserId: widget.currentUserId,
                  )),
        ).then((_) {
          widget.onItemTap!();
        });
      },
      child: Container(
        color: Colors.black,
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
                      widget.postModel.user?.profileImageUrl ?? ''),
                ),
                Text(
                  widget.postModel.user?.username ?? '',
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
                  style:
                      TextStyle(color: const Color.fromARGB(255, 78, 78, 78)),
                ),
                Container(
                  width: 5,
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_horiz, color: Colors.white),
                  onSelected: (String value) {
                    if (value == 'Edit') {
                      _editPost();
                    } else if (value == 'Delete') {
                      try {
                        _deletePost();
                      } catch (e) {
                        print('Failed to delete post: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Failed to delete post. Please try again.')),
                        );
                      }
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return {'Edit', 'Delete'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  offset: Offset(0, -10),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 2,
                          height: textHeight,
                          color: const Color.fromARGB(255, 46, 46, 46),
                        ),
                        const SizedBox(width: 25),
                        Expanded(
                          child: Text(
                            widget.postModel.bio ?? '',
                            maxLines: isExpanded ? null : 10,
                            overflow: isExpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showMoreButton)
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: InkWell(
                        child: Text(
                          isExpanded ? 'Thu gọn' : 'Xem thêm',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
            widget.postModel.imagePath == null
                ? Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 5,
                            ),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                    height: 15,
                                    width: 15,
                                    child: CachedNetworkImage(
                                      imageUrl: widget.postModel.user
                                              ?.profileImageUrl ??
                                          '',
                                    ))),
                          ],
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Column(
                            children: [
                              Container(
                                width: 2,
                                height: 300,
                                color: const Color.fromARGB(255, 46, 46, 46),
                              ),
                              const SizedBox(height: 25),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                      height: 15,
                                      width: 15,
                                      child: CachedNetworkImage(
                                        imageUrl: widget.postModel.user
                                                ?.profileImageUrl ??
                                            '',
                                      ))),
                            ],
                          ),
                        ),
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
                                        imageUrl:
                                            widget.postModel.imagePath ?? ''))),
                      ],
                    ),
                  ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 40),
                    IconButton(
                      onPressed: onPressedValue ? _toggleLike : null,
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey<bool>(isLiked),
                        color: isLiked ? Colors.red : Colors.white,
                        size: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Xử lý sự kiện nhấn vào biểu tượng bình luận
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CommentScreen(postModel: widget.postModel)),
                        ).then((_) {
                          widget.onItemTap!();
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
                Row(
                  children: <Widget>[
                    Container(
                      width: 50,
                    ),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
