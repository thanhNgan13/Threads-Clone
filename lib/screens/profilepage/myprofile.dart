import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_exercises/models/post.dart';
import 'package:final_exercises/providers/UserProvider.dart';
import 'package:final_exercises/providers/post.state.dart';
import 'package:final_exercises/screens/listPost/feedpost.dart';
import 'package:final_exercises/screens/profilepage/edit.dart';
import 'package:final_exercises/screens/profilepage/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<MyProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<UserProvider>(context);
    var postState = Provider.of<PostState>(context);
    String userId = authState.currentUser?.id ?? "";

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
            child: Icon(CupertinoIcons.list_bullet_indent, color: Colors.white),
          )
        ],
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(CupertinoIcons.globe, color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authState.currentUser?.name ?? "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            height: 8,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfilePage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "@" + (authState.currentUser?.username ?? ""),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Container(
                                width: 5,
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                        width: 63,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            height: 60,
                            width: 60,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              height: 100,
                              imageUrl:
                                  authState.currentUser?.profileImageUrl ?? "",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(),
                            ),
                          );
                        },
                        child: Text(
                          authState.currentUser?.biography ?? "",
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(),
                            ),
                          );
                        },
                        child: Container(
                          height: 40,
                          width: 165,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Edit profile",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        width: 10,
                      ),
                      Container(
                        height: 40,
                        width: 165,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Share profile",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: TabBar(
                      onTap: (index) {},
                      controller: _tabController,
                      isScrollable: false,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.white,
                      indicatorWeight: 1,
                      tabs: [
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Tab(
                            child: Text(
                              'Threads',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 0),
                          child: Tab(
                            child: Text(
                              'Replies',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        StreamBuilder<List<PostModel>>(
                          stream: postState.getFeedListForUserStream(userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                  child: Text(
                                      "You haven't posted any threads yet."));
                            }
                            var posts = snapshot.data!;
                            return ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                final post = posts[index];
                                return FeedPost(
                                    postModel: post, currentUserId: userId);
                              },
                            );
                          },
                        ),
                        Center(
                          child: Text(
                            "This is the Replies tab.",
                            style: TextStyle(
                                color: Color.fromARGB(255, 84, 60, 60)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
