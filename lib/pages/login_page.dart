import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_assistant/pages/register_page.dart';
import 'package:health_assistant/utils/validator.dart';
import 'package:health_assistant/widgets/fields.dart';
import 'package:health_assistant/widgets/menu.dart';
//import 'package:health_app/utils/validators.dart';
import 'forgot_pswrd_page.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login_page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

Widget forgotBtn(BuildContext context) {
  return Container(
    alignment: Alignment(1.0, 0.0),
    child: TextButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
      },
      child: Text(
        'Forgot Password',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Widget registerBtn(BuildContext context) {
  return Container(
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RegisterPage()));
      },
      child: Text(
        'Sign Up',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 70),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          primary: Colors.cyan),
    ),
  );
}

class _LoginPageState extends State<LoginPage> {
  String email, password;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
            body: Form(
          key: _formkey,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: GestureDetector(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.lightGreen, Colors.blueAccent])),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 25),
                            child: Text(
                              'FitNess',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          InputTextField(
                            hintText: 'Email',
                            validator: emailValidator,
                            keyBoardType: TextInputType.emailAddress,
                            onSaved: (input) => email = input,
                            icon: Icon(
                              Icons.verified_user_outlined,
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                          InputTextField(
                            hintText: 'Password',
                            keyBoardType: TextInputType.visiblePassword,
                            validator: passwordValidator,
                            onSaved: (input) => password = input,
                            icon: Icon(
                              Icons.lock,
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                          forgotBtn(context),
                          loginBtn(context),
                          registerBtn(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )));
  }

  Future<void> loginUser() async {
    final formState = _formkey.currentState;
    if (formState.validate()) {
      //firebase integration
      formState.save();
      try {
        UserCredential user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NavigationPage(user: user)));
      } on FirebaseAuthException catch (e) {
        print(e.code.toString());
        if (e.code == 'user-not-found') {
          userNotFoundError();
          //return 'User Not Found, Please Sign Up';
        } else if (e.code == 'wrong-password') {
          incorrectCredentials();
        }
        return null;
      }
    }
  }

  Widget loginBtn(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () async {
          loginUser();
        },
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 80),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            primary: Colors.red),
      ),
    );
  }

  void userNotFoundError() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('User Not Found'),
            content: Text('Please Sign Up'),
          );
        });
  }

  void incorrectCredentials() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Email or Password'),
          );
        });
  }
}
