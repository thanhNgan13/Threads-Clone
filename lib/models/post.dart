// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exercises/models/user.dart';
import 'package:flutter/src/widgets/basic.dart';

class PostModel {
  String? key;
  String? imagePath;
  String? bio;
  late String createdAt;
  UserModel? user;
  List<String?>? comment;

  PostModel({
    this.key,
    required this.createdAt,
    this.imagePath,
    this.bio,
    this.user,
  });

  toJson() {
    return {
      "createdAt": createdAt,
      "bio": bio,
      "imagePath": imagePath,
      "user": user == null ? null : user!.toJson(),
    };
  }

  PostModel.fromJson(Map<dynamic, dynamic> map) {
    key = map['key'];
    bio = map['bio'];
    createdAt = map['createdAt'];
    imagePath = map['imagePath'];
    user = UserModel.fromMap(map['user']);
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
    );
  }
}
