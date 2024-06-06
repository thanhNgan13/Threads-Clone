import 'package:final_exercises/providers/UserProvider.dart';
import 'package:final_exercises/screens/home.dart';
import 'package:final_exercises/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timer();
    });
    super.initState();
  }

  bool isAppUpdated = true;

  void timer() async {
    if (isAppUpdated) {
      Future.delayed(const Duration(seconds: 1)).then((_) {
        var state = Provider.of<UserProvider>(context, listen: false);
      });
    }
  }

  Widget _body() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: state.isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
