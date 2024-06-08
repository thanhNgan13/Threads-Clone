import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPostBioScreen extends StatefulWidget {
  final String postId;

  EditPostBioScreen({required this.postId});

  @override
  _EditPostBioScreenState createState() => _EditPostBioScreenState();
}

class _EditPostBioScreenState extends State<EditPostBioScreen> {
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCurrentBio();
  }

  Future<void> _fetchCurrentBio() async {
    setState(() {
      _isLoading = true;
    });

    try {
      DocumentSnapshot postSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .get();

      if (postSnapshot.exists) {
        String currentBio = postSnapshot.get('bio') ?? '';
        _bioController.text = currentBio;
      } else {
        throw Exception("Post document does not exist!");
      }
    } catch (error) {
      print('Failed to fetch current bio: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch current bio: $error')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> updatePostBio(String postId, String newBio) async {
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('posts').doc(postId);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot postSnapshot = await transaction.get(postRef);

        if (!postSnapshot.exists) {
          throw Exception("Post document does not exist!");
        }

        transaction.update(postRef, {
          'bio': newBio,
        });
      });
    } catch (error) {
      print('Failed to update post bio: $error');
      throw Exception('Failed to update post bio');
    }
  }

  void _submit() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await updatePostBio(widget.postId, _bioController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bio updated successfully')),
      );
      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update bio: $error')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post Bio'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _bioController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'New Bio',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : ElevatedButton(
                    onPressed: _submit,
                    child: Text('Update Bio',
                        style: TextStyle(color: Colors.black)),
                  ),
          ],
        ),
      ),
    );
  }
}
