import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_exercises/helper/utility.dart';
import 'package:final_exercises/models/post.dart';
import 'package:final_exercises/screens/listPost/comments/commentPage.dart';
import 'package:final_exercises/screens/listPost/detail/EditPostScreen.dart';
import 'package:final_exercises/screens/listPost/detail/detailPage.dart';
import 'package:final_exercises/services/post_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class DetailPost extends StatefulWidget {
  late final PostModel postModel;
  final String currentUserId;

  DetailPost({required this.postModel, required this.currentUserId});

  @override
  _DetailPostState createState() => _DetailPostState();
}

class _DetailPostState extends State<DetailPost> {
  bool isExpanded = false;
  bool showMoreButton = false;
  double textHeight = 0;
  bool isLiked = false;
  int likeCount = 0;
  int commentCount = 0;

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
        widget.postModel.bio ?? '', TextStyle(color: Colors.white), 300);
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
      await unlikePost(widget.postModel, widget.currentUserId);
      setState(() {
        isLiked = false;
        likeCount--;
      });
    } else {
      await likePost(widget.postModel, widget.currentUserId);
      setState(() {
        isLiked = true;
        likeCount++;
      });
    }
  }

  void _editPost() {
    // Navigate to the edit post screen with the current postModel
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditPostScreen(postModel: widget.postModel);
    })).then((updatedPost) {
      if (updatedPost != null) {
        setState(() {
          widget.postModel = updatedPost;
        });
      }
    });
  }

  void _deletePost() async {
    bool? confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Post'),
        content: Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await deletePost(widget.postModel.key!, widget.currentUserId!);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                backgroundImage:
                    NetworkImage(widget.postModel.user?.profileImageUrl ?? ''),
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
                Utility.getdob(widget.postModel.createdAt?.toString() ?? ''),
                style: TextStyle(color: const Color.fromARGB(255, 78, 78, 78)),
              ),
              Container(
                width: 5,
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_horiz, color: Colors.white),
                onSelected: (String value) {
                  if (value == 'edit') {
                    _editPost();
                  } else if (value == 'delete') {
                    _deletePost();
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
                elevation:
                    10, // Set the elevation to make the popup appear on top
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Set the border radius for the popup
                ),
                offset: Offset(0,
                    -10), // Set the offset to adjust the position of the popup
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
                  padding: const EdgeInsets.only(right: 20.0),
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
                                    imageUrl: widget
                                            .postModel.user?.profileImageUrl ??
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
                    onPressed: _toggleLike,
                    icon: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey<bool>(isLiked),
                        color: isLiked ? Colors.red : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CommentScreen(
                          postModel: widget.postModel,
                        );
                      }));
                    },
                    icon: Icon(
                      Iconsax.repeat,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Iconsax.share,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Iconsax.send_2,
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
    );
  }
}
