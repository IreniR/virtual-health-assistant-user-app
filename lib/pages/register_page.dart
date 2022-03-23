import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:health_assistant/pages/user_details_page.dart';
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
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                "Register Here",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade900,
                    fontSize: 20),
              ),
              leading: IconButton(
                key: Key('registerBackButton'),
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
              key: _formkey,
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(top: 75),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                        Colors.amber.shade50,
                        Colors.pink.shade50,
                        Colors.purple.shade100
                      ])),
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
            key: Key('registerUsernameField'),
            labelText: 'Full Name',
            hintText: 'Enter Full Name',
            obscureText: false,
            keyBoardType: TextInputType.name,
            validator: emptyFieldValidator,
            onSaved: (input) => newUsersName = input,
            icon: Icon(
              Icons.verified_user,
              color: Colors.pink.shade900,
            ),
          ),
          InputTextField(
            key: Key('registerEmailField'),
            labelText: 'Email',
            hintText: 'Enter Valid Email',
            obscureText: false,
            keyBoardType: TextInputType.emailAddress,
            validator: emailValidator,
            onSaved: (input) => validEmail = input,
            icon: Icon(
              Icons.email_outlined,
              color: Colors.pink.shade900,
            ),
          ),
          InputTextField(
            key: Key('registerPasswordField'),
            labelText: 'Password',
            hintText: 'Enter Valid Password',
            obscureText: true,
            keyBoardType: TextInputType.text,
            validator: passwordValidator,
            onSaved: (input) => validPassword.text = input,
            controller: validPassword,
            icon: Icon(
              Icons.lock,
              color: Colors.pink.shade900,
            ),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                      'Password must: \n\nConsist at least 6 characters \nConsist of 1 uppercase letter \nConsist 1 digit \nConsist 1 special character'))),
          InputTextField(
            key: Key('confirmPasswordField'),
            labelText: 'Confirm Password',
            hintText: 'Confirm Password',
            obscureText: true,
            keyBoardType: TextInputType.text,
            controller: confirmPassword,
            validator: (String value) {
              if (value.isEmpty) return 'Field cannot Be Empty';
              if (confirmPassword.text != validPassword.text)
                return "Passwords Do Not Match";
              else
                return null;
            },
            onSaved: (value) => confirmPassword.text = value,
            icon: Icon(
              Icons.lock,
              color: Colors.pink.shade900,
            ),
          ),
          userDetailsBtn(context),
        ],
      ),
    );
  }

  Widget userDetailsBtn(BuildContext context) {
    return Container(
      alignment: FractionalOffset.bottomCenter,
      child: ElevatedButton(
        key: Key('userDetailsBtn'),
        onPressed: () {
          final formState = _formkey.currentState;
          if (formState.validate()) {
            formState.save();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        new UserDetailsPage(validEmail, confirmPassword.text)));
          } else
            return 'unsuccessfully registered user';
        },
        child: Text(
          'Next',
          style: TextStyle(fontSize: 20, color: Colors.white),
          key: Key('nextBtn'),
        ),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 70),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            primary: Colors.cyan),
      ),
    );
  }
}
