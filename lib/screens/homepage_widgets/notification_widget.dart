import 'package:final_exercises/providers/UserProvider.dart';
import 'package:final_exercises/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: Column(
        children: [
          const Center(
            child: Text('Notification'),
          ),
          ElevatedButton(
              onPressed: () {
                authState.logout();
                Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(builder: (context) => SplashPage()));
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              )),
        ],
      ),
    );
  }
}
