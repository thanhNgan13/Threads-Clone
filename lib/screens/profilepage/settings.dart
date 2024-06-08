import 'package:final_exercises/providers/UserProvider.dart';
import 'package:final_exercises/screens/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: Text(
            "Settings",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: ListView(
              children: [
                Container(
                  height: 0.5,
                  color: Color.fromARGB(255, 77, 77, 77),
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                    ),
                    Icon(
                      CupertinoIcons.person_add,
                      size: 30,
                      color: Colors.white,
                    ),
                    Container(
                      width: 20,
                    ),
                    Text(
                      "Follow and invite friends",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                  ],
                ),
                Container(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                    ),
                    Icon(
                      CupertinoIcons.bell,
                      size: 30,
                      color: Colors.white,
                    ),
                    Container(
                      width: 20,
                    ),
                    Text(
                      "Notifications",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                  ],
                ),
                Container(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                    ),
                    Icon(
                      Icons.lock_outline,
                      size: 30,
                      color: Colors.white,
                    ),
                    Container(
                      width: 20,
                    ),
                    Text(
                      "Privacy",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                  ],
                ),
                Container(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                    ),
                    Icon(
                      Icons.help_outline,
                      size: 30,
                      color: Colors.white,
                    ),
                    Container(
                      width: 20,
                    ),
                    Text(
                      "Help",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                  ],
                ),
                Container(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                    ),
                    Icon(
                      CupertinoIcons.info,
                      color: Colors.white,
                      size: 30,
                    ),
                    Container(
                      width: 20,
                    ),
                    Text(
                      "About",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                  ],
                ),
                Container(
                  height: 15,
                ),
                Container(
                  height: 0.5,
                  color: Color.fromARGB(255, 77, 77, 77),
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                    ),
                    GestureDetector(
                        onTap: () {
                          authState.logout();
                          Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(
                                  builder: (context) => SplashPage()));
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              child: Text(
                                "Log out",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17),
                              ),
                            ))),
                  ],
                ),
              ],
            )));
  }
}
