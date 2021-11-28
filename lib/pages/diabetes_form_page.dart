import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_assistant/utils/validator.dart';
import 'package:health_assistant/widgets/fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:health_assistant/pages/measure_page.dart';
import 'package:http/http.dart' as http;

class DiabetesFormPage extends StatefulWidget {
  static const String id = 'diabtes_form_page';

  @override
  _DiabetesFormPageState createState() => _DiabetesFormPageState();
}

class _DiabetesFormPageState extends State<DiabetesFormPage> {
  CollectionReference users =
      FirebaseFirestore.instance.collection('User Details');
  String email = FirebaseAuth.instance.currentUser.email.toString();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  double glucose;
  double bloodPressure;
  double insulin;
  int age;
  double bmi;
  String riskMessage = '';

  void setAgeBMI() {
    users.doc(email).get().then((querySnapshot) {
      age = querySnapshot.data()["age"];
      bmi = querySnapshot.data()["bmi"];
    });
  }

  Future<String> predictDiabetesProbability(var body) async {
    var client = new http.Client();
    var uri =
        Uri.parse("https://diabetes-prediction-otu.herokuapp.com/predict");
    Map<String, String> headers = {"Content-type": "application/json"};
    String jsonString = json.encode(body);
    try {
      var resp = await client.post(uri, headers: headers, body: jsonString);
      if (resp.statusCode == 200) {
        print("DATA FETCHED SUCCESSFULLY");
        var result = json.decode(resp.body);
        print(result);
        return result["prediction"];
      }
    } catch (e) {
      print("EXCEPTION OCCURRED: $e");
      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    setAgeBMI();
    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text('Diabetes Form'),
              leading: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => MeasurePage()));
                },
              ),
            ),
            body: Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InputTextField(
                          labelText: 'Glucose',
                          hintText: 'Glucose Level',
                          obscureText: false,
                          keyBoardType: TextInputType.number,
                          onSaved: (input) => glucose = double.parse(input),
                          validator: numericValidator,
                          icon: Icon(
                            Icons.monitor_weight,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                        InputTextField(
                            labelText: 'Blood Pressure',
                            hintText: 'Blood Pressure Level',
                            obscureText: false,
                            keyBoardType: TextInputType.number,
                            onSaved: (input) =>
                                bloodPressure = double.parse(input),
                            validator: numericValidator,
                            icon: Icon(
                              Icons.height,
                              color: Colors.lightBlueAccent,
                            )),
                        InputTextField(
                            labelText: 'Insulin',
                            hintText: 'Insulin',
                            obscureText: false,
                            keyBoardType: TextInputType.number,
                            onSaved: (input) => insulin = double.parse(input),
                            validator: numericValidator,
                            icon: Icon(
                              Icons.height,
                              color: Colors.lightBlueAccent,
                            )),
                        getRiskBtn(),
                        SizedBox(height: 70),
                        Container(
                            child: Text(
                          riskMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        )),
                      ]),
                ),
              ),
            )));
  }

  Widget getRiskBtn() {
    return TextButton(
        onPressed: () async {
          final formState = _formkey.currentState;
          if (formState.validate()) {
            formState.save();
          }
          var body = [
            {
              "glucose": glucose,
              "blood_pressure": bloodPressure,
              "insulin": insulin,
              "bmi": bmi,
              "age": age,
            }
          ];
          var resp = await predictDiabetesProbability(body);
          print(resp);
          setState(() {
            riskMessage = "Your risk of diabetes is " + resp + "%";
          });
        },
        child: Text("Get Diabetes Risk",
            style: TextStyle(color: Colors.black, fontSize: 20)),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 80),
            primary: Colors.cyan));
  }
}
