// ignore_for_file: unnecessary_null_comparison, unused_element
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:final_exercises/models/user.dart';
import 'package:final_exercises/providers/UserProvider.dart';
import 'package:final_exercises/providers/post.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import 'widget/composeBottomIconWidget.dart';

class ComposePost extends StatefulWidget {
  final VoidCallback navigateToHome;

  ComposePost({Key? key, required this.navigateToHome}) : super(key: key);
  @override
  _ComposePostReplyPageState createState() => _ComposePostReplyPageState();
}

class _ComposePostReplyPageState extends State<ComposePost> {
  late PostModel? model;
  late ScrollController scrollcontroller;
  late TextEditingController _textEditingController;
  File? _file;
  @override
  void dispose() {
    scrollcontroller.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    scrollcontroller = ScrollController();
    _textEditingController = TextEditingController();
    super.initState();
  }

  void _onImageIconSelcted(File file) {
    setState(() {
      _file = file;
    });
  }

  void _submitButton() async {
    if (_textEditingController.text.length > 280) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        backgroundColor: Colors.white,
        content: Container(
            alignment: Alignment.center,
            height: 30,
            child: Text(
              "Max Description: 280",
              style: TextStyle(
                  fontFamily: "icons.ttf",
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w900),
            )),
      ));
      return;
    }
    if (_textEditingController.text.isEmpty) return;

    var state = Provider.of<PostState>(context, listen: false);

    PostModel postModel = await createPostModel();
    String? postId;

    if (_file != null) {
      await state.uploadFile(_file!).then((imagePath) async {
        if (imagePath != null) {
          postModel.imagePath = imagePath;
          postId = await state.createPost(postModel);
        }
      });
    } else {
      postId = await state.createPost(postModel);
    }

    postModel.key = postId;
    _textEditingController.clear();
    setState(() {
      _file = null;
    });
  }

  Widget _entry(
    BuildContext context,
    String title,
    Icon icon, {
    required TextEditingController controller,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              title,
              style: TextStyle(
                  fontFamily: "icons.ttf",
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ),
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                  width: MediaQuery.of(context).size.width / 1.12,
                  height: 30,
                  color: Colors.black,
                  child: TextField(
                    keyboardAppearance: Brightness.dark,
                    style: TextStyle(
                        fontFamily: "icons.ttf",
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                    controller: controller,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          fontFamily: "icons.ttf",
                          color: Color.fromARGB(255, 149, 149, 149),
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                      hintText: "Draw, Painting, 3D...",
                      prefixIcon: icon,
                      contentPadding: EdgeInsets.only(left: 10),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 0),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 0),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                  )))
        ],
      ),
    );
  }

  bool more = false;

  Future createPostModel() async {
    var authState = Provider.of<UserProvider>(context, listen: false);
    var myUser = authState.currentUser;
    var profilePic = myUser!.profileImageUrl ?? '';

    var postedUser = UserModel(
      username: myUser.username ?? myUser.email!.split('@')[0],
      profileImageUrl: profilePic,
      id: myUser.id,
    );
    PostModel reply = PostModel(
        user: postedUser,
        bio: _textEditingController.text,
        createdAt: DateTime.now().toUtc().toString(),
        key: myUser.id!);
    return reply;
  }

  bool select = false;
  int nums = 0;
  @override
  Widget build(BuildContext context) {
    // final searchState = Provider.of<SearchState>(context, listen: false);
    var authState = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 29, 29, 29),
        elevation: 0,
        title: Text(
          "New Threads",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            widget.navigateToHome();
          },
        ),
      ),
      body: Column(
        children: [
          Divider(
            color: const Color.fromARGB(
                255, 159, 155, 155), // Màu của đường gạch ngang
            thickness: 1, // Độ dày của đường gạch ngang
            height: 0.5, // Chiều cao của đường gạch ngang
          ),
          Expanded(
            child: Container(
              color: Color.fromARGB(255, 29, 29, 29),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      imageUrl: authState
                                              .currentUser?.profileImageUrl ??
                                          '',
                                      height: 50,
                                    )),
                                Container(
                                  height: 6,
                                ),
                                Container(
                                  height: 100,
                                  width: 2,
                                  color: const Color.fromARGB(255, 87, 87, 87),
                                ),
                                Container(
                                  height: 10,
                                ),
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                )
                              ],
                            ),
                            Container(
                              width: 15,
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authState.currentUser?.username ?? '',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    child: TextField(
                                      maxLength: 500,
                                      keyboardAppearance: MediaQuery.of(context)
                                                  .platformBrightness ==
                                              Brightness.dark
                                          ? Brightness.dark
                                          : Brightness.light,
                                      style: TextStyle(color: Colors.white),
                                      controller: _textEditingController,
                                      onChanged: (texts) {
                                        setState(() {
                                          nums = _textEditingController
                                              .text.length;
                                        });
                                      },
                                      maxLines: null,
                                      decoration: InputDecoration(
                                          suffix: Container(
                                            height: 80,
                                            width: 50,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                ComposeBottomIconWidget(
                                                  textEditingController:
                                                      _textEditingController,
                                                  onImageIconSelcted:
                                                      _onImageIconSelcted,
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      HapticFeedback
                                                          .heavyImpact();
                                                      _submitButton();
                                                      widget.navigateToHome();
                                                    },
                                                    child: Text(
                                                      "Post",
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ))
                                              ],
                                            ),
                                          ),
                                          border: InputBorder.none,
                                          hintText: "Start a threads..",
                                          hintStyle: TextStyle(
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 112, 112, 112),
                                              overflow: TextOverflow.ellipsis)),
                                    ),
                                  ),
                                ]),
                          ],
                        )),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.12,
                      height: MediaQuery.of(context).size.height / 2,
                      alignment: Alignment.center,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(2)),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
