import 'package:final_exercises/firebase_options.dart';
import 'package:final_exercises/screens/home.dart';
import 'package:final_exercises/screens/login.dart';
import 'package:final_exercises/views/theme/dark_mode.dart';
import 'package:final_exercises/views/theme/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var auth = FirebaseAuth.instance;
  var isLogin = false;

  checkLogin() {
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          isLogin = false;
        });
      } else {
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      // darkTheme: darkMode,
      home: isLogin ? const HomeScreen() : const LoginScreen(),
    );
  }
}
