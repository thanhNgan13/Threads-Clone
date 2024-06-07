import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exercises/models/comment.dart';
import 'package:final_exercises/models/post.dart';

Future<void> likePost(PostModel post, String userId) async {
  DocumentReference postRef =
      FirebaseFirestore.instance.collection('posts').doc(post.key);
  DocumentReference userRef =
      FirebaseFirestore.instance.collection('users').doc(userId);

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    transaction.update(postRef, {
      'likes': FieldValue.increment(1),
      'likedUsers': FieldValue.arrayUnion([userId]),
    });

    transaction.update(userRef, {
      'likedPosts': FieldValue.arrayUnion([post.key]),
    });
  });
}

Future<void> unlikePost(PostModel post, String userId) async {
  DocumentReference postRef =
      FirebaseFirestore.instance.collection('posts').doc(post.key);
  DocumentReference userRef =
      FirebaseFirestore.instance.collection('users').doc(userId);

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    transaction.update(postRef, {
      'likes': FieldValue.increment(-1),
      'likedUsers': FieldValue.arrayRemove([userId]),
    });

    transaction.update(userRef, {
      'likedPosts': FieldValue.arrayRemove([post.key]),
    });
  });
}

Future<void> addComment(String postID, String userId, String comment) async {
  DocumentReference postRef =
      FirebaseFirestore.instance.collection('posts').doc(postID);

  DocumentReference userRef =
      FirebaseFirestore.instance.collection('users').doc(userId);

  // Kiểm tra xem các document có tồn tại hay không
  DocumentSnapshot postSnapshot = await postRef.get();
  DocumentSnapshot userSnapshot = await userRef.get();

  if (!postSnapshot.exists) {
    throw Exception("Post document does not exist!");
  }

  if (!userSnapshot.exists) {
    throw Exception("User document does not exist!");
  }

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    transaction.update(postRef, {
      'commentsCount': FieldValue.increment(1),
      'comments': FieldValue.arrayUnion([
        {
          'comment': comment,
          'userId': userId,
          'createdAt': DateTime.now().toIso8601String(),
        }
      ]),
    });

    transaction.update(userRef, {
      'comments': FieldValue.arrayUnion([postID]),
    });
  });
}

Future<List<CommentModel>> getAllComments(String postId) async {
  DocumentReference postRef =
      FirebaseFirestore.instance.collection('posts').doc(postId);

  DocumentSnapshot postSnapshot = await postRef.get();

  if (!postSnapshot.exists) {
    throw Exception("Post document does not exist!");
  }

  List<dynamic> commentsData = postSnapshot.get('comments') ?? [];

  List<CommentModel> comments = commentsData.map((data) {
    return CommentModel.fromJson(data as Map<String, dynamic>);
  }).toList();

  return comments;
}
