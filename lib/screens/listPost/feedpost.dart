import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_exercises/helper/utility.dart';
import 'package:final_exercises/models/post.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class FeedPost extends StatefulWidget {
  PostModel postModel;

  FeedPost({super.key, required this.postModel});

  @override
  State<FeedPost> createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {
  bool isExpanded = false;
  bool showMoreButton = false;

  @override
  void initState() {
    super.initState();
    // Kiểm tra độ dài của văn bản và cập nhật trạng thái showMoreButton
    if (widget.postModel.bio != null && widget.postModel.bio!.length > 200) {
      setState(() {
        showMoreButton = true;
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
                  style:
                      TextStyle(color: const Color.fromARGB(255, 78, 78, 78)),
                ),
                Container(
                  width: 5,
                ),
                Icon(Icons.more_horiz, color: Colors.white)
              ],
            ),
            Padding(
                padding: EdgeInsets.only(left: 55),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.postModel.bio.toString(),
                      maxLines: isExpanded ? null : 10,
                      overflow: isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(color: Colors.white),
                    ),
                    if (showMoreButton)
                      InkWell(
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
                  ],
                )),
            widget.postModel.imagePath == null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 12,
                      ),
                      Column(
                        children: [
                          Container(
                            width: 2,
                            height: 30,
                            color: const Color.fromARGB(255, 46, 46, 46),
                          ),
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
                      Padding(
                          padding: EdgeInsets.only(left: 20, right: 10),
                          child: widget.postModel.imagePath == null
                              ? SizedBox.shrink()
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                      height: 300,
                                      width: 330,
                                      fit: BoxFit.cover,
                                      imageUrl: widget.postModel.imagePath
                                          .toString()))),
                    ],
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 10,
                        ),
                        Column(
                          children: [
                            Container(
                              width: 2,
                              height: 300,
                              color: const Color.fromARGB(255, 46, 46, 46),
                            ),
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
                        Padding(
                            padding: EdgeInsets.only(left: 48, right: 10),
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
            Container(
              height: 10,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                    ),
                    Icon(
                      Iconsax.heart,
                      color: Colors.white,
                      size: 20,
                    ),
                    Container(
                      width: 10,
                    ),
                    Icon(
                      Iconsax.share,
                      color: Colors.white,
                      size: 20,
                    ),
                    Container(
                      width: 10,
                    ),
                    Icon(
                      Iconsax.repeat,
                      color: Colors.white,
                      size: 20,
                    ),
                    Container(
                      width: 10,
                    ),
                    Icon(
                      Iconsax.send_2,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 50,
                    ),
                    Text('12 likes', style: TextStyle(color: Colors.grey)),
                    SizedBox(width: 10),
                    Text('4 replies', style: TextStyle(color: Colors.grey)),
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
        ));
  }
}
