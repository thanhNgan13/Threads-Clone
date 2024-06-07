import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_exercises/models/post.dart';
import 'package:final_exercises/models/user.dart';
import 'package:final_exercises/screens/composePost/widget/composeBottomIconWidget.dart';
import 'package:final_exercises/services/post_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class FeedPostDetail extends StatefulWidget {
  final PostModel postModel;
  final UserModel userModel;

  FeedPostDetail({super.key, required this.postModel, required this.userModel});

  @override
  State<FeedPostDetail> createState() => _FeedPostDetailState();
}

class _FeedPostDetailState extends State<FeedPostDetail> {
  bool isExpanded = false;
  bool showMoreButton = false;
  double textHeight = 0;
  late ScrollController scrollcontroller;
  late TextEditingController _textEditingController;
  File? _file;
  bool select = false;
  int nums = 0;
  bool isButtonEnabled = false;
  final GlobalKey _textFieldKey = GlobalKey();
  double textFieldHeight = 0.0;
  final GlobalKey _containerKey = GlobalKey();
  double imageHeight = 0.0;

  void _onImageIconSelcted(File file) {
    setState(() {
      _file = file;
      isButtonEnabled = true;
      _updateImageHeight();
    });
  }

  @override
  void initState() {
    super.initState();

    scrollcontroller = ScrollController();
    _textEditingController = TextEditingController();
    _textEditingController.addListener(() {
      setState(() {
        isButtonEnabled = _textEditingController.text.isNotEmpty;
      });
      _updateTextFieldHeight();
    });

    textHeight = calculateTextHeight(
        widget.postModel.bio!,
        TextStyle(color: Colors.white),
        300); // 300 là độ rộng giới hạn của văn bản
    print("Text Height: $textHeight");
  }

  @override
  void dispose() {
    scrollcontroller.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  void _updateTextFieldHeight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? renderBox =
          _textFieldKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        setState(() {
          textFieldHeight = renderBox.size.height;
        });
        print("TextField Height: $textFieldHeight");
      }
    });
  }

  void _updateImageHeight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? renderBox =
          _containerKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        setState(() {
          imageHeight = renderBox.size.height;
        });
        print("Image Height: $imageHeight");
      }
    });
  }

  double calculateTextHeight(String text, TextStyle style, double maxWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: null, // Đặt số dòng tối đa hoặc null nếu không giới hạn số dòng
    )..layout(maxWidth: maxWidth);

    return textPainter.size.height;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 5.0, top: 10.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        widget.postModel.user!.profileImageUrl.toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.postModel.user!.username.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25),
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
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            widget.postModel.imagePath == null
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(widget
                                    .userModel.profileImageUrl
                                    .toString()),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.userModel.username.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                          padding: EdgeInsets.only(left: 25),
                          child: Row(
                            children: [
                              Container(
                                width: 2,
                                height: textFieldHeight,
                                color: const Color.fromARGB(255, 46, 46, 46),
                              ),
                              const SizedBox(width: 25),
                              Expanded(
                                child: TextField(
                                  key: _textFieldKey,
                                  controller: _textEditingController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Reply to this post " +
                                        widget.postModel.user!.username
                                            .toString(),
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 112, 112, 112),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  cursorColor: Colors.white,
                                  cursorHeight: 20,
                                  cursorWidth: 2,
                                  cursorRadius: Radius.circular(10),
                                  onChanged: (value) {
                                    setState(() {
                                      nums = value.length;
                                      isButtonEnabled = value.isNotEmpty;
                                      _updateTextFieldHeight();
                                    });
                                  },
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(left: 25),
                          child: Row(
                            children: [
                              const SizedBox(width: 15),
                              ComposeBottomIconWidget(
                                textEditingController: _textEditingController,
                                onImageIconSelcted: _onImageIconSelcted,
                              ),
                            ],
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.12,
                        height: MediaQuery.of(context).size.height / 2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2)),
                        child: _file == null
                            ? SizedBox.shrink()
                            : Stack(
                                children: [
                                  Image.file(_file!),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _file = null;
                                          isButtonEnabled = false;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 25, right: 10),
                          child: widget.postModel.imagePath == null
                              ? SizedBox.shrink()
                              : Row(
                                  children: [
                                    Container(
                                      width: 2,
                                      height: 300,
                                      color:
                                          const Color.fromARGB(255, 46, 46, 46),
                                    ),
                                    const SizedBox(width: 25),
                                    Expanded(
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: CachedNetworkImage(
                                              height: 300,
                                              width: 290,
                                              fit: BoxFit.cover,
                                              imageUrl: widget
                                                  .postModel.imagePath
                                                  .toString())),
                                    ),
                                  ],
                                )),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(widget
                                    .userModel.profileImageUrl
                                    .toString()),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.userModel.username.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                          padding: EdgeInsets.only(left: 25),
                          child: Row(
                            children: [
                              Container(
                                width: 2,
                                height: textFieldHeight,
                                color: const Color.fromARGB(255, 46, 46, 46),
                              ),
                              const SizedBox(width: 25),
                              Expanded(
                                child: TextField(
                                  key: _textFieldKey,
                                  controller: _textEditingController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Reply to this post " +
                                        widget.postModel.user!.username
                                            .toString(),
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 112, 112, 112),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  cursorColor: Colors.white,
                                  cursorHeight: 20,
                                  cursorWidth: 2,
                                  cursorRadius: Radius.circular(10),
                                  onChanged: (value) {
                                    setState(() {
                                      nums = value.length;
                                      isButtonEnabled = value.isNotEmpty;
                                      _updateTextFieldHeight();
                                    });
                                  },
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(left: 25),
                          child: Row(
                            children: [
                              const SizedBox(width: 15),
                              ComposeBottomIconWidget(
                                textEditingController: _textEditingController,
                                onImageIconSelcted: _onImageIconSelcted,
                              ),
                            ],
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.12,
                        height: MediaQuery.of(context).size.height / 2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2)),
                        child: _file == null
                            ? SizedBox.shrink()
                            : Stack(
                                children: [
                                  Image.file(_file!),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _file = null;
                                          isButtonEnabled = false;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60.0,
        shape: CircularNotchedRectangle(),
        color: Colors.black,
        notchMargin: 5.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Your followers can reply",
                style: TextStyle(
                    color: Color.fromARGB(255, 112, 112, 112), fontSize: 14),
              ),
              ElevatedButton(
                onPressed: isButtonEnabled
                    ? () async {
                        String postId = widget.postModel.key!;
                        String userId = widget.userModel.id!;
                        String comment = _textEditingController.text;

                        print("Post ID: $postId");
                        print("User ID: $userId");
                        print("Comment: $comment");

                        await addComment(postId, userId, comment);

                        setState(() {
                          _textEditingController.clear();
                          isButtonEnabled = false;
                        });
                      }
                    : null,
                child: Text(
                  "Reply",
                  style: TextStyle(color: Colors.black),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled))
                        return Color.fromARGB(
                            255, 143, 139, 139); // Màu khi bị disable
                      return Colors.white; // Màu chữ khi enable
                    },
                  ),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled))
                        return Color.fromARGB(
                            66, 0, 0, 0); // Màu chữ khi bị disable
                      return Colors.white; // Màu chữ khi enable
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
