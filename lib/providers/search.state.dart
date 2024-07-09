import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exercises/models/post.dart';
import 'package:final_exercises/models/user.dart';
import 'package:final_exercises/services/post_service.dart';
import 'app.state.dart';
import 'package:final_exercises/helper/enum.dart';

class SearchState extends AppStates {
  bool isBusy = false;
  SortUser sortBy = SortUser.MAX_FOLLOWER;
  List<UserModel>? _userFilterlist;
  List<UserModel>? _userlist;

  List<UserModel>? get userlist {
    return _userFilterlist != null ? List.from(_userFilterlist!) : null;
  }

  // Future<void> getDataFromFirestore() async {
  //   try {
  //     isBusy = true;
  //     notifyListeners();

  //     CollectionReference users =
  //         FirebaseFirestore.instance.collection('users');
  //     QuerySnapshot snapshot = await users.get();

  //     _userlist = snapshot.docs.map((doc) {
  //       return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  //     }).toList();

  //     _userFilterlist = List.from(_userlist!);
  //     isBusy = false;
  //     notifyListeners();
  //   } catch (error) {
  //     isBusy = false;
  //     print('Error getting user data: $error');
  //   }
  // }

  void filterByUsername(String? name) {
    if (name != null && name.isEmpty) {
      _userFilterlist = List.from(_userlist!);
    } else if (name != null) {
      _userFilterlist = _userlist!
          .where((x) =>
              x.username != null &&
              x.username!.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  String get selectedFilter {
    switch (sortBy) {
      case SortUser.ALPHABETICALY:
        _userFilterlist!.sort((x, y) => x.name!.compareTo(y.name!));
        return "ALPHABETICALY";

      case SortUser.MAX_FOLLOWER:
        _userFilterlist!
            .sort((x, y) => y.followers!.length.compareTo(x.followers!.length));
        return "Popular";

      case SortUser.NEWEST:
        _userFilterlist!.sort(
            (x, y) => DateTime.parse(y.id!).compareTo(DateTime.parse(x.id!)));
        return "NEWEST user";

      case SortUser.OLDEST:
        _userFilterlist!.sort(
            (x, y) => DateTime.parse(x.id!).compareTo(DateTime.parse(y.id!)));
        return "OLDEST user";

      case SortUser.VERIFIED:
        // Assuming you have a boolean field `isVerified` in your user model
        _userFilterlist!.sort((x, y) => y.email!.compareTo(x.email!));
        return "VERIFIED user";

      default:
        return "Unknown";
    }
  }

  List<UserModel> userList = [];
  List<UserModel> getUserDetail(List<String> userIds) {
    final list = _userlist!.where((x) => userIds.contains(x.id)).toList();
    return list;
  }

  List<InfoComment>? infoComments;

  // Future<void> getDataFromFirestore(String userId) async {
  //   isBusy = true;
  //   notifyListeners();

  //   try {
  //     infoComments = await getInfoCommentsByUserID(userId);
  //   } catch (e) {
  //     print('Failed to load comments: $e');
  //   }

  //   isBusy = false;
  //   notifyListeners();
  // }
}
