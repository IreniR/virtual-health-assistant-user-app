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

String email = FirebaseAuth.instance.currentUser.email.toString();

class _DiabetesFormPageState extends State<DiabetesFormPage> {
  CollectionReference dates = FirebaseFirestore.instance
      .collection('User Details')
      .doc(email)
      .collection("dates");

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  double glucose;
  double bloodPressure;
  double insulin;
  int age;
  double bmi;
  String riskMessage = '';

  void setAgeBMI() {
    dates.get().then((querySnapshot) {
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      allData.sort((a, b) {
        var adate = (a as Map)["datetime"];
        var bdate = (b as Map)["datetime"];
        return adate.compareTo(bdate);
      });
      final last = allData.last as Map;
      age = last["age"];
      bmi = last["bmi"];
    });
  }

  Future<String> predictDiabetesProbability(var body) async {
    print(body);
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
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('Diabetes Prediction Form',
                  style: TextStyle(color: Colors.pink.shade900)),
              leading: IconButton(
                key: Key('NotificationButton'),
                icon: Icon(
                  Icons.chevron_left,
                  color: Colors.pink.shade900,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => MeasurePage()));
                },
              ),
            ),
            body: Container(
                decoration: BoxDecoration(
                    gradient: RadialGradient(
                        center: Alignment.centerRight,
                        radius: 2,
                        colors: [
                      Colors.amber.shade50,
                      Colors.pink.shade50,
                      Colors.purple.shade100
                    ])),
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Column(children: [
                      Padding(padding: EdgeInsets.only(top: 55)),
                      Form(
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
                                    onSaved: (input) =>
                                        glucose = double.parse(input),
                                    validator: numericValidator,
                                    icon: Icon(
                                      Icons.monitor_weight,
                                      color: Colors.pink.shade300,
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
                                        color: Colors.pink.shade300,
                                      )),
                                  InputTextField(
                                      labelText: 'Insulin',
                                      hintText: 'Insulin',
                                      obscureText: false,
                                      keyBoardType: TextInputType.number,
                                      onSaved: (input) =>
                                          insulin = double.parse(input),
                                      validator: numericValidator,
                                      icon: Icon(
                                        Icons.height,
                                        color: Colors.pink.shade300,
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
                      )
                    ])))));
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
            style:
                TextStyle(color: Color.fromARGB(255, 83, 9, 49), fontSize: 20)),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 80),
          primary: Colors.pink.shade200,
        ));
  }
}
