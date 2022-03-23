import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_assistant/model/user_body_fat_model.dart';
import 'package:health_assistant/utils/validator.dart';
import 'package:health_assistant/widgets/fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:health_assistant/pages/measure_page.dart';
import 'package:http/http.dart' as http;

class BodyFatFormPage extends StatefulWidget {
  static const String id = 'bodyfat_form_page';

  @override
  _BodyFatFormPageState createState() => _BodyFatFormPageState();
}

String email = FirebaseAuth.instance.currentUser.email.toString();

class _BodyFatFormPageState extends State<BodyFatFormPage> {
  CollectionReference dates = FirebaseFirestore.instance
      .collection('User Details')
      .doc(email)
      .collection("dates");

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  double neck;
  double chest;
  double abdomen;
  double hip;
  double thigh;
  double knee;
  double ankle;
  double bicep;
  double forarm;
  double wrist;
  int age;
  double weight;
  double height;
  String riskMessage = '';

  void setParams() {
    dates.get().then((querySnapshot) {
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      allData.sort((a, b) {
        var adate = (a as Map)["datetime"];
        var bdate = (b as Map)["datetime"];
        return adate.compareTo(bdate);
      });
      final last = allData.last as Map;
      age = last["age"];
      weight = last["weight"] * 2.2;
      height = last["height"] * 0.39;
    });
  }

  Future<String> measureBodyFat(var body) async {
    print(body);
    var client = new http.Client();
    var uri = Uri.parse("https://bodyfat-prediction-otu.herokuapp.com/predict");
    Map<String, String> headers = {"Content-type": "application/json"};
    String jsonString = json.encode(body);
    try {
      var resp = await client.post(uri, headers: headers, body: jsonString);
      print(resp);
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
    setParams();
    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.pink.shade100,
              elevation: 0,
              title: Text('Body Fat Form',
                  style: TextStyle(color: Colors.pink.shade900)),
              leading: IconButton(
                key: Key('BodyFatButton'),
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
                child: SingleChildScrollView(
                    // width: double.infinity,
                    // height: double.infinity,
                    padding: EdgeInsets.only(top: 65),
                    child: Column(children: [
                      Form(
                        key: _formkey,
                        child: SingleChildScrollView(
                          child: Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  InputTextField(
                                    labelText: 'Neck Circumference',
                                    hintText: 'cm',
                                    obscureText: false,
                                    keyBoardType: TextInputType.number,
                                    onSaved: (input) =>
                                        neck = double.parse(input),
                                    validator: numericValidator,
                                    icon: Icon(
                                      Icons.monitor_weight,
                                      color: Colors.pink.shade900,
                                    ),
                                  ),
                                  InputTextField(
                                      labelText: 'Chest Circumference',
                                      hintText: 'cm',
                                      obscureText: false,
                                      keyBoardType: TextInputType.number,
                                      onSaved: (input) =>
                                          chest = double.parse(input),
                                      validator: numericValidator,
                                      icon: Icon(
                                        Icons.height,
                                        color: Colors.pink.shade900,
                                      )),
                                  InputTextField(
                                      labelText: 'Abdomen Circumference',
                                      hintText: 'cm',
                                      obscureText: false,
                                      keyBoardType: TextInputType.number,
                                      onSaved: (input) =>
                                          abdomen = double.parse(input),
                                      validator: numericValidator,
                                      icon: Icon(
                                        Icons.height,
                                        color: Colors.pink.shade900,
                                      )),
                                  InputTextField(
                                      labelText: 'Hip Circumference',
                                      hintText: 'cm',
                                      obscureText: false,
                                      keyBoardType: TextInputType.number,
                                      onSaved: (input) =>
                                          hip = double.parse(input),
                                      validator: numericValidator,
                                      icon: Icon(
                                        Icons.height,
                                        color: Colors.pink.shade900,
                                      )),
                                  InputTextField(
                                      labelText: 'Thigh Circumference',
                                      hintText: 'cm',
                                      obscureText: false,
                                      keyBoardType: TextInputType.number,
                                      onSaved: (input) =>
                                          thigh = double.parse(input),
                                      validator: numericValidator,
                                      icon: Icon(
                                        Icons.height,
                                        color: Colors.pink.shade900,
                                      )),
                                  InputTextField(
                                      labelText: 'Knee Circumference',
                                      hintText: 'cm',
                                      obscureText: false,
                                      keyBoardType: TextInputType.number,
                                      onSaved: (input) =>
                                          knee = double.parse(input),
                                      validator: numericValidator,
                                      icon: Icon(
                                        Icons.height,
                                        color: Colors.pink.shade900,
                                      )),
                                  InputTextField(
                                      labelText: 'Ankle Circumference',
                                      hintText: 'cm',
                                      obscureText: false,
                                      keyBoardType: TextInputType.number,
                                      onSaved: (input) =>
                                          ankle = double.parse(input),
                                      validator: numericValidator,
                                      icon: Icon(
                                        Icons.height,
                                        color: Colors.pink.shade900,
                                      )),
                                  InputTextField(
                                      labelText: 'Bicep Circumference',
                                      hintText: 'cm',
                                      obscureText: false,
                                      keyBoardType: TextInputType.number,
                                      onSaved: (input) =>
                                          bicep = double.parse(input),
                                      validator: numericValidator,
                                      icon: Icon(
                                        Icons.height,
                                        color: Colors.pink.shade900,
                                      )),
                                  InputTextField(
                                      labelText: 'Forarm Circumference',
                                      hintText: 'cm',
                                      obscureText: false,
                                      keyBoardType: TextInputType.number,
                                      onSaved: (input) =>
                                          forarm = double.parse(input),
                                      validator: numericValidator,
                                      icon: Icon(
                                        Icons.height,
                                        color: Colors.pink.shade900,
                                      )),
                                  InputTextField(
                                      labelText: 'Wrist Circumference',
                                      hintText: 'cm',
                                      obscureText: false,
                                      keyBoardType: TextInputType.number,
                                      onSaved: (input) =>
                                          wrist = double.parse(input),
                                      validator: numericValidator,
                                      icon: Icon(
                                        Icons.height,
                                        color: Colors.pink.shade900,
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
              "age": age,
              "weight": weight,
              "height": height,
              "neck": neck,
              "chest": chest,
              "abdomen": abdomen,
              "hip": hip,
              "thigh": thigh,
              "knee": knee,
              "ankle": ankle,
              "bicep": bicep,
              "forarm": forarm,
              "wrist": wrist
            }
          ];
          var resp = await measureBodyFat(body);
          print(resp);
          setState(() {
            riskMessage = "Your Body Fat is: " + resp + "%";
          });
          addUserBodyFat(email, double.parse(resp));
        },
        child: Text("Get Body Fat",
            style: TextStyle(color: Colors.pink.shade900, fontSize: 20)),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 80),
            primary: Colors.pink.shade200));
  }
}
