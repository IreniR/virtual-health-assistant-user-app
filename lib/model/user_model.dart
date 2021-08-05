import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> userSetup(String userName, String email) async {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String uid = _firebaseAuth.currentUser.toString();
  users.add({'uid': uid, 'userName': userName, 'email': email});
  return;
}
