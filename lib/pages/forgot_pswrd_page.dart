import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/utils/validator.dart';
import 'package:health_assistant/widgets/fields.dart';

import 'login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const String id = 'forgot_password_page';

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String email;
  final GlobalKey<FormState> _resetFormkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.pink.shade900),
              ),
              leading: IconButton(
                key: Key('forgotPasswordBackBtn'),
                icon: Icon(
                  Icons.chevron_left,
                  color: Colors.pink.shade900,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
            ),
            body: Form(
              key: _resetFormkey,
              child: Container(
                decoration: BoxDecoration(
                    gradient: RadialGradient(
                        center: Alignment.centerRight,
                        radius: 2,
                        colors: [
                      Colors.amber.shade50,
                      Colors.pink.shade50,
                      Colors.purple.shade100
                    ])),
                child: Column(
                  children: [
                    SizedBox(height: 65),
                    Padding(
                        padding: EdgeInsets.only(top: 25, left: 10, right: 10),
                        child: Text(
                          'Enter Email To Be Sent Password Reset Link',
                          style: TextStyle(color: Colors.pink.shade900),
                        )),
                    InputTextField(
                      key: Key('ResetPassEmailValidator'),
                      hintText: 'Email',
                      obscureText: false,
                      validator: emailValidator,
                      keyBoardType: TextInputType.text,
                      onSaved: (input) => email = input,
                      icon: Icon(
                        Icons.verified_user_outlined,
                        color: Colors.pink.shade900,
                      ),
                    ),
                    SizedBox(height: 15),
                    resetPasswordBtn(),
                  ],
                ),
              ),
            )));
  }

  Widget resetPasswordBtn() {
    return Container(
      child: ElevatedButton(
        key: Key('resetPasswordBtn'),
        onPressed: () {
          resetPassword();
        },
        child: Text(
          'Reset Password',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 60),
            primary: Colors.cyan,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
      ),
    );
  }

  Future resetPassword() async {
    final formState = _resetFormkey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        _resetDialog();
        print('Reset email has been sent');
      } catch (e) {
        _invalidEmailDialog();

        print(e.toString());
      }
    }
  }

  void _resetDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            key: Key('successResetPassword'),
            title: Text('Reset Password'),
            content: Text('Reset Password link has been sent to $email'),
            actions: <Widget>[
              TextButton(
                key: Key('confirmResetButton'),
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _invalidEmailDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            key: Key('invalidEmailResetPassword'),
            title: Text('Invalid Email'),
            content: Text('User may have been deleted'),
            actions: <Widget>[
              TextButton(
                key: Key('confirmResetButton'),
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
