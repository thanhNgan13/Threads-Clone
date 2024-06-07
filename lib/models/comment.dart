class CommentModel {
  String? userId;
  String? comment;
  String? createdAt;
  List<CommentModel>? replies; // Danh sách các phản hồi

  CommentModel({
    this.userId,
    this.comment,
    this.createdAt,
    this.replies = const [], // Khởi tạo danh sách phản hồi rỗng
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'comment': comment,
      'createdAt': createdAt,
      'replies': replies?.map((reply) => reply.toJson()).toList(),
    };
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      userId: json['userId'],
      comment: json['comment'],
      createdAt: json['createdAt'],
      replies: (json['replies'] as List<dynamic>?)
              ?.map((replyJson) => CommentModel.fromJson(replyJson))
              .toList() ??
          [],
    );
  }
}
