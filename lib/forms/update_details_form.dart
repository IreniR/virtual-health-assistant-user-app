import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/cards/gender_cards.dart';
import 'package:health_assistant/pages/health_page.dart';
import 'package:health_assistant/pages/settings_page.dart';
import 'package:health_assistant/utils/Gender.dart';
import 'package:health_assistant/utils/validator.dart';
import 'package:health_assistant/widgets/fields.dart';
import 'package:intl/intl.dart';

class UpdateDetailsForm extends StatefulWidget {
  static const String id = 'update_details_form';
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  _UpdateDetailsFormState createState() => _UpdateDetailsFormState();
}

class _UpdateDetailsFormState extends State<UpdateDetailsForm> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  List<Gender> genders = new List<Gender>();

  int age;
  double height;
  double weight;
  String gender;
  DateTime currentDate = DateTime.now();

  _UpdateDetailsFormState() {
    genders.add(new Gender("Male", Icons.male, false));
    genders.add(new Gender("Female", Icons.female, false));
    genders.add(new Gender("Other", Icons.transgender, false));
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
              title: Text('Update Details Page',
                  style: TextStyle(color: Colors.pink.shade900)),
              leading: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: Colors.pink.shade900,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => SettingsPage()));
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
        onPressed: () {
          if (_formkey.currentState.validate()) {
            print('successfully logged in');
            updateInformation();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HealthPage()));
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

  Future updateInformation() async {
    final formState = _formkey.currentState;
    if (formState.validate()) {
      //firebase integration
      formState.save();
      CollectionReference userDetails =
          FirebaseFirestore.instance.collection('User Details');

      double bmi = weight / pow(height / 100, 2);
      DateTime currentDate = DateTime.now();

      userDetails.doc(auth.currentUser.email).collection("dates").add({
        'height': height,
        'weight': weight,
        'age': age,
        'gender': gender,
        'bmi': bmi,
        'datetime': currentDate
      }).catchError((error) => print('Add failed: $error'));
      return;
    }
  }
}
