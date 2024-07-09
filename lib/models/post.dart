import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exercises/models/user.dart';

class InfoComment {
  String postIDParent;
  String postIDComment;
  String userIDComment;
  String content;

  InfoComment({
    required this.postIDParent,
    required this.postIDComment,
    required this.userIDComment,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'postIDParent': postIDParent,
      'postIDComment': postIDComment,
      'userIDComment': userIDComment,
      'content': content,
    };
  }

  factory InfoComment.fromJson(Map<String, dynamic> map) {
    return InfoComment(
      postIDParent: map['postIDParent'],
      postIDComment: map['postIDComment'],
      userIDComment: map['userIDComment'],
      content: map['content'],
    );
  }
}

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
  List<InfoComment>? infoComments;

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
    this.infoComments,
  });

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'bio': bio,
      'imagePath': imagePath,
      'user': user?.toJson(),
      'likes': likes,
      'likedUsers': likedUsers,
      'commentsCount': commentsCount,
      'keyReply': keyReply,
      'infoComments':
          infoComments?.map((infoComment) => infoComment.toJson()).toList(),
    };
  }

  PostModel.fromJson(Map<dynamic, dynamic> map) {
    key = map['key'];
    bio = map['bio'];
    createdAt = map['createdAt'];
    imagePath = map['imagePath'];
    user = UserModel.fromMap(map['user']);
    likes = map['likes'];
    likedUsers = List<String>.from(map['likedUsers'] ?? []);
    commentsCount = map['commentsCount'];
    keyReply = map['keyReply'];
    infoComments = (map['infoComments'] as List<dynamic>?)
        ?.map((infoCommentMap) => InfoComment.fromJson(infoCommentMap))
        .toList();
  }

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
      infoComments: (data['infoComments'] as List<dynamic>?)
          ?.map((infoCommentMap) => InfoComment.fromJson(infoCommentMap))
          .toList(),
    );
  }
}
