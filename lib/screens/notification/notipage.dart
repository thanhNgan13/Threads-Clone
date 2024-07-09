import 'package:final_exercises/models/post.dart';
import 'package:final_exercises/models/user.dart';
import 'package:final_exercises/screens/notification/itemNotifi.dart';
import 'package:final_exercises/values/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_exercises/providers/UserProvider.dart';
import 'package:final_exercises/services/post_service.dart';

class InfoCommentsPage extends StatelessWidget {
  const InfoCommentsPage({Key? key}) : super(key: key);

  Widget upButton(String text) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.only(right: 10),
        child: Container(
          height: 35,
          width: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 17, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId =
        Provider.of<UserProvider>(context, listen: false).currentUser?.id;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Activity',
          style: AppStyles.h4.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 26,
            color: Colors.white,
          ),
        ),
      ),
      body: userId == null
          ? Center(child: Text('User ID not found'))
          : Column(
              children: [
                SizedBox(height: 20),
                SizedBox(
                  height: 30,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      SizedBox(width: 20),
                      upButton("All"),
                      upButton("Replies"),
                      upButton("Mentions"),
                      upButton("Verify"),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Comments',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: StreamBuilder<List<InfoComment>>(
                            stream: getInfoCommentsByUserID(userId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                print(snapshot.error);
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Center(
                                    child: Text('No comments found.',
                                        style: TextStyle(color: Colors.white)));
                              }

                              final comments = snapshot.data!.reversed
                                  .toList(); // Đảo ngược danh sách

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: comments.length,
                                itemBuilder: (context, index) {
                                  final comment = comments[index];
                                  return FutureBuilder<List<PostModel>>(
                                    future: Future.wait([
                                      streamGetPostByID(comment.postIDComment)
                                          .first,
                                      streamGetPostByID(comment.postIDParent)
                                          .first,
                                    ]),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return SizedBox.shrink();
                                      }
                                      if (snapshot.hasError) {
                                        print(snapshot.error);
                                        return Text('Error: ${snapshot.error}');
                                      }
                                      if (!snapshot.hasData) {
                                        return Text('No post found.');
                                      }

                                      final postModels = snapshot.data!;
                                      final postModelComment = postModels[0];
                                      final postModelParent = postModels[1];

                                      return ItemNotification(
                                        postModel: postModelComment,
                                        postModelParent: postModelParent,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Likes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        StreamBuilder<List<String>>(
                          stream: getLikedUsersByUserID(userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              print(snapshot.error);
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                  child: Text('No likes found.',
                                      style: TextStyle(color: Colors.white)));
                            }

                            final likedUserIds = snapshot.data!.reversed
                                .toList(); // Đảo ngược danh sách

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: likedUserIds.length,
                              itemBuilder: (context, index) {
                                final likedUserId = likedUserIds[index];
                                return StreamBuilder<UserModel>(
                                  stream: getInfo(likedUserId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return SizedBox.shrink();
                                    }
                                    if (snapshot.hasError) {
                                      print(snapshot.error);
                                      return Text('Error: ${snapshot.error}');
                                    }
                                    if (!snapshot.hasData) {
                                      return Text('No user found.');
                                    }

                                    final userModel = snapshot.data!;

                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            userModel.profileImageUrl ?? ''),
                                      ),
                                      title: Text(userModel.username!,
                                          style:
                                              TextStyle(color: Colors.white)),
                                      subtitle: Text(userModel.biography ?? '',
                                          style: TextStyle(color: Colors.grey)),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
