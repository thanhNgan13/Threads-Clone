import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exercises/models/user.dart';

class UserService {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(UserModel userModel) async {
    try {
      await users.doc(userModel.id).set({
        'id': userModel.id,
        'name': userModel.name,
        'username': userModel.username,
        'email': userModel.email,
        'followers': <String>[],
        'following': <String>[],
        'profileImageUrl': userModel.profileImageUrl,
        'biography': '',
      });
    } catch (e) {
      print('Error adding user to FireStore: $e');
    }
  }

  Future<UserModel?> getUserByUid(String uid) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
