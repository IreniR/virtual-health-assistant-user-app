import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_assistant/cards/radio_button_cards.dart';
import 'package:health_assistant/utils/Gender.dart';
import 'package:health_assistant/utils/validator.dart';
import 'package:health_assistant/widgets/fields.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/pages/measure_page.dart';
import 'package:http/http.dart' as http;

class StrokeFormPage extends StatefulWidget {
  static const String id = 'stroke_form_page';

  @override
  _StrokeFormPageState createState() => _StrokeFormPageState();
}

String email = FirebaseAuth.instance.currentUser.email.toString();

class _StrokeFormPageState extends State<StrokeFormPage> {
  CollectionReference dates = FirebaseFirestore.instance
      .collection('User Details')
      .doc(email)
      .collection("dates");

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  double glucose;
  int hypertension = 0;
  int heartDisease = 0;
  int married = 0;
  int workType = 0;
  int residenceType = 0;
  int smkoingType = 0;
  int age;
  int gender;
  double bmi;
  String riskMessage = '';

  List<RadioButton> hypertensionOptions = new List<RadioButton>();
  List<RadioButton> heartDiseaseOptions = new List<RadioButton>();
  List<RadioButton> marriedOptions = new List<RadioButton>();
  List<RadioButton> workTypeOptions = new List<RadioButton>();
  List<RadioButton> residenceTypeOptions = new List<RadioButton>();
  List<RadioButton> smkoingTypeOptions = new List<RadioButton>();

  _StrokeFormPageState() {
    hypertensionOptions
        .add(new RadioButton("Yes", null, false, Key('yesHypertension'), 0));
    hypertensionOptions
        .add(new RadioButton("No", null, false, Key('noHypertension'), 1));

    heartDiseaseOptions
        .add(new RadioButton("Yes", null, false, Key('yesHeartDisease'), 0));
    heartDiseaseOptions
        .add(new RadioButton("No", null, false, Key('noHeartDisease'), 1));

    marriedOptions
        .add(new RadioButton("Yes", null, false, Key('yesMarried'), 0));
    marriedOptions.add(new RadioButton("No", null, false, Key('noMarried'), 1));

    workTypeOptions
        .add(new RadioButton("Government Job", null, false, Key('govJob'), 0));
    workTypeOptions.add(
        new RadioButton("Never Worked", null, false, Key('neverWorked'), 1));
    workTypeOptions
        .add(new RadioButton("Private Sector", null, false, Key('privJob'), 2));
    workTypeOptions
        .add(new RadioButton("Self-Employed", null, false, Key('selfJob'), 3));
    workTypeOptions
        .add(new RadioButton("Children", null, false, Key('childJob'), 4));

    residenceTypeOptions
        .add(new RadioButton("Yes", null, false, Key('yesHypertension'), 0));
    residenceTypeOptions
        .add(new RadioButton("No", null, false, Key('noHypertension'), 1));

    smkoingTypeOptions
        .add(new RadioButton("Yes", null, false, Key('yesHypertension'), 0));
    smkoingTypeOptions
        .add(new RadioButton("No", null, false, Key('noHypertension'), 1));
  }

