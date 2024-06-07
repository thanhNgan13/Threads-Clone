import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_exercises/helper/utility.dart';
import 'package:final_exercises/models/post.dart';
import 'package:final_exercises/screens/listPost/comments/commentPage.dart';
import 'package:final_exercises/screens/listPost/detail/detailPage.dart';
import 'package:final_exercises/services/post_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class DetailPost extends StatefulWidget {
  final PostModel postModel;
  final String? currentUserId;

  DetailPost({super.key, required this.postModel, this.currentUserId});

  @override
  State<DetailPost> createState() => _DetailPostState();
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
    // Kiểm tra độ dài của văn bản và cập nhật trạng thái showMoreButton
    if (widget.postModel.bio != null && widget.postModel.bio!.length > 500) {
      showMoreButton = true;
    }
    likeCount = widget.postModel.likes ?? 0;
    commentCount = widget.postModel.commentsCount ?? 0;
    isLiked = widget.postModel.likedUsers!.contains(widget.currentUserId);
    textHeight = calculateTextHeight(
        widget.postModel.bio!,
        TextStyle(color: Colors.white),
        300); // 300 là độ rộng giới hạn của văn bản
    print("Text Height: $textHeight");
  }

  double calculateTextHeight(String text, TextStyle style, double maxWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: null, // Đặt số dòng tối đa hoặc null nếu không giới hạn số dòng
    )..layout(maxWidth: maxWidth);

    return textPainter.size.height;
  }

  // Hàm xử lý sự kiện nhấn vào biểu tượng like
  void _toggleLike() async {
    if (isLiked) {
      await unlikePost(widget.postModel, widget.currentUserId!);
      setState(() {
        isLiked = false;
        likeCount--;
      });
    } else {
      await likePost(widget.postModel, widget.currentUserId!);
      setState(() {
        isLiked = true;
        likeCount++;
      });
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
                style: TextStyle(color: const Color.fromARGB(255, 78, 78, 78)),
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
                    // Button like
                    IconButton(
                      onPressed: _toggleLike,
                      icon: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                              scale: animation, child: child);
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
                        // Xử lý sự kiện nhấn vào biểu tượng bình luận
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
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: [
                    Text('$likeCount likes',
                        style: TextStyle(
                            color: Colors.grey)), // Hiển thị số lượng like
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
          Column()
        ],
      ),
    );
  }
}
