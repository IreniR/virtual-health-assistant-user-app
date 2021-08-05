import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:health_assistant/model/user_model.dart';
import 'package:health_assistant/utils/validator.dart';
import 'package:health_assistant/widgets/fields.dart';
//import 'package:toggle_bar/toggle_bar.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  static const String id = 'register_page';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  List<String> labels = ['Register Patient', 'Register Doctor'];
  //int counter = 0;
  String validEmail, newUsersName;

  TextEditingController validPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  // Widget registerForm(BuildContext context) {
  //   switch (counter) {
  //     case 0:
  //       return (registerPatientForm(context));
  //     // case 1:
  //     //   return (registerDoctorForm(context));
  //     default:
  //       return Container(color: Colors.transparent);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text('Register Patient'),
              leading: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
            ),
            body: Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // ToggleBar(
                      //   labels: labels,
                      //   backgroundColor: Colors.black,
                      //   selectedTabColor: Colors.red,
                      //   onSelectionUpdated: (index) {
                      //     setState(() {
                      //       counter = index;
                      //     });
                      // },
                      //),
                      // SizedBox(height: 10),
                      registerPatientForm(context),
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget registerPatientForm(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
          ),
          InputTextField(
            hintText: 'Enter Full Name',
            keyBoardType: TextInputType.name,
            validator: emptyFieldValidator,
            onSaved: (input) => newUsersName = input,
            icon: Icon(
              Icons.verified_user,
              color: Colors.lightBlueAccent,
            ),
          ),
          InputTextField(
            hintText: 'Enter Valid Email',
            keyBoardType: TextInputType.emailAddress,
            validator: emailValidator,
            onSaved: (input) => validEmail = input,
            icon: Icon(
              Icons.email_outlined,
              color: Colors.lightBlueAccent,
            ),
          ),
          InputTextField(
            hintText: 'Enter Valid Password',
            keyBoardType: TextInputType.text,
            validator: passwordValidator,
            onSaved: (input) => validPassword.text = input,
            controller: validPassword,
            icon: Icon(
              Icons.lock,
              color: Colors.lightBlueAccent,
            ),
          ),
          InputTextField(
            hintText: 'Confirm Password',
            keyBoardType: TextInputType.text,
            controller: confirmPassword,
            validator: (String value) {
              if (value.isEmpty) return 'Field cannot be empty';
              if (confirmPassword.text != validPassword.text)
                return "Passwords do not match";
              else
                return null;
            },
            onSaved: (value) => confirmPassword.text = value,
            icon: Icon(
              Icons.lock,
              color: Colors.lightBlueAccent,
            ),
          ),
          submitBtn(),
        ],
      ),
    );
  }

  Widget submitBtn() {
    return Container(
      alignment: FractionalOffset.bottomCenter,
      child: ElevatedButton(
        onPressed: () {
          if (_formkey.currentState.validate()) {
            print('successfully logged in');
            createUser();
          } else
            return 'unsuccessfully registered user';
        },
        child: Text(
          'Submit',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 60),
            primary: Colors.amber,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
      ),
    );
  }

  Future createUser() async {
    final formState = _formkey.currentState;
    if (formState.validate()) {
      //firebase integration
      formState.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: validEmail, password: confirmPassword.text);
        User user = userCredential.user;
        user.sendEmailVerification();
        User updateUser = FirebaseAuth.instance.currentUser;
        updateUser.updateProfile(displayName: newUsersName);
        userSetup(newUsersName, validEmail);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') return emailInUse();
      }
    }
  }

  void emailInUse() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Email is Already in Use'),
          );
        });
  }
}
