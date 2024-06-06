class UserModel {
  final String? id;
  final String? name;
  final String? username;
  final String? profileImageUrl;
  final String? biography;
  final List? following;
  final List? followers;

  UserModel({
    this.id,
    this.name,
    this.username,
    this.profileImageUrl,
    this.following,
    this.followers,
    this.biography,
  });

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
