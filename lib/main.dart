import 'package:final_exercises/firebase_options.dart';
import 'package:final_exercises/providers/UserProvider.dart';
import 'package:final_exercises/providers/post.state.dart';
import 'package:final_exercises/providers/search.state.dart';
import 'package:final_exercises/screens/splash.dart';
import 'package:final_exercises/views/theme/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => PostState()),
        ChangeNotifierProvider(create: (context) => SearchState()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightMode,
          // darkTheme: darkMode,
          home: SplashPage()),
    );
  }
}
