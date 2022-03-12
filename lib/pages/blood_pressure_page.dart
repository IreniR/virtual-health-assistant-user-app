import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'measure_page.dart';

class BloodPressurePage extends StatefulWidget {
  static const String id = 'blood_pressure_page';

  @override
  _BloodPressurePageState createState() => _BloodPressurePageState();
}

class _BloodPressurePageState extends State<BloodPressurePage> {
  @override
  Widget build(BuildContext context) {
    double doubleInRange(Random source, num start, num end) =>
        source.nextDouble() * (end - start) + start;

    Random random = new Random();
    double blood_pressure = random.nextDouble() * (100 - 45) + 45;

    return Container(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text('Blood Pressure'),
              leading: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => MeasurePage()));
                },
              ),
            ),
            body: Text(
              'Your Blood Pressure is: ' +
                  blood_pressure.toString().substring(0, 5),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            )));
  }
}
