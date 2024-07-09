import 'package:final_exercises/providers/UserProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exercises/models/user.dart';
import 'package:final_exercises/values/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
      });
    });
  }

  Future<void> followUser(String currentUserId, String userId) async {
    await _usersCollection.doc(currentUserId).update({
      'following': FieldValue.arrayUnion([userId])
    });

    await _usersCollection.doc(userId).update({
      'followers': FieldValue.arrayUnion([currentUserId])
    });
  }

  Future<void> unfollowUser(String currentUserId, String userId) async {
    await _usersCollection.doc(currentUserId).update({
      'following': FieldValue.arrayRemove([userId])
    });

    await _usersCollection.doc(userId).update({
      'followers': FieldValue.arrayRemove([currentUserId])
    });
  }

  List<UserModel> filteredUsers(List<UserModel> users, String searchQuery) {
    return users
        .where((user) =>
            user.username!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<UserProvider>(context);
    final currentUserId = authState.currentUser?.id;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Text('Search',
                  style: AppStyles.h4.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 26,
                    color: Colors.white,
                  )),
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    )),
              ),
              const SizedBox(height: 20),
              StreamBuilder(
                  stream: _usersCollection
                      .where('id', isNotEqualTo: currentUserId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final users = snapshot.data!.docs
                        .map((doc) => UserModel(
                              id: doc['id'],
                              name: doc['name'],
                              username: doc['username'],
                              profileImageUrl: doc['profileImageUrl'],
                              followers: doc['followers'],
                              following: doc['following'],
                            ))
                        .toList();
                    final _filteredUsers = filteredUsers(users, searchQuery);
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = _filteredUsers[index];
                          return SuggestedUserWidget(
                              user: user,
                              onFollow: () =>
                                  followUser(currentUserId!, user.id!),
                              onUnfollow: () =>
                                  unfollowUser(currentUserId!, user.id!),
                              currentUserId: currentUserId);
                        });
                  })
            ]),
          ),
        ),
      ),
    );
  }
}

class SuggestedUserWidget extends StatefulWidget {
  const SuggestedUserWidget(
      {super.key,
      required this.user,
      this.onFollow,
      this.onUnfollow,
      required this.currentUserId});
  final UserModel user;
  final VoidCallback? onFollow;
  final VoidCallback? onUnfollow;
  final String? currentUserId; // Nhận currentUserId

  @override
  State<SuggestedUserWidget> createState() => _SuggestedUserWidgetState();
}

class _SuggestedUserWidgetState extends State<SuggestedUserWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            color: const Color.fromARGB(255, 95, 91, 91),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(12.0), // Tạo viền bo tròn
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: Image.network(widget.user.profileImageUrl!).image,
          ),
          title: Text(widget.user.name!,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              )),
          subtitle: Text('@${widget.user.username}',
              style: TextStyle(color: Colors.grey)),
          trailing: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.currentUserId) // Sử dụng currentUserId từ widget
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data!.data() == null) {
                  return const SizedBox();
                }
                final currentUser = UserModel.fromMap(
                    snapshot.data!.data() as Map<String, dynamic>);
                final isFollowing =
                    currentUser.following!.contains(widget.user.id);
                return InkWell(
                  onTap: isFollowing ? widget.onUnfollow : widget.onFollow,
                  child: Container(
                    width: 110,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: isFollowing
                        ? Text(
                            'Unfollow',
                            style: AppStyles.h5.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          )
                        : Text(
                            'Follow',
                            style: AppStyles.h5.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
