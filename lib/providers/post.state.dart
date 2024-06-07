import 'dart:async';
import 'dart:io';
import 'package:final_exercises/models/post.dart';
import 'package:final_exercises/models/user.dart';
import 'package:final_exercises/providers/app.state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class PostState extends AppStates {
  bool isBusy = false;
  Map<String, List<PostModel>?> postReplyMap = {};
  PostModel? _postToReplyModel;
  PostModel? get postToReplyModel => _postToReplyModel;
  set setPostToReply(PostModel model) {
    _postToReplyModel = model;
  }

  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  // Real-time stream for all posts
  Stream<List<PostModel>> get feedStream {
    return postsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map((doc) => PostModel.fromDocument(doc)).toList();
      },
    );
  }

  // Real-time stream for posts by a specific user
  Stream<List<PostModel>> getFeedListForUserStream(String userId) {
    return postsCollection.where('user.id', isEqualTo: userId).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) => PostModel.fromDocument(doc)).toList();
      },
    );
  }

  Future<String?> createPost(PostModel model) async {
    isBusy = true;
    notifyListeners();
    String? postKey;
    try {
      DocumentReference docRef = await postsCollection.add(model.toJson());
      postKey = docRef.id;
      await docRef.update({'key': postKey});
    } catch (error) {
      print('Error creating post: $error');
    }
    isBusy = false;
    notifyListeners();
    return postKey;
  }

  Future<String?> uploadFile(File file) async {
    try {
      isBusy = true;
      notifyListeners();
      var storageReference = FirebaseStorage.instance
          .ref()
          .child("threadsImage")
          .child(path
              .basename('${DateTime.now().toIso8601String()}_${file.path}'));

      UploadTask uploadTask = storageReference.putFile(file);
      await uploadTask;
      String downloadUrl = await storageReference.getDownloadURL();

      return downloadUrl;
    } catch (error) {
      print('Error uploading file: $error');
      return null;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  // Sets the model for a detailed post view
  set setFeedModel(PostModel model) {
    _postDetailModelList ??= [];
    _postDetailModelList!.add(model);
    notifyListeners();
  }

  List<PostModel>? _postDetailModelList;

  // Getter for the post details model list
  List<PostModel>? get postDetailModel => _postDetailModelList;

  void deleteOldPosts() async {
    final int daysThreshold = 30; // Number of days after which to delete a post
    try {
      isBusy = true;
      notifyListeners();
      var cutoffDate = DateTime.now().subtract(Duration(days: daysThreshold));
      var oldPosts = await postsCollection
          .where('createdAt', isLessThanOrEqualTo: cutoffDate)
          .get();

      for (var doc in oldPosts.docs) {
        await deletePost(doc
            .id); // Assuming deletePost method handles both Firestore and any linked storage
      }
    } catch (error) {
      print('Error deleting old posts: $error');
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await postsCollection.doc(postId).delete();
      // Optionally, delete associated resources like images from Firebase Storage if needed
    } catch (error) {
      print('Error deleting post: $error');
    }
  }
}
