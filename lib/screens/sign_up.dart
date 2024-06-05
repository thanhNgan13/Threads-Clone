import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    final fullName = fullNameController.text;
    final username = usernameController.text;
    if (email.isEmpty ||
        password.isEmpty ||
        fullName.isEmpty ||
        username.isEmpty) {
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
      try {
        // Sign up user
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        // Save user details to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'id': userCredential.user!.uid,
          'name': fullName,
          'username': username,
          'followers': <String>[],
          'following': <String>[],
          'profileImageUrl': 'assets/images/logo_threads.png',
          'biography': '',
          //may be add more fields here
        });
        // Navigate to home screen
        Navigator.pop(context);
      } catch (e) {
        print(e);
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
