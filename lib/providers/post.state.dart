import 'dart:async';
import 'dart:io';
import 'package:final_exercises/helper/utility.dart';
import 'package:final_exercises/models/post.dart';
import 'package:final_exercises/models/user.dart';
import 'package:final_exercises/providers/app.state.dart';
import 'package:firebase_database/firebase_database.dart' as dabase;
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;

class PostState extends AppStates {
  bool isBusy = false;
  Map<String, List<PostModel>?> postReplyMap = {};
  PostModel? _postToReplyModel;
  PostModel? get postToReplyModel => _postToReplyModel;
  set setPostToReply(PostModel model) {
    _postToReplyModel = model;
  }

  List<PostModel>? _feedlist;
  dabase.Query? _feedQuery;
  List<PostModel>? _postDetailModelList;

  List<PostModel>? get postDetailModel => _postDetailModelList;

  List<PostModel>? get feedlist {
    if (_feedlist == null) {
      return null;
    } else {
      return List.from(_feedlist!.reversed);
    }
  }

  Future<String?> createPost(PostModel model) async {
    isBusy = true;
    notifyListeners();
    String? postKey;
    try {
      // Tham chiếu đến bộ sưu tập 'posts' trong Firestore
      CollectionReference posts =
          FirebaseFirestore.instance.collection('posts');

      // Thêm bài đăng mới vào Firestore và lấy tài liệu tham chiếu
      DocumentReference docRef = await posts.add(model.toJson());

      // Lấy ID tài liệu duy nhất từ Firestore
      postKey = docRef.id;

      // Cập nhật key cho PostModel
      await docRef.update({'key': postKey});
    } catch (error) {
      print('Error creating post: $error');
    }
    isBusy = false;
    notifyListeners();
    return postKey;
  }

  // List<PostModel>? getPostListByFollower(UserModel? userModel) {
  //   if (userModel == null) {
  //     return null;
  //   }
  //   List<PostModel>? list;
  //   if (!isBusy && feedlist != null && feedlist!.isNotEmpty) {
  //     list = feedlist!.where((x) {
  //       if ((x.user!. == userModel.userId ||
  //           (userModel.followingList != null &&
  //               userModel.followingList!.contains(x.user!.userId)))) {
  //         return true;
  //       } else {
  //         return false;
  //       }
  //     }).toList();
  //     if (list.isEmpty) {
  //       list = null;
  //     }
  //   }
  //   return list;
  // }

  List<PostModel>? getPostList(UserModel? userModel) {
    if (userModel == null) {
      return null;
    }

    List<PostModel>? list;

    if (!isBusy && feedlist != null && feedlist!.isNotEmpty) {
      list = feedlist!.where((x) {
        return true;
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  set setFeedModel(PostModel model) {
    _postDetailModelList ??= [];

    _postDetailModelList!.add(model);
    notifyListeners();
  }

  Future<bool> databaseInit() {
    try {
      if (_feedQuery == null) {
        _feedQuery = kDatabase.child("post");
        _feedQuery!.onChildAdded.listen(onPostAdded);
      }
      return Future.value(true);
    } catch (error) {
      return Future.value(false);
    }
  }

  void getDataFromDatabase() {
    try {
      isBusy = true;
      _feedlist = null;
      notifyListeners();
      kDatabase.child('post').once().then((DatabaseEvent event) {
        final snapshot = event.snapshot;
        _feedlist = <PostModel>[];
        if (snapshot.value != null) {
          var map = snapshot.value as Map<dynamic, dynamic>?;
          if (map != null) {
            map.forEach((key, value) {
              var model = PostModel.fromJson(value);
              model.key = key;
              _feedlist!.add(model);
            });
            _feedlist!.sort((x, y) => DateTime.parse(x.createdAt)
                .compareTo(DateTime.parse(y.createdAt)));
          }
        } else {
          _feedlist = null;
        }
        isBusy = false;
        notifyListeners();
      });
    } catch (error) {
      isBusy = false;
    }
  }

  onPostAdded(DatabaseEvent event) {
    PostModel post = PostModel.fromJson(event.snapshot.value as Map);
    post.key = event.snapshot.key!;

    post.key = event.snapshot.key!;
    _feedlist ??= <PostModel>[];
    if ((_feedlist!.isEmpty || _feedlist!.any((x) => x.key != post.key))) {
      _feedlist!.add(post);
    }
    isBusy = false;
    notifyListeners();
  }
}
