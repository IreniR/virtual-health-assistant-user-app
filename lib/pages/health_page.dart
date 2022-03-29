import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/cards/vital_cards.dart';
import 'package:health_assistant/pages/appts_page.dart';
import 'package:health_assistant/pages/chart_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:health_assistant/pages/settings_page.dart';
import 'package:health_assistant/charts/bmi_page.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class HealthPage extends StatefulWidget {
  static const String id = 'health_page';

  @override
  _HealthPageState createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  @override
  void initState() {
    getProfilePic();
    super.initState();
  }

  final realtimeDatabase = FirebaseDatabase.instance.reference();
  String email = FirebaseAuth.instance.currentUser.email.toString();
  DateTime now = new DateTime.now();

  String heartRate = "---";
  String oxygenLevel = "---";
  String bloodPressure = "---";

  String _urlProfile;

  Future<void> getProfilePic() async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection('images')
        .doc(FirebaseAuth.instance.currentUser.email)
        .get();

    Map<String, dynamic> data = docSnapshot.data();

    String photoURL = data['url'];

    setState(() {
      _urlProfile = photoURL;
    });
  }

  // BLE config
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothCharacteristic metricChar;
  BluetoothDevice bleDevice;
  Stream<List<int>> bleStream;

  getDevice() async {
    flutterBlue.startScan(timeout: Duration(seconds: 5));
    // ignore: cancel_subscriptions
    var subscription = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        if (r.device.name == "capstonepi") {
          print(r.device.name);
          bleDevice = r.device;
          bleDevice.connect();
          print(bleDevice);
          // print(bleDevice);
          print("test");
          flutterBlue.stopScan();
          break;
        }
      }
    });
  }

  // MQTT Config
  mqttPublish(message) async {
    final client = MqttServerClient('test.mosquitto.org', '');

    client.setProtocolV311();
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    final connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueID')
        .withWillTopic('willTopic')
        .withWillMessage('willMessage')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    client.connectionMessage = connMess;

    try {
      await client.connect();
    } on Exception catch (e) {
      print('Error, exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus.state == MqttConnectionState.connected) {
      print("Client connected");
    } else {
      print("Connection failed");
      client.disconnect();
    }

    const topic = "HRO2TRIGGER";
    // client.subscribe(topic, MqttQos.atLeastOnce);

    final messageBuilder = MqttClientPayloadBuilder();
    messageBuilder.addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, messageBuilder.payload);

    client.disconnect();
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
                  colors: [Colors.pink.shade300, Colors.deepOrange.shade200])),
          child: Column(children: [
            //Greet User Prompt
            Container(
              padding: EdgeInsets.only(top: 60, left: 25, right: 25),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: CircleAvatar(
                          key: Key('userAvatar'),
                          backgroundColor: Colors.transparent,
                          backgroundImage: ('$_urlProfile' == null)
                              ? null
                              : NetworkImage('$_urlProfile'),
                          radius: 40,
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.all(12),
                          alignment: Alignment.centerLeft,
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                      final allData =
                          snapshot.data.docs.map((doc) => doc.data()).toList();
                      allData.sort((a, b) {
                        var adate = (a as Map)["datetime"];
                        var bdate = (b as Map)["datetime"];
                        return adate.compareTo(bdate);
                      });
                      print(allData);
                      return HealthRiskCards(
                        key: Key('bmiCard'),
                        color: Colors.green.shade300,
                        title: Text('BMI',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        value: Text(
                            (allData.last as Map)["bmi"].toStringAsFixed(2),
                            // "16",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 45,
                                fontWeight: FontWeight.bold)),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
                GestureDetector(
                    onTap: () {
                      mqttPublish("hr");
                    },
                    child: streamBuilder(heartRate, "heartRate", "Heart Rate",
                        Colors.blue.shade200, Key('heartRate'))),
                GestureDetector(
                    onTap: () {
                      mqttPublish("ox");
                    },
                    child: streamBuilder(oxygenLevel, "o2sat", "Oxygen Level",
                        Color.fromARGB(255, 255, 179, 128), Key('oxygenLvl'))),
                // GestureDetector(
                // onTap: () {
                //   Random random = new Random();
                //   double generatedValue =
                //       random.nextDouble() * (100 - 45) + 45;

                //   setState(() {
                //     bloodPressure = generatedValue.toString().substring(0, 5);
                //   });
                // },
                BloodPressureCard(),
                // streamBuilderBLE(heartRate, "00000002-710e-4a5b-8d75-3e5b444bc3cf", "Heart Rate", Colors.blue.shade200),
                // streamBuilderBLE(oxygenLevel, "00000003-710e-4a5b-8d75-3e5b444bc3cf", "Oxygen Level", Color.fromARGB(255, 255, 179, 128))
                // )
              ]),
            ),
            SizedBox(
                height: 170,
                width: 400,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ChartPage()));
                  },
                  child: HealthSubCards(
                    color: Colors.pink.shade50,
                    // title: Text(
                    //   'Progress',
                    //   style: TextStyle(
                    //       color: Colors.black.withOpacity(0.5), fontSize: 25),
                    //   textAlign: TextAlign.center,
                    // ),
                    icon: Icon(
                      Icons.trending_up,
                      color: Color.fromARGB(255, 75, 8, 88).withOpacity(0.6),
                      size: 80,
                    ),
                  ),
                )),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AppointmentsPage()));
              },
              child: HealthSubCards(
                  color: Colors.orange.shade50,
                  // title: Text(
                  //   'Reminders',
                  //   style: TextStyle(
                  //       color: Colors.lime.shade900,
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  icon: Icon(
                    Icons.edit_calendar_sharp,
                    color: Colors.amber.shade900,
                    size: 80,
                  )),
            )
          ]),
        ))));
  }

  getCharacteristic(charUuid) async {
    final String SVC_UUID = "00000001-710e-4a5b-8d75-3e5b444bc3cf";
    // getDevice();
    flutterBlue.startScan(timeout: Duration(seconds: 5));
    // ignore: cancel_subscriptions
    var subscription = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        if (r.device.name == "capstonepi") {
          print(r.device.name);
          bleDevice = r.device;
          bleDevice.connect();
          print(bleDevice);
          // print(bleDevice);
          print("test");
          flutterBlue.stopScan();
          break;
        }
      }
    });

    // connectToDevice();]
    await Future.delayed(Duration(seconds: 3));

    print("get char");
    if (bleDevice != null) {
      List<BluetoothService> services = await bleDevice.discoverServices();
      // BluetoothService metricService;
      // BluetoothCharacteristic metricChar;

      services.forEach((service) {
        if (service.uuid.toString() == SVC_UUID) {
          print("service uuid");
          service.characteristics.forEach((characteristic) {
            if (characteristic.uuid.toString() == charUuid) {
              bleStream = characteristic.value;
              print(bleStream);
            }
          });
        }
      });
    }
  }

  Widget streamBuilderBLE(String metric, String charUuid, String textFormatting,
      Color widgetColor) {
    getCharacteristic(charUuid);

    return StreamBuilder(
        stream: bleStream,
        builder: (context, snapshot) {
          print("snapshot test");
          if (snapshot.hasData) {
            metric = snapshot.data.toString();
            return HealthRiskCards(
              color: widgetColor,
              title: Text(textFormatting,
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              value: Text(metric,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 60,
                      fontWeight: FontWeight.bold)),
            );
          }
          return CircularProgressIndicator();
        });
  }

  Widget streamBuilder(String metric, String dbReading, String textFormatting,
      Color widgetColour, Key key) {
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
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            value: Text(metric,
                style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 60,
                    fontWeight: FontWeight.bold)),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
