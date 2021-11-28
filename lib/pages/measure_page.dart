import 'package:flutter/material.dart';
import 'package:health_assistant/cards/vital_cards.dart';
import 'package:health_assistant/pages/diabetes_form_page.dart';
import 'package:health_assistant/pages/health_page.dart';
import 'package:health_assistant/widgets/appbar.dart';

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
        appBar: BaseAppBar(title: Text('Measure'), appBar: AppBar()),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                HealthSubCards(
                    title: Text('Diabetes',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DiabetesFormPage()));
                    }),
                HealthSubCards(
                    title: Text(
                      'Stroke',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HealthPage()));
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
