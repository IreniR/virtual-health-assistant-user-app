import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> addUserDetails(
    String email, int age, double height, double weight, String gender) async {
  CollectionReference userDetails =
      FirebaseFirestore.instance.collection('User Details');

  double bmi = weight / pow(height / 100, 2);

  userDetails.doc(email).set({
    'height': height,
    'weight': weight,
    'age': age,
    'gender': gender,
    'bmi': bmi
  }).catchError((error) => print('Add failed: $error'));
  return;
}

Future<String> getBMI() async {
  double bmi;
  String email = FirebaseAuth.instance.currentUser.email.toString();
  FirebaseFirestore.instance
      .collection('User Details')
      .doc(email)
      .get()
      .then((value) {
    bmi = value.data()["bmi"];
    return bmi.toStringAsFixed(2);
  });

  // @override
  // Widget build(BuildContext context) {
  //   CollectionReference users =
  //       FirebaseFirestore.instance.collection('User Details');
  //   String email = FirebaseAuth.instance.currentUser.email.toString();

  // return FutureBuilder<DocumentSnapshot>(
  //   future: users.doc(email).get(),
  //   builder:
  //       (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  //     if (snapshot.hasError) {
  //       return Text("Something went wrong");
  //     }

  //     if (snapshot.connectionState == ConnectionState.done) {
  //       Map<String, dynamic> data = snapshot.data.data();
  //       return HealthRiskCards(
  //         title: Text('BMI',
  //             style: TextStyle(color: Colors.white, fontSize: 20)),
  //         value: Text(data["bmi"]),
  //       );
  //     }

  //     return Text("loading");
  //   },
  // );
  // }
}
