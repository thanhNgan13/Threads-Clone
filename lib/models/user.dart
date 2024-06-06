class UserModel {
  final String? id;
  final String? email;
  final String? name;
  final String? username;
  final String? profileImageUrl;
  final String? biography;
  final String? fcmToken;
  List? following;
  List? followers;

  UserModel({
    this.id,
    this.email,
    this.name,
    this.username,
    this.profileImageUrl,
    this.fcmToken,
    this.following,
    this.followers,
    this.biography,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'profileImageUrl': profileImageUrl,
      'email': email,
      'biography': biography,
      'fcmToken': fcmToken,
      'followers': followers,
      'following': following,
    };
  }

  UserModel.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        email = data['email'],
        name = data['name'],
        username = data['username'],
        profileImageUrl = data['profileImageUrl'],
        fcmToken = data['fcmToken'],
        following = data['following'],
        followers = data['followers'],
        biography =
            data['biography'] != null ? data['biography'] as String : null;
}
