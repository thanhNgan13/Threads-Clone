class UserModel {
  final String id;
  final String name;
  final String username;
  final String? profileImageUrl;
  final String? biography;
  final List following;
  final List followers;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    this.profileImageUrl,
    required this.following,
    required this.followers,
    this.biography,
  });
  // UserModel(
  //     {required this.id,
  //     required this.name,
  //     required this.username,
  //     this.profileImageUrl});

  UserModel.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        username = data['username'],
        profileImageUrl = data['profileImageUrl'],
        following = data['following'],
        followers = data['followers'],
        biography =
            data['biography'] != null ? data['biography'] as String : null;
}
