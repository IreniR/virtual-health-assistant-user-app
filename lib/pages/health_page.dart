import 'package:flutter/material.dart';
import 'package:health_assistant/cards/vital_cards.dart';
import 'package:health_assistant/pages/appts_page.dart';
import 'package:health_assistant/pages/prescriptions_page.dart';
import 'package:health_assistant/widgets/appbar.dart';

class HealthPage extends StatefulWidget {
  static const String id = 'health_page';

  @override
  _HealthPageState createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
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
                    HealthRiskCards(
                        title: Text('Blood Pressure',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20))),
                    HealthRiskCards(
                        title: Text('Heart Rate',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20))),
                    HealthRiskCards(
                        title: Text('Blood Sugar',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20))),
                    HealthRiskCards(
                        title: Text('Cholestrol',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20))),
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
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
