// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exercises/models/comment.dart';
import 'package:final_exercises/models/user.dart';
import 'package:flutter/src/widgets/basic.dart';

class PostModel {
  String? key;
  late String createdAt;
  String? imagePath;
  String? bio;
  UserModel? user;

  int? likes;
  List<String?>? likedUsers;
  int? commentsCount;
  List<CommentModel?>? comments;

  PostModel({
    this.key,
    required this.createdAt,
    this.imagePath,
    this.bio,
    this.user,
    this.likes = 0,
    this.likedUsers,
    this.commentsCount = 0,
    this.comments,
  });

  toJson() {
    return {
      "createdAt": createdAt,
      "bio": bio,
      "imagePath": imagePath,
      "user": user == null ? null : user!.toJson(),
      "likes": likes,
      "likedUsers": likedUsers,
      "commentsCount": commentsCount,
      "comments": comments == null
          ? null
          : comments!.map((comment) => comment!.toJson()).toList(),
    };
  }

  PostModel.fromJson(Map<dynamic, dynamic> map) {
    key = map['key'];
    bio = map['bio'];
    createdAt = map['createdAt'];
    imagePath = map['imagePath'];
    user = UserModel.fromMap(map['user']);
    likes = map['likes'];
    likedUsers = List<String>.from(map['likedUsers'] ??
        []); // Khởi tạo danh sách người dùng đã like từ map hoặc mặc định là rỗng
    commentsCount = map['commentsCount'];
    comments = (map['comments'] as List<dynamic>?)
            ?.map((comment) => CommentModel.fromJson(comment))
            .toList() ??
        [];
  }

  map(Stack Function(dynamic model) param0) {}

  factory PostModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PostModel(
      key: doc.id,
      bio: data['bio'],
      createdAt: data['createdAt'],
      imagePath: data['imagePath'],
      user: data['user'] != null ? UserModel.fromMap(data['user']) : null,
      likes: data['likes'],
      likedUsers: data['likedUsers'] != null
          ? List<String>.from(data['likedUsers'])
          : [],
      commentsCount: data['commentsCount'],
      comments: (data['comments'] as List<dynamic>?)
              ?.map((comment) => CommentModel.fromJson(comment))
              .toList() ??
          [],
    );
  }
  Future<void> addComment(String postId, String userId, String comment) async {
    comments = comments ?? [];
    comments!.add(CommentModel(
      userId: userId,
      comment: comment,
      createdAt: DateTime.now().toIso8601String(),
    ));
    commentsCount = commentsCount! + 1;
    await FirebaseFirestore.instance.collection('posts').doc(postId).update({
      "comments": comments!.map((comment) => comment?.toJson()).toList(),
      "commentCount": commentsCount,
    });
  }

  Future<void> addReply(
      String postId, String commentId, String userId, String reply) async {
    comments = comments ?? [];
    CommentModel? parentComment = findCommentById(commentId);
    if (parentComment != null) {
      parentComment.replies?.add(CommentModel(
        userId: userId,
        comment: reply,
        createdAt: DateTime.now().toIso8601String(),
      ));
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        "comments": comments!.map((comment) => comment?.toJson()).toList(),
      });
    }
  }

  CommentModel? findCommentById(String commentId) {
    for (var comment in comments!) {
      if (comment != null && comment.userId == commentId) {
        return comment;
      }
      if (comment != null && comment.replies != null) {
        for (var reply in comment.replies!) {
          if (reply != null && reply.userId == commentId) {
            return reply;
          }
        }
      }
    }
    return null;
  }
}
