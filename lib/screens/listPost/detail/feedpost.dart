import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_exercises/helper/utility.dart';
import 'package:final_exercises/models/post.dart';
import 'package:final_exercises/screens/listPost/comments/commentPage.dart';
import 'package:final_exercises/screens/listPost/detail/detailPage.dart';
import 'package:final_exercises/services/post_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class FeedPost extends StatefulWidget {
  final PostModel postModel;
  final String? currentUserId;

  FeedPost({super.key, required this.postModel, this.currentUserId});

  @override
  State<FeedPost> createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {
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
    return InkWell(
      onTap: () {
        // Xử lý sự kiện nhấn vào bài viết
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DetailPage(
            postModel: widget.postModel,
          );
        }));
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
                  style:
                      TextStyle(color: const Color.fromARGB(255, 78, 78, 78)),
                ),
                Container(
                  width: 5,
                ),
                Icon(Icons.more_horiz, color: Colors.white)
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Đảm bảo các widget con được căn từ trên xuống

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
                            widget.postModel.bio.toString(),
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
                                          .postModel.user!.profileImageUrl
                                          .toString(),
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
                                        imageUrl: widget
                                            .postModel.user!.profileImageUrl
                                            .toString(),
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
                                        imageUrl: widget.postModel.imagePath
                                            .toString()))),
                      ],
                    ),
                  ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 40),
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
                Row(
                  children: <Widget>[
                    Container(
                      width: 50,
                    ),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
