// ignore_for_file: avoid_print

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
      "user": user,
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
}
