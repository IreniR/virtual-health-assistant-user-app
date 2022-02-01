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
        'SIGN UP',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 92),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          primary: Colors.cyan.shade400),
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
            resizeToAvoidBottomInset: false,
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
                                colors: [
                              Colors.pink.shade300,
                              Colors.pink.shade100,
                              // Colors.purple.shade50
                            ])),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Image.asset('assets/logo.png')),
                              InputTextField(
                                hintText: 'Email',
                                validator: emailValidator,
                                obscureText: false,
                                keyBoardType: TextInputType.emailAddress,
                                onSaved: (input) => email = input,
                                icon: Icon(
                                  Icons.verified_user_outlined,
                                  color: Colors.pink.shade900,
                                ),
                              ),
                              InputTextField(
                                validator: passwordValidator,
                                obscureText: true,
                                keyBoardType: TextInputType.visiblePassword,
                                onSaved: (input) => password = input,
                                hintText: 'Password',
                                icon: Icon(
                                  Icons.lock,
                                  color: Colors.pink.shade900,
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
          'LOGIN',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 100),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            primary: Colors.amber.shade400),
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
