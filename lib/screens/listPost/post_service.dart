import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> deletePost(String postId, String userId) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection('posts').doc(postId).delete();

    await firestore
        .collection('users')
        .doc(userId)
        .collection('posts')
        .doc(postId)
        .delete();
  } catch (error) {
    print('Error deleting post: $error');
  }
}
