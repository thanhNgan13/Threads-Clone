import 'package:final_exercises/providers/UserProvider.dart';
import 'package:final_exercises/providers/post.state.dart';
import 'package:final_exercises/screens/notification/notipage.dart';
import 'package:flutter/material.dart';
import 'package:final_exercises/screens/composePost/newPost.dart';

import 'package:final_exercises/screens/homepage_widgets/search_widget.dart';
import 'package:final_exercises/screens/listPost/list_post_widget.dart';
import 'package:final_exercises/screens/profilepage/myprofile.dart';
import 'package:provider/provider.dart';
import '../component/BottomNavItem.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BodyWidget(),
    );
  }
}

class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  int _selectedIndex = 0;
  final int sizeIcon = 30;

  List<Widget> _tabs = [];

  @override
  void initState() {
    super.initState();
    _tabs = [
      const ListPostWidget(),
      const SearchWidget(),
      ComposePost(navigateToHome: _navigateToHome),
      InfoCommentsPage(),
      const MyProfilePage()
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToHome() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  final List<BottomNavItem> bottomNavItems = [
    BottomNavItem(
      icon: const Icon(
        Icons.home_outlined,
        size: 30,
      ),
    ),
    BottomNavItem(
        icon: const Icon(
      Icons.search_rounded,
      size: 30,
    )),
    BottomNavItem(icon: const Icon(Icons.edit_outlined, size: 30)),
    BottomNavItem(icon: const Icon(Icons.notifications_outlined, size: 30)),
    BottomNavItem(icon: const Icon(Icons.person_outline, size: 30))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _tabs,
      ),
      bottomNavigationBar: (_selectedIndex != 2)
          ? BottomNavigationBar(
              backgroundColor: Colors.black,
              fixedColor: Colors.white,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              unselectedFontSize: 10,
              selectedFontSize: 10,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: [
                for (var i = 0; i < bottomNavItems.length; i++)
                  BottomNavigationBarItem(
                    icon: bottomNavItems.elementAt(i).icon,
                    label: bottomNavItems.elementAt(i).label,
                  )
              ],
            )
          : null,
    );
  }
}
