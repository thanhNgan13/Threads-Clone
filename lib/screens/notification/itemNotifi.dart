import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_exercises/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:final_exercises/helper/utility.dart';
import 'package:final_exercises/models/post.dart';
import 'package:final_exercises/screens/listPost/comments/commentPage.dart';
import 'package:final_exercises/screens/listPost/detail/detailPage.dart';
import 'package:final_exercises/services/post_service.dart';
import 'package:provider/provider.dart';

class ItemNotification extends StatefulWidget {
  final PostModel postModel;
  final PostModel postModelParent;
  final VoidCallback? onItemTap;

  ItemNotification(
      {super.key,
      required this.postModel,
      required this.postModelParent,
      this.onItemTap});

  @override
  _ItemNotificationState createState() => _ItemNotificationState();
}

class _ItemNotificationState extends State<ItemNotification> {
  bool isExpanded = false;
  bool showMoreButton = false;
  double textHeight = 0;
  bool isLiked = false;

  bool onPressedValue = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.postModel.bio != null && widget.postModel.bio!.length > 500) {
      showMoreButton = true;
    }
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(widget.postModel.key.toString());

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPage(
                    postModel: widget.postModelParent,
                    currentUserId:
                        Provider.of<UserProvider>(context, listen: false)
                            .currentUser
                            ?.id,
                  )),
        );
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
                const SizedBox(width: 10),
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
                      print('Edit');
                    } else if (value == 'Delete') {
                      try {
                        print('Delete');
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
                        const SizedBox(width: 25),
                        Expanded(
                          child: Text(
                            widget.postModelParent.bio ?? '',
                            maxLines: isExpanded ? null : 10,
                            overflow: isExpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                                color:
                                    const Color.fromARGB(255, 122, 117, 117)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                        const SizedBox(width: 25),
                        Expanded(
                          child: Text(
                            widget.postModel.bio ?? '',
                            maxLines: isExpanded ? null : 10,
                            overflow: isExpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 0.2,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
