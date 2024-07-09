import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exercises/models/post.dart';
import 'package:final_exercises/models/user.dart';

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

Future<PostModel> getPost(String postID) async {
  DocumentSnapshot postSnapshot =
      await FirebaseFirestore.instance.collection('posts').doc(postID).get();

  if (!postSnapshot.exists) {
    throw Exception("Post document does not exist!");
  }

  return PostModel.fromDocument(postSnapshot);
}

Future<void> addComment(String postID) async {
  DocumentReference postRef =
      FirebaseFirestore.instance.collection('posts').doc(postID);

  // Kiểm tra xem các document có tồn tại hay không
  DocumentSnapshot postSnapshot = await postRef.get();

  if (!postSnapshot.exists) {
    throw Exception("Post document does not exist!");
  }

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    transaction.update(postRef, {
      'commentsCount': FieldValue.increment(1),
    });
  });
}

Future<void> addInfoComment(String postID, String postIDComment,
    String userIDComment, String content) async {
  DocumentReference postRef =
      FirebaseFirestore.instance.collection('posts').doc(postID);

  // Check if the post document exists
  DocumentSnapshot postSnapshot = await postRef.get();

  if (!postSnapshot.exists) {
    throw Exception("Post document does not exist!");
  }

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    transaction.update(postRef, {
      'commentsCount': FieldValue.increment(1),
      'infoComments': FieldValue.arrayUnion([
        {
          'postIDParent': postID,
          'postIDComment': postIDComment,
          'userIDComment': userIDComment,
          'content': content,
        }
      ])
    });
  });
}

// Future<void> addComment(String postID) async {
//   DocumentReference postRef =
//       FirebaseFirestore.instance.collection('posts').doc(postID);
//   // Kiểm tra xem post có tồn tại hay không
//   DocumentSnapshot postSnapshot = await postRef.get();
//   if (!postSnapshot.exists) {
//     throw Exception("Post document does not exist!");
//   }
//   // Lấy thông tin của post mới thêm vào
//   Map<String, dynamic>? postData = postSnapshot.data() as Map<String, dynamic>?;
//   String? parentPostID = postData?['keyReply'];
//   if (parentPostID != null) {
//     // Kiểm tra và cập nhật các post cha, ông...
//     await FirebaseFirestore.instance.runTransaction((transaction) async {
//       DocumentReference parentPostRef =
//           FirebaseFirestore.instance.collection('posts').doc(parentPostID);
//       while (parentPostID != null) {
//         DocumentSnapshot parentPostSnapshot =
//             await transaction.get(parentPostRef);
//         if (!parentPostSnapshot.exists) {
//           throw Exception("Parent post document does not exist!");
//         }
//         transaction.update(parentPostRef, {
//           'commentsCount': FieldValue.increment(1),
//         });
//         Map<String, dynamic>? parentPostData =
//             parentPostSnapshot.data() as Map<String, dynamic>?;
//         parentPostID = parentPostData?['keyReply'];
//         if (parentPostID != null) {
//           parentPostRef =
//               FirebaseFirestore.instance.collection('posts').doc(parentPostID);
//         }
//       }
//     });
//   } else {
//     // Nếu không có post cha, chỉ tăng commentsCount của post hiện tại
//     await FirebaseFirestore.instance.runTransaction((transaction) async {
//       transaction.update(postRef, {
//         'commentsCount': FieldValue.increment(1),
//       });
//     });
//   }
// }

Future<void> deletePost(String postId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference postRef = firestore.collection('posts').doc(postId);
  CollectionReference usersRef = firestore.collection('users');
  CollectionReference postsRef = firestore.collection('posts');

  try {
    await firestore.runTransaction((transaction) async {
      DocumentSnapshot postSnapshot = await transaction.get(postRef);
      if (!postSnapshot.exists) {
        throw Exception("Post does not exist!");
      }

      // Update users who liked this post, if any
      List<dynamic> likedUsers = postSnapshot.get('likedUsers') ?? [];
      for (String likedUserId in likedUsers) {
        DocumentReference likedUserRef = usersRef.doc(likedUserId);
        transaction.update(likedUserRef, {
          'likedPosts': FieldValue.arrayRemove([postId])
        });
      }

      // Decrement commentsCount and remove the specific infoComments entry in other posts
      QuerySnapshot querySnapshot =
          await postsRef.where('infoComments', isNotEqualTo: null).get();

      for (DocumentSnapshot doc in querySnapshot.docs) {
        List<dynamic> infoComments = doc.get('infoComments') ?? [];
        var updatedInfoComments = List.from(infoComments);
        bool commentRemoved = updatedInfoComments
            .remove((infoComment) => infoComment['postIDComment'] == postId);

        if (commentRemoved) {
          transaction.update(doc.reference, {
            'commentsCount': FieldValue.increment(-1),
            'infoComments': updatedInfoComments,
          });
        }
      }

      // Finally, delete the post itself
      transaction.delete(postRef);
    });
  } catch (error) {
    print('Failed to delete post and associated data: $error');
    throw Exception('Failed to delete post');
  }
}

Future<void> updatePostBio(String postId, String newBio) async {
  DocumentReference postRef =
      FirebaseFirestore.instance.collection('posts').doc(postId);

  try {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot postSnapshot = await transaction.get(postRef);

      if (!postSnapshot.exists) {
        throw Exception("Post document does not exist!");
      }

      transaction.update(postRef, {
        'bio': newBio,
      });
    });
  } catch (error) {
    print('Failed to update post bio: $error');
    throw Exception('Failed to update post bio');
  }
}

final CollectionReference postsCollection =
    FirebaseFirestore.instance.collection('posts');

