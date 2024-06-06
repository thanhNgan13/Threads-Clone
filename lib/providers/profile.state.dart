import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exercises/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ProfileState extends ChangeNotifier {
  ProfileState(this.profileId) {
    userId = FirebaseAuth.instance.currentUser!.uid;
    _getLoggedInUserProfile(userId);
    _getProfileUser(profileId);
  }

  late String userId;
  final String profileId;

  late UserModel _userModel;
  UserModel get userModel => _userModel;

  late UserModel _profileUserModel;
  UserModel get profileUserModel => _profileUserModel;

  bool _isBusy = true;
  bool get isBusy => _isBusy;
  set loading(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  bool get isMyProfile => profileId == userId;

  void _getLoggedInUserProfile(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        _userModel = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        notifyListeners();
      }
    } catch (error) {
      print('Error getting logged in user profile: $error');
    }
  }

  void _getProfileUser(String userProfileId) async {
    try {
      loading = true;
      DocumentSnapshot profileDoc = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(userProfileId)
          .get();
      if (profileDoc.exists) {
        _profileUserModel =
            UserModel.fromMap(profileDoc.data() as Map<String, dynamic>);
      }
      loading = false;
      notifyListeners();
    } catch (error) {
      loading = false;
      print('Error getting profile user: $error');
    }
  }

  void followUser({bool removeFollower = false}) async {
    try {
      if (removeFollower) {
        profileUserModel.followers!.remove(userModel.id);
        userModel.following!.remove(profileUserModel.id);
      } else {
        profileUserModel.followers ??= [];
        profileUserModel.followers!.add(userModel.id!);
        userModel.following ??= [];
        addFollowNotification();
        userModel.following!.add(profileUserModel.id!);
      }

      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(profileUserModel.id)
          .update({'followers': profileUserModel.followers});

      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(userModel.id)
          .update({'following': userModel.following});

      notifyListeners();
    } catch (error) {
      print('Error following/unfollowing user: $error');
    }
  }

  void addFollowNotification() async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(profileId)
          .collection('userNotifications')
          .doc(userId)
          .set({
        'type': 'Follow',
        'createdAt': DateTime.now().toUtc().toString(),
        'data': userModel.toJson(),
      });
    } catch (error) {
      print('Error adding follow notification: $error');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
