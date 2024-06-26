import 'dart:io';

import 'package:final_exercises/models/user.dart';
import 'package:final_exercises/services/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? user;
  late String userId;
  UserCredential? _userCredential;
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  final UserService _userService = UserService();

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  set isLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserProvider() {
    checkCurrentUser();
  }

  Future<void> fetchCurrentUser() async {
    if (user != null) {
      _currentUser = await _userService.getUserByUid(user!.uid);
      notifyListeners();
    }
  }

  Future<void> updateUserProfile(UserModel user, {File? image}) async {
    // Update user profile in Firestore and handle image upload if needed
    await _userService.updateUserProfile(user, image: image);
    await _userService.updateUserPostsImagePath(user, image: image);
    _currentUser = user;
    notifyListeners();
  }

  Future<void> checkCurrentUser() async {
    // Kiểm tra nếu người dùng hiện tại đã đăng nhập qua Firebase
    user = _auth.currentUser;
    if (user != null) {
      // Nếu có, cập nhật trạng thái và thông tin người dùng
      _currentUser = await _userService.getUserByUid(user!.uid);
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
      _currentUser = null;
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _userCredential = null;
    _isLoggedIn = false;
    _currentUser = null; // Xóa thông tin người dùng

    clearErrorMessage(); // Clear any error messages
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String pass) async {
    try {
      _userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      _currentUser =
          await _userService.getUserByUid(_userCredential!.user!.uid);
      userId = _userCredential!.user!.uid;
      _isLoggedIn = true;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
    }
    notifyListeners();
  }

  Future<void> signUpWithEmail(
      String email, String pass, String name, String userName) async {
    try {
      _userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      _currentUser = UserModel(
          id: _userCredential!.user!.uid,
          email: email,
          name: name,
          username: userName,
          profileImageUrl: 'https://www.w3schools.com/w3images/avatar2.png');
      userId = _userCredential!.user!.uid;
      _isLoggedIn = true;
      // Lưu dữ liệu người dùng vào Firestore
      await _userService.addUser(_currentUser!);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
    }
    notifyListeners();
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      List<String> signInMethods =
          await _auth.fetchSignInMethodsForEmail(email);
      return signInMethods.isNotEmpty;
    } catch (e) {
      print('Error checking email existence: $e');
      return false;
    }
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }

  void logout() {
    signOut();
  }
}
