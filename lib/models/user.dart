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


  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? username,
    String? profileImageUrl,
    String? biography,
    String? fcmToken,
    List? following,
    List? followers,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      biography: biography ?? this.biography,
      fcmToken: fcmToken ?? this.fcmToken,
      following: following ?? this.following,
      followers: followers ?? this.followers,
    );
  }
  
}
