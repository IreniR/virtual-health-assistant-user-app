import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> addUserBodyFat(String email, double bodyfat) async {
  CollectionReference userDetails =
      FirebaseFirestore.instance.collection('User Details');

  DateTime currentDate = DateTime.now();

  userDetails
      .doc(email)
      .collection("dates_bodyfat")
      .add({'bodyfat': bodyfat, 'datetime': currentDate}).catchError(
          (error) => print('Add failed: $error'));
  return;
}
