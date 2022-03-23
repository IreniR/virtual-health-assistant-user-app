import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_assistant/constants/keys.dart';

final usernamewidget = find.byKey(Key(Keys.loginUsernameField));
final passwordwidget = find.byKey(Key(Keys.loginPasswordField));
final loginBtn = find.byKey(Key(Keys.loginBtn));
final registerBtn = find.byKey(Key(Keys.registerBtn));
final forgotPasswordBtn = find.byKey(Key(Keys.forgotPasswordBtn));

final userAvatar = find.byKey(Key(Keys.userAvatar));

final forgotPasswordBackBtn = find.byKey(Key(Keys.forgotPasswordBackBtn));
final resetPasswordBtn = find.byKey(Key(Keys.resetPasswordBtn));
final successResetPassword = find.byKey(Key(Keys.successResetPassword));
final confirmResetButton = find.byKey(Key(Keys.confirmResetButton));
final resetPassEmailValidator = find.byKey(Key(Keys.ResetPasswEmailValidator));

final registerBackButton = find.byKey(Key(Keys.registerBackButton));
final registerUsernameField = find.byKey(Key(Keys.registerUsernameField));
final registerEmailField = find.byKey(Key(Keys.registerEmailField));
final registerPasswordField = find.byKey(Key(Keys.registerPasswordField));
final confirmPasswordField = find.byKey(Key(Keys.confirmPasswordField));
final userDetailsBtn = find.byKey(Key(Keys.userDetailsBtn));
final nextBtn = find.byKey(Key(Keys.nextBtn));
final genderFemale = find.text('Male');
final genderMale = find.text('Female');
final genderOther = find.text('Other');

final maleGenderCard = find.byKey(Key(Keys.maleGenderCard));
final femaleGenderCard = find.byKey(Key(Keys.femaleGenderCard));
final otherGenderCard = find.byKey(Key(Keys.otherGenderCard));
final userDetailsBackBtn = find.byKey(Key(Keys.userDetailsBackBtn));
final dobField = find.byKey(Key(Keys.dobField));
final weightField = find.byKey(Key(Keys.weightField));
final heightField = find.byKey(Key(Keys.heightField));
final submitBtn = find.byKey(Key(Keys.submitBtn));
final emailInUseAlert = find.byKey(Key(Keys.emailInUseAlert));

final oxygenLvl = find.byKey(Key(Keys.oxygenLvl));
final bmiCard = find.byKey(Key(Keys.bmiCard));
final heartRate = find.byKey(Key(Keys.heartRate));
final bloodPressure = find.byKey(Key(Keys.bloodPressure));

final emptyFieldValidator = find.text('Field cannot be empty');
final emptyEmailValidator = find.text('Email Cannot Be Empty');
final invalidEmailValidator = find.text('Enter Valid Email');
final emptyPasswordValidator = find.text('Password Cannot Be Empty');
final passwordsDoNotMatch = find.text("Passwords Do Not Match");
final invalidPasswordValidator = find.text(
    'Password must be at least 6 characters and consist of 1 uppercase letter, \n1 digit, and 1 special character');
final emptyNumericValidator = find.text('Please enter a number');
final invalidNumericValidator = find.text('Please enter a valid value');
final enterValidBirthday = find.text('Please enter valid birthday');
final userNotFoundMsg = find.byKey(Key(Keys.userNotFound));

final validEmail = 'test@mailinator.com';
final validPassword = 'Mobile@123';
final invalidPassword = 'Invalid';
final invalidEmail = 'Invalid';
final correctFormatEmail = '123@123.com';
final correctFormatPassword = '123@App1';
final username = 'Test User';
