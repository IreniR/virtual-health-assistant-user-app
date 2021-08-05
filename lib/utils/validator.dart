import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/pages/login_page.dart';

String emptyFieldValidator(String input) {
  if (input.isEmpty) return 'Field cannot be empty';
  return null;
}

bool validateEmail(String value) {
  Pattern pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

String emailValidator(String input) {
  if (input.isEmpty) return 'Email cannot be empty';
  if (!validateEmail(input)) return 'Enter valid email';
  return null;
}

String passwordValidator(String input) {
  if (input.isEmpty) return 'Password cannot be empty';
  if (!passwordFormat(input)) return 'Password is not of proper format';
  return null;
}

bool passwordFormat(String input, [int minLength = 6]) {
  if (input == null || input.isEmpty) {
    return false;
  }

  bool hasUppercase = input.contains(new RegExp(r'[A-Z]'));
  bool hasDigits = input.contains(new RegExp(r'[0-9]'));
  bool hasLowercase = input.contains(new RegExp(r'[a-z]'));
  bool hasSpecialCharacters =
      input.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  bool hasMinLength = input.length > minLength;

  return hasDigits &
      hasUppercase &
      hasLowercase &
      hasSpecialCharacters &
      hasMinLength;
}

Future<bool> validateUser(String userID) async {
  bool exists = false;
  try {
    await FirebaseFirestore.instance
        .doc('UserIdentification/$userID')
        .get()
        .then((user) {
      if (user.exists)
        exists = true;
      else
        exists = false;
    });
    return exists;
  } catch (e) {
    return false;
  }
}

Future<void> checkEmailVerified(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  await user.reload();
  if (user.emailVerified) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
