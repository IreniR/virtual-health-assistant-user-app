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
  if (input.isEmpty) return 'Email Cannot Be Empty';
  if (!validateEmail(input)) return 'Enter Valid Email';
  return null;
}

String passwordValidator(String input) {
  if (input.isEmpty) return 'Password Cannot Be Empty';
  if (!passwordFormat(input))
    return 'Password must be at least 6 characters and consist of: \n  1 uppercase letter, 1 digit, and 1 special character';
  return null;
}

String numericValidator(String input) {
  if (input.isEmpty) return 'Please enter a number';
  if (double.parse(input) < 0) {
    return 'Please enter a valid value';
  }
  return null;
}

String dateOfBirthValidator(String input) {
  if (input.isEmpty) return 'Please enter valid birthday';
  if (!dateOfBirthFormat(input)) return "Please enter in a yyyy/mm/dd format";
  return null;
}

bool dateOfBirthFormat(String input) {
  return new RegExp(r'(\d{4})/(\d{2})/(\d{2})').hasMatch(input);
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
