import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//final GoogleSignIn _googleSignIn = GoogleSignIn();

class AuthService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');

  Future updateUserInfo(String usersName, String email) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    return await userCollection.doc(firebaseUser.uid).set({
      'users name': usersName,
      'email': email,
    });
  }
}
