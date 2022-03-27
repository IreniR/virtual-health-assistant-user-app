import 'package:flutter/material.dart';
import 'package:health_assistant/cards/vital_cards.dart';
import 'package:health_assistant/pages/body_fat_form_page.dart';
import 'package:health_assistant/pages/diabetes_form_page.dart';
import 'package:health_assistant/pages/health_page.dart';
import 'package:health_assistant/pages/stroke_form_page.dart';

import 'blood_pressure_page.dart';

class MeasurePage extends StatefulWidget {
  static const String id = 'measure_page';

  @override
  _MeasurePageState createState() => _MeasurePageState();
}

class _MeasurePageState extends State<MeasurePage> {
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              // height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.pink.shade400, Colors.amber.shade100])),
              child: Container(
                child: Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        padding: EdgeInsets.only(top: 40, left: 25),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Measure',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35,
                                  color: Colors.green.shade50),
                            ))),
                    Container(
                        height: MediaQuery.of(context).size.height + 300,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.pink.shade50,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25))),
                          child: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(left: 25, top: 25),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Record Metrics',
                                        style: TextStyle(
                                            color: Colors.pink.shade900,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ))),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: 15, bottom: 15, right: 25, left: 25),
                                  child: Divider(
                                      color: Colors.pink.shade200,
                                      thickness: 2)),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DiabetesFormPage()));
                                  },
                                  child: HealthSubCards(
                                    color: Colors.green.shade200,
                                    title: Text('Diabetes',
                                        style: TextStyle(
                                            color: Colors.green.shade900,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text(
                                        'Chronic (long-lasting) health condition that affects how your body turns food into energy.',
                                        style: TextStyle(
                                          color: Colors.green.shade900,
                                          fontSize: 13,
                                        )),
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StrokeFormPage()));
                                  },
                                  child: HealthSubCards(
                                    color: Colors.cyan.shade200,
                                    title: Text('Stroke',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 33, 78, 146),
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text(
                                        'A disease that affects the arteries leading to and within the brain. The interrupted blood flow causes damage to your brain.',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 33, 78, 146),
                                          fontSize: 13,
                                        )),
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BodyFatFormPage()));
                                  },
                                  child: HealthSubCards(
                                    color: Colors.pink.shade200,
                                    title: Text(
                                      'Body Fat',
                                      style: TextStyle(
                                          color: Colors.pink.shade900,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                        "The percentage of a your body that is not composed of water, muscle, bone, and vital organs",
                                        style: TextStyle(
                                          color: Colors.pink.shade900,
                                          fontSize: 13,
                                        )),
                                  )),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
