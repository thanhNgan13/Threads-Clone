// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
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
  String? keyReply;

  PostModel({
    this.key,
    required this.createdAt,
    this.imagePath,
    this.bio,
    this.user,
    this.likes = 0,
    this.likedUsers,
    this.commentsCount = 0,
    this.keyReply,
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
      "keyReply": keyReply,
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
    keyReply = map['keyReply'];
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
      keyReply: data['keyReply'],
    );
  }
}