// Function to update user.name for all posts by a specific user
Future<void> updateUserNameForUserPosts(
    String userId, String newUserName) async {
  try {
    QuerySnapshot querySnapshot =
        await postsCollection.where('user.id', isEqualTo: userId).get();

    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (var doc in querySnapshot.docs) {
      batch.update(doc.reference, {'user.name': newUserName});
    }

    await batch.commit();
    print('User name updated successfully for all posts.');
  } catch (error) {
    print('Failed to update user name: $error');
    throw Exception('Failed to update user name');
  }
}

Stream<int> getPostLikesCount(String postId) {
  DocumentReference<Map<String, dynamic>> postRef =
      FirebaseFirestore.instance.collection('posts').doc(postId);
  return postRef.snapshots().map((snapshot) {
    if (snapshot.exists) {
      return snapshot.data()?['likes'] ?? 0;
    } else {
      return 0;
    }
  });
}

Stream<int> getPostCommentsCount(String postId) {
  DocumentReference postRef =
      FirebaseFirestore.instance.collection('posts').doc(postId);
  return postRef.snapshots().map((snapshot) {
    if (snapshot.exists) {
      return snapshot.get('commentsCount') ?? 0;
    } else {
      return 0;
    }
  });
}

// Add this function to get the real-time like status of the current user
Stream<bool> hasCurrentUserLikedPost(String postId, String currentUserId) {
  DocumentReference<Map<String, dynamic>> postRef =
      FirebaseFirestore.instance.collection('posts').doc(postId);
  return postRef.snapshots().map((snapshot) {
    if (snapshot.exists) {
      List<dynamic> likedUsers = snapshot.data()?['likedUsers'] ?? [];
      return likedUsers.contains(currentUserId);
    } else {
      return false;
    }
  });
}

final CollectionReference users =
    FirebaseFirestore.instance.collection('users');
Stream<UserModel> getInfo(String userId) {
  return users.doc(userId).snapshots().map((snapshot) {
    if (snapshot.exists) {
      return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    } else {
      throw Exception('User not found');
    }
  });
}

Future<List<PostModel>> queryPostsByCommentID(String postIDComment) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference postsRef = firestore.collection('posts');

  try {
    // Truy vấn sơ bộ: Lấy tất cả các bài viết có chứa infoComments
    QuerySnapshot querySnapshot =
        await postsRef.where('infoComments', isNotEqualTo: null).get();

    // Lọc kết quả: Giữ lại các bài viết có infoComments.postIDComment bằng với giá trị cần tìm
    List<PostModel> filteredPosts = querySnapshot.docs
        .map((doc) {
          PostModel post = PostModel.fromDocument(doc);
          post.infoComments = (post.infoComments ?? []).where((infoComment) {
            return infoComment.postIDComment == postIDComment;
          }).toList();

          return post;
        })
        .where((post) => post.infoComments!.isNotEmpty)
        .toList();

    // Giảm commentsCount, cập nhật Firestore và xóa bài viết nếu có key = postIDComment
    for (PostModel post in filteredPosts) {
      DocumentReference postRef = postsRef.doc(post.key);

      await firestore.runTransaction((transaction) async {
        DocumentSnapshot postSnapshot = await transaction.get(postRef);

        if (postSnapshot.exists) {
          List<dynamic> infoComments = postSnapshot.get('infoComments') ?? [];
          var updatedInfoComments = List.from(infoComments);
          updatedInfoComments.removeWhere(
              (infoComment) => infoComment['postIDComment'] == postIDComment);

          transaction.update(postRef, {
            'commentsCount': FieldValue.increment(-1),
            'infoComments': updatedInfoComments,
          });
        }
      });
    }

    // Xóa bài viết có key = postIDComment
    QuerySnapshot postToDeleteSnapshot = await postsRef
        .where(FieldPath.documentId, isEqualTo: postIDComment)
        .get();
    for (DocumentSnapshot doc in postToDeleteSnapshot.docs) {
      await firestore.runTransaction((transaction) async {
        transaction.delete(doc.reference);
      });
    }

    return filteredPosts;
  } catch (error) {
    print('Failed to query posts: $error');
    throw Exception('Failed to query posts');
  }
}

Stream<List<InfoComment>> getInfoCommentsByUserID(String userId) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference postsRef = firestore.collection('posts');

  return postsRef
      .where('user.id', isEqualTo: userId)
      .snapshots()
      .map((querySnapshot) {
    List<InfoComment> userInfoComments = [];

    for (var doc in querySnapshot.docs) {
      List<dynamic> infoCommentsData = doc.get('infoComments') ?? [];
      for (var infoCommentData in infoCommentsData) {
        InfoComment infoComment = InfoComment.fromJson(infoCommentData);
        if (infoComment.userIDComment != userId) {
          userInfoComments.add(infoComment);
        }
      }
    }

    return userInfoComments;
  });
}

Stream<PostModel> streamGetPostByID(String postID) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference postRef = firestore.collection('posts').doc(postID);

  return postRef.snapshots().map((snapshot) {
    if (snapshot.exists) {
      return PostModel.fromDocument(snapshot);
    } else {
      throw Exception('Post not found');
    }
  });
}

Stream<List<String>> getLikedUsersByUserID(String userId) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference postsRef = firestore.collection('posts');

  return postsRef
      .where('user.id', isEqualTo: userId)
      .snapshots()
      .map((querySnapshot) {
    Set<String> likedUserIds = {};

    for (var doc in querySnapshot.docs) {
      List<dynamic> likedUsers = doc.get('likedUsers') ?? [];
      likedUserIds.addAll(likedUsers.cast<String>());
    }

    return likedUserIds.toList();
  });
}