  void setAgeBMIGender() {
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
      gender = last["gender"] == "Male" ? 1 : 0;
    });
  }

  Future<String> predictStrokeProbability(var body) async {
    print(body);
    var client = new http.Client();
    var uri = Uri.parse("https://stroke-prediction-otu.herokuapp.com/predict");
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
    setAgeBMIGender();
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
              title: Text('Stroke Prediction Form',
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
                                  Container(
                                      height: 100,
                                      child: Column(
                                        children: [
                                          Text(
                                            'Do you have High Blood Pressure?',
                                            style: TextStyle(fontSize: 25),
                                          ),
                                          Expanded(
                                            child: new ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemCount:
                                                    hypertensionOptions.length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    key: Key("Hypertension"),
                                                    onTap: () {
                                                      setState(() {
                                                        hypertensionOptions
                                                            .forEach((type) =>
                                                                type.isSelected =
                                                                    false);
                                                        hypertensionOptions[
                                                                index]
                                                            .isSelected = true;
                                                        hypertension =
                                                            hypertensionOptions[
                                                                    index]
                                                                .val;
                                                      });
                                                    },
                                                    child: radio_button_cards(
                                                        hypertensionOptions[
                                                            index]),
                                                  );
                                                }),
                                          )
                                        ],
                                      )),
                                  Container(
                                      height: 100,
                                      child: Column(
                                        children: [
                                          Text(
                                            'Do you have Heart Disease?',
                                            style: TextStyle(fontSize: 25),
                                          ),
                                          Expanded(
                                            child: new ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemCount:
                                                    heartDiseaseOptions.length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    key: Key("HeartDisease"),
                                                    onTap: () {
                                                      setState(() {
                                                        heartDiseaseOptions
                                                            .forEach((type) =>
                                                                type.isSelected =
                                                                    false);
                                                        heartDiseaseOptions[
                                                                index]
                                                            .isSelected = true;
                                                        heartDisease =
                                                            heartDiseaseOptions[
                                                                    index]
                                                                .val;
                                                      });
                                                    },
                                                    child: radio_button_cards(
                                                        heartDiseaseOptions[
                                                            index]),
                                                  );
                                                }),
                                          )
                                        ],
                                      )),
                                  Container(
                                      height: 100,
                                      child: Column(
                                        children: [
                                          Text(
                                            'Have/Are you ever been Married?',
                                            style: TextStyle(fontSize: 25),
                                          ),
                                          Expanded(
                                            child: new ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemCount:
                                                    heartDiseaseOptions.length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    key: Key("Married"),
                                                    onTap: () {
                                                      setState(() {
                                                        marriedOptions.forEach(
                                                            (type) =>
                                                                type.isSelected =
                                                                    false);
                                                        marriedOptions[index]
                                                            .isSelected = true;
                                                        married =
                                                            marriedOptions[
                                                                    index]
                                                                .val;
                                                      });
                                                    },
                                                    child: radio_button_cards(
                                                        marriedOptions[index]),
                                                  );
                                                }),
                                          )
                                        ],
                                      )),
                                  Container(
                                      height: 125,
                                      child: Column(
                                        children: [
                                          Text(
                                            'Work Type',
                                            style: TextStyle(fontSize: 25),
                                          ),
                                          Expanded(
                                            child: new ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemCount:
                                                    workTypeOptions.length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    key: Key("WorkType"),
                                                    onTap: () {
                                                      setState(() {
                                                        workTypeOptions.forEach(
                                                            (type) =>
                                                                type.isSelected =
                                                                    false);
                                                        workTypeOptions[index]
                                                            .isSelected = true;
                                                        workType =
                                                            workTypeOptions[
                                                                    index]
                                                                .val;
                                                        print(workType);
                                                      });
                                                    },
                                                    child: radio_button_cards(
                                                        workTypeOptions[index]),
                                                  );
                                                }),
                                          )
                                        ],
                                      )),
                                  Container(
                                      height: 100,
                                      child: Column(
                                        children: [
                                          Text(
                                            'Residence Type',
                                            style: TextStyle(fontSize: 25),
                                          ),
                                          Expanded(
                                            child: new ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemCount:
                                                    residenceTypeOptions.length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    key: Key("ResidenceType"),
                                                    onTap: () {
                                                      setState(() {
                                                        residenceTypeOptions
                                                            .forEach((type) =>
                                                                type.isSelected =
                                                                    false);
                                                        residenceTypeOptions[
                                                                index]
                                                            .isSelected = true;
                                                        residenceType =
                                                            residenceTypeOptions[
                                                                    index]
                                                                .val;
                                                      });
                                                    },
                                                    child: radio_button_cards(
                                                        residenceTypeOptions[
                                                            index]),
                                                  );
                                                }),
                                          )
                                        ],
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
              "gender": gender,
              "age": age,
              "hypertension": hypertension,
              "heart disease": heartDisease,
              "married": married,
              "work type": workType,
              "residence type": residenceType,
              "glucose": glucose,
              "bmi": bmi,
              "smoking status": smkoingType,
            }
          ];
          var resp = await predictStrokeProbability(body);
          print(resp);
          setState(() {
            riskMessage = "Your risk of stroke is " + resp + "%";
          });
        },
        child: Text("Get Stroke Risk",
            style:
                TextStyle(color: Color.fromARGB(255, 83, 9, 49), fontSize: 20)),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 80),
          primary: Colors.pink.shade200,
        ));
  }
}
