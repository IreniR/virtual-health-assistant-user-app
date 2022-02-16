import 'package:test/test.dart';
import 'dart:math';
import 'package:health_assistant/utils/validator.dart';

void main() {
  //Testing Email Validator
  test("Empty Email Test", () {
    var result = emailValidator('');
    expect('Email Cannot Be Empty', result);
  });

  test("Invlid Email Test", () {
    var result = emailValidator("testing@.com");
    expect('Enter Valid Email', result);
  });

  test("Valid Email Test", () {
    var result = emailValidator("testing@gmail.com");
    expect(null, result);
  });

  //Check Password Validator
  test("Empty Password Test", () {
    var result = passwordValidator('');
    expect('Password Cannot Be Empty', result);
  });

  test("Invalid Password Test", () {
    var result = passwordValidator('test');
    expect(
        'Password must be at least 6 characters and consist of 1 uppercase letter, \n1 digit, and 1 special character',
        result);
  });

  test("Invalid Password Test", () {
    var result = passwordValidator('testing');
    expect(
        'Password must be at least 6 characters and consist of 1 uppercase letter, \n1 digit, and 1 special character',
        result);
  });

  test("Valid Password Test", () {
    var result = passwordValidator('Test123@');
    expect(null, result);
  });

  //Check Birthdate Validator
  test("Invalid Birthdate Test", () {
    var result = dateOfBirthValidator('19/02/02');
    expect('Please enter in a yyyy/mm/dd format', result);
  });

  test("Valid Birthdate Test", () {
    var result = dateOfBirthValidator('1999/02/02');
    expect(null, result);
  });

  //Check BMI Calculation
  test("BMI Test", () {
    var weight = 60;
    var height = 170;
    expect((weight / pow(height / 100, 2)).toStringAsFixed(1), '20.8');
  });
}
