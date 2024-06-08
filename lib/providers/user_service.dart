import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exercises/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  Future<void> updateUserProfile(UserModel userModel, {File? image}) async {
    try {
      // If there is an image, handle image upload to a storage service (e.g., Firebase Storage)
      String? imageUrl;
      if (image != null) {
        imageUrl = await uploadImage(userModel.id!, image);
      }

      // Update user document in Firestore
      await users.doc(userModel.id).update({
        'name': userModel.name,
        'username': userModel.username,
        'profileImageUrl': imageUrl ?? userModel.profileImageUrl,
        'biography': userModel.biography,
      });
    } catch (e) {
      print('Error updating user in FireStore: $e');
    }
  }

  Future<String> uploadImage(String userId, File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profileImageUrl')
          .child(userId);
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }
}
