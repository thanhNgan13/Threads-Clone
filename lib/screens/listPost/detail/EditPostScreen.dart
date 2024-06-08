import 'package:flutter/material.dart';
import 'package:final_exercises/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPostScreen extends StatefulWidget {
  final PostModel postModel;

  EditPostScreen({required this.postModel});

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  TextEditingController _bioController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _bioController.text = widget.postModel.bio ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });

    // Listen to real-time updates for the specific post
    _firestore
        .collection('posts')
        .doc(widget.postModel.key)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        setState(() {
          widget.postModel.bio = snapshot['bio'];
        });
      }
    });
  }

  @override
  void dispose() {
    _bioController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _savePost() async {
    print('Saving post...');
    String newBio = _bioController.text.trim();
    if (newBio.isNotEmpty) {
      setState(() {
        widget.postModel.bio = newBio;
      });

      // Hiển thị loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      try {
        await _firestore.collection('posts').doc(widget.postModel.key).update({
          'bio': newBio,
        });
        print('Post updated successfully');

        Navigator.of(context).pop(); // Đóng loading dialog

        if (mounted) {
          Navigator.of(context).pop(); // Quay về màn hình trước đó
        }
      } catch (e) {
        Navigator.of(context).pop(); // Đóng loading dialog
        print('Failed to update post: $e'); // Ghi nhật ký lỗi
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update post: $e')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post content cannot be empty')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.white),
            onPressed: _savePost,
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  key: Key('bioTextField'),
                  controller: _bioController,
                  maxLines: null,
                  focusNode: _focusNode,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  keyboardAppearance:
                      Brightness.dark, // Set the keyboard appearance to dark
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black,
                    hintText: 'Edit your post',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
