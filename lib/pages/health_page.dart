import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/cards/vital_cards.dart';
import 'package:health_assistant/pages/appts_page.dart';
import 'package:health_assistant/pages/prescriptions_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:health_assistant/pages/settings_page.dart';

class HealthPage extends StatefulWidget {
  static const String id = 'health_page';

  @override
  _HealthPageState createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  final realtimeDatabase = FirebaseDatabase.instance.reference();
  CollectionReference users =
      FirebaseFirestore.instance.collection('User Details');
  String email = FirebaseAuth.instance.currentUser.email.toString();

  String heartRate = "---";
  String oxygenLevel = "---";
  String bloodPressure = "---";

  DateTime now = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
            body: SingleChildScrollView(
          child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Colors.pink.shade300,
                    Colors.deepOrange.shade200
                  ])),
              child: Column(children: [
                //Greet User Prompt
                Container(
                  padding: EdgeInsets.only(top: 25, left: 25, right: 25),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 20, left: 15),
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              backgroundImage: NetworkImage(
                                  'https://via.placeholder.com/150'),
                              radius: 45,
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.all(12),
                              alignment: Alignment.centerLeft,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Hello, ",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        auth.currentUser.email + "!",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )
                                    ],
                                  )))
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 450,
                  child: GridView.count(crossAxisCount: 2, children: [
                    FutureBuilder<DocumentSnapshot>(
                      future: users.doc(email).get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text("Something went wrong");
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data = snapshot.data.data();
                          return HealthRiskCards(
                            color: Colors.green.shade300,
                            title: Text('BMI',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            value: Text(data["bmi"].toStringAsFixed(2),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 50)),
                          );
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                    streamBuilder(heartRate, "heartRate", "Heart Rate"),
                    streamBuilder(oxygenLevel, "o2sat", "Oxygen Level"),
                    streamBuilder(
                        bloodPressure, "bloodPressure", "Blood Pressure")
                  ]),
                ),
                SizedBox(
                  height: 300,
                  width: 400,
                  child: Card(
                      color: Colors.pink.shade50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: Container(
                          child: Padding(
                              padding: EdgeInsets.all(25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                              )))),
                ),
                SizedBox(
                  height: 250,
                  child: GridView.count(crossAxisCount: 2, children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrescriptionPage()));
                      },
                      child: HealthSubCards(
                          color: Colors.purple.shade50,
                          // title: Text('Prescriptions',
                          //     style: TextStyle(
                          //         color: Colors.purple.shade900,
                          //         fontSize: 20,
                          //         fontWeight: FontWeight.bold)),
                          icon: Icon(
                            Icons.medical_services_outlined,
                            color: Colors.deepPurple.shade900,
                            size: 120,
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppointmentsPage()));
                      },
                      child: HealthSubCards(
                          color: Colors.lime.shade50,
                          // title: Text(
                          //   'Reminders',
                          //   style: TextStyle(
                          //       color: Colors.lime.shade900,
                          //       fontSize: 20,
                          //       fontWeight: FontWeight.bold),
                          // ),
                          icon: Icon(
                            Icons.calendar_today,
                            color: Colors.amber.shade900,
                            size: 120,
                          )),
                    )
                  ]),
                )
              ])),
        )));
  }

  Widget streamBuilder(String metric, String dbReading, String textFormatting) {
    return StreamBuilder(
      stream: realtimeDatabase.child('measurements/2: Push').onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = Map<String, dynamic>.from(
              (snapshot.data as Event).snapshot.value);
          var latestDate = DateTime.parse("2021-01-21 12:00:00");
          DateTime currentDate;
          data.forEach((key, value) => {
                currentDate = DateTime.parse(data[key]["timestamp"]),
                if (currentDate.isAfter(now) && currentDate.isAfter(latestDate))
                  {
                    latestDate = currentDate,
                    metric = data[key][dbReading].toString()
                  }
              });
          return HealthRiskCards(
            color: Colors.blue.shade200,
            title: Text(textFormatting,
                style: TextStyle(color: Colors.white, fontSize: 20)),
            value: Text(metric,
                style: TextStyle(color: Colors.white, fontSize: 60)),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
