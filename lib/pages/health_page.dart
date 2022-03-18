import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/cards/vital_cards.dart';
import 'package:health_assistant/pages/appts_page.dart';
import 'package:health_assistant/pages/chart_page.dart';
import 'package:health_assistant/pages/prescriptions_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:health_assistant/pages/settings_page.dart';
import 'package:health_assistant/charts/bmi_page.dart';
import 'package:flutter_blue/flutter_blue.dart';

class HealthPage extends StatefulWidget {
  static const String id = 'health_page';

  @override
  _HealthPageState createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  final realtimeDatabase = FirebaseDatabase.instance.reference();
  String email = FirebaseAuth.instance.currentUser.email.toString();

  // BLE config
  FlutterBlue flutterBlue = FlutterBlue.instance;

  String heartRate = "---";
  String oxygenLevel = "---";
  String bloodPressure = "---";

  DateTime now = new DateTime.now();

  getDevice() async {
    flutterBlue.startScan(timeout: Duration(seconds: 5));
    flutterBlue.connectedDevices.asStream().listen((List<BluetoothDevice> devices) async {
      for (BluetoothDevice device in devices) {
        if (device.name == "capstonepi") {
          await device.connect();
          flutterBlue.stopScan();
          return device;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference dates = FirebaseFirestore.instance
        .collection('User Details')
        .doc(email)
        .collection("dates");

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
                    FutureBuilder<QuerySnapshot>(
                      future: dates.get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text("Something went wrong");
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          final allData = snapshot.data.docs
                              .map((doc) => doc.data())
                              .toList();
                          allData.sort((a, b) {
                            var adate = (a as Map)["datetime"];
                            var bdate = (b as Map)["datetime"];
                            return adate.compareTo(bdate);
                          });
                          print(allData);
                          return HealthRiskCards(
                            color: Colors.green.shade300,
                            title: Text('BMI',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            value: Text(
                                (allData.last as Map)["bmi"].toStringAsFixed(2),
                                // "16",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 50)),
                          );
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                    streamBuilder(heartRate, "heartRate", "Heart Rate", Colors.blue.shade200),
                    streamBuilder(oxygenLevel, "o2sat", "Oxygen Level", Color.fromARGB(255, 255, 179, 128)),
                    streamBuilder(bloodPressure, "bloodPressure", "Blood Pressure", Color.fromARGB(255, 200, 147, 216)),
                    // streamBuilderBLE(heartRate, "00000002-710e-4a5b-8d75-3e5b444bc3cf", "Heart Rate"),
                    // streamBuilderBLE(oxygenLevel, "00000003-710e-4a5b-8d75-3e5b444bc3cf", "Oxygen Level")
                  ]),
                ),
                SizedBox(
                    height: 300,
                    width: 400,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChartPage()));
                      },
                      child: HealthSubCards(
                        color: Colors.pink.shade50,
                        title: Text(
                          'Progress',
                          style: TextStyle(color: Colors.black, fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                        icon: Icon(
                          Icons.trending_up,
                          color: Colors.deepPurple.shade900,
                          size: 120,
                        ),
                      ),
                    )),
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

  Widget streamBuilderBLE(String metric, String charUuid, String textFormatting) {
    final String SVC_UUID = "00000001-710e-4a5b-8d75-3e5b444bc3cf";
    final device = getDevice();

    BluetoothService metricService;
    List<BluetoothService> services = device.discoverServices();
    services.forEach((service) {
      if (service.uuid == Guid(SVC_UUID)) {
        metricService = service;
      }
    });

    BluetoothCharacteristic metricChar;
    List<BluetoothCharacteristic> characteristics = metricService.characteristics;
    characteristics.forEach((char) {
      if (char.uuid == Guid(charUuid)) {
        metricChar = char;
      }
    });

    return StreamBuilder(
      stream: metricChar.value,
      builder: (context, snapshot) {
        return HealthRiskCards(
          color: Colors.blue.shade200,
          title: Text(textFormatting,
              style: TextStyle(color: Colors.white, fontSize: 20)),
          value: Text(metric,
              style: TextStyle(color: Colors.white, fontSize: 60)),
        );
      }
    );
  }

  Widget streamBuilder(String metric, String dbReading, String textFormatting, Color widgetColour) {
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
            color: widgetColour,
            title: Text(textFormatting,
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16)),
            value: Text(metric,
                style: TextStyle(color: Colors.white, fontSize: 60)),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
