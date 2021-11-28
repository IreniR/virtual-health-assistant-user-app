import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/cards/vital_cards.dart';
import 'package:health_assistant/pages/appts_page.dart';
import 'package:health_assistant/pages/prescriptions_page.dart';
import 'package:health_assistant/widgets/appbar.dart';
import 'package:firebase_database/firebase_database.dart';

class HealthPage extends StatefulWidget {
  static const String id = 'health_page';

  @override
  _HealthPageState createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  final RealtimeDatabase = FirebaseDatabase.instance.reference();
  CollectionReference users =
      FirebaseFirestore.instance.collection('User Details');
  String email = FirebaseAuth.instance.currentUser.email.toString();

  String heartRate;
  String oxygenLevel;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: BaseAppBar(title: Text('Health'), appBar: AppBar()),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  height: 200,
                  child: ListView(scrollDirection: Axis.horizontal, children: [
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
                            title: Text('BMI',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            value: Text(data["bmi"].toStringAsFixed(2),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 60)),
                          );
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                    streamBuilder(heartRate, "heartRate", "Heart Rate"),
                    streamBuilder(oxygenLevel, "o2sat", "Oxygen Level")
                  ]),
                ),
                HealthSubCards(
                    title: Text('Prescriptions',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrescriptionPage()));
                    }),
                HealthSubCards(
                    title: Text(
                      'Appointments and Medication Schedule',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AppointmentsPage()));
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget streamBuilder(String metric, String dbReading, String textFormatting) {
    return StreamBuilder(
      stream: RealtimeDatabase.child('measurements/2: Push').onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = Map<String, dynamic>.from(
              (snapshot.data as Event).snapshot.value);
          var latestDate = DateTime.parse("2021-01-21 12:00:00");
          DateTime currentDate;
          data.forEach((key, value) => {
                currentDate = DateTime.parse(data[key]["timestamp"]),
                if (currentDate.isAfter(latestDate))
                  {
                    latestDate = currentDate,
                    metric = data[key][dbReading].toString()
                  }
              });
          return HealthRiskCards(
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
