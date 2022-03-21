import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_assistant/model/user_model.dart';
import 'package:health_assistant/model/user_details_model.dart';
import 'package:health_assistant/widgets/fields.dart';
import 'package:health_assistant/utils/validator.dart';
import 'package:health_assistant/utils/Gender.dart';
import 'package:health_assistant/cards/gender_cards.dart';
import 'register_page.dart';
import 'package:intl/intl.dart';
import 'login_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserDetailsPage extends StatefulWidget {
  static const String id = 'user_details_page';
  String validEmail;
  String password;

  UserDetailsPage(String validEmail, String password) {
    this.validEmail = validEmail;
    this.password = password;
  }

  @override
  _UserDetailsPageState createState() =>
      _UserDetailsPageState(this.validEmail, this.password);
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  List<Gender> genders = new List<Gender>();

  String validEmail;
  String password;
  String newUsersName;
  int age;
  double height;
  double weight;
  String gender;
  Key key;
  DateTime currentDate = DateTime.now();

  _UserDetailsPageState(String validEmail, String password) {
    this.validEmail = validEmail;
    this.password = password;

    genders.add(new Gender("Male", Icons.male, false, Key('maleGenderCard')));
    genders.add(
        new Gender("Female", Icons.female, false, Key('femaleGenderCard')));
    genders.add(
        new Gender("Other", Icons.transgender, false, Key('otherGenderCard')));
  }

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
              title: Text('Add Details Page',
                  style: TextStyle(color: Colors.pink.shade900)),
              leading: IconButton(
                key: Key('userDetailsBackBtn'),
                icon: Icon(
                  Icons.chevron_left,
                  color: Colors.pink.shade900,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
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
                      addDetailsForm(context),
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget addDetailsForm(BuildContext context) {
    return Container(
        child: Column(children: [
      Container(
        width: MediaQuery.of(context).size.width * 0.8,
      ),
      InputTextField(
        key: Key('dobField'),
        labelText: "Date of Birth",
        hintText: "Date of Birth (yyyy/mm/dd)",
        obscureText: false,
        keyBoardType: TextInputType.datetime,
        validator: dateOfBirthValidator,
        onSaved: (input) => calculateAge(input),
        icon: Icon(
          Icons.calendar_today,
          color: Colors.pink.shade900,
        ),
      ),
      InputTextField(
        key: Key('weightField'),
        labelText: 'Weight',
        hintText: 'Weight (kg)',
        obscureText: false,
        keyBoardType: TextInputType.number,
        validator: numericValidator,
        onSaved: (input) => weight = double.parse(input),
        icon: Icon(
          Icons.monitor_weight,
          color: Colors.pink.shade900,
        ),
      ),
      InputTextField(
        key: Key('heightField'),
        labelText: 'Height',
        hintText: 'Height (cm)',
        obscureText: false,
        keyBoardType: TextInputType.number,
        validator: numericValidator,
        onSaved: (input) => height = double.parse(input),
        icon: Icon(
          Icons.height,
          color: Colors.pink.shade900,
        ),
      ),
      Container(
        height: 100,
        child: new ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: genders.length,
            itemBuilder: (context, index) {
              return InkWell(
                key: Key(gender),
                onTap: () {
                  setState(() {
                    genders.forEach((gender) => gender.isSelected = false);
                    genders[index].isSelected = true;
                    gender = genders[index].name;
                    print(gender);
                  });
                },
                child: gender_cards(genders[index]),
              );
            }),
      ),
      SizedBox(height: 15),
      submitBtn(),
    ]));
  }

  void calculateAge(String stringDate) {
    DateTime date = new DateFormat("yyyy/MM/dd").parse(stringDate);
    age = currentDate.year - date.year;
    int month1 = currentDate.month;
    int month2 = date.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = date.day;
      if (day2 > day1) {
        age--;
      }
    }
  }

  Widget submitBtn() {
    return Container(
      alignment: FractionalOffset.bottomCenter,
      child: ElevatedButton(
        key: Key('submitBtn'),
        onPressed: () {
          if (_formkey.currentState.validate()) {
            print('successfully logged in');
            createUser();
          } else
            return 'unsuccessfully registered user';
        },
        child: Text(
          'Submit',
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

  Future createUser() async {
    final formState = _formkey.currentState;
    if (formState.validate()) {
      //firebase integration
      formState.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: validEmail, password: password);
        User user = userCredential.user;
        user.sendEmailVerification();
        User updateUser = FirebaseAuth.instance.currentUser;
        updateUser.updateProfile(displayName: newUsersName);

        userSetup(newUsersName, validEmail);
        createUserDetails();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') return emailInUse();
      }
    }
  }

  Future createUserDetails() async {
    final formState = _formkey.currentState;
    if (formState.validate()) {
      //firebase integration
      formState.save();
      addUserDetails(
        this.validEmail,
        this.age,
        this.height,
        this.weight,
        this.gender,
      );

      Fluttertoast.showToast(
          msg: "Successfully Created Account!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  void emailInUse() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            key: Key('emailInUseAlert'),
            title: Text('Email is Already in Use'),
          );
        });
  }
}
