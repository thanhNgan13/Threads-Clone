import 'package:final_exercises/providers/UserProvider.dart';
import 'package:final_exercises/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  Future<void> signUp() async {
    final email = emailController.text;
    final password = passwordController.text;
    final name = fullNameController.text;
    final username = usernameController.text;
    if (email.isEmpty || password.isEmpty || name.isEmpty || username.isEmpty) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Error',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
              content: Text('Please enter all fields'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                )
              ],
            );
          });
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      try {
        await Provider.of<UserProvider>(context, listen: false)
            .signUpWithEmail(email, password, name, username);
        // Navigate to home screen
        Navigator.of(context).pop(); // Close the loading dialog

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()));
      } catch (e) {
        print(e);
        Navigator.of(context).pop(); // Close the loading dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Error',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
              content: Text('Failed to sign up. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                )
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset('assets/images/logo_threads.png', width: 90),
          Padding(
            padding:
                const EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 10),
            child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
                controller: fullNameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Enter your full name',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Enter your username',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () async {
                    await signUp();
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )),
            ),
          ),
          const Spacer(),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Already have an account?'),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Login',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            )
          ])
        ],
      ),
    ));
  }
}
