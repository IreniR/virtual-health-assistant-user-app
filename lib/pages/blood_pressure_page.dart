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
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('Blood Pressure',
                  style: TextStyle(color: Colors.pink.shade900)),
              leading: IconButton(
                key: Key('BloodPressureButton'),
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
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Column(children: [
                      Padding(padding: EdgeInsets.only(top: 200)),
                      Text(
                        'Your Blood Pressure is: ' +
                            blood_pressure.toString().substring(0, 5),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.pink.shade900,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      )
                    ])))));
  }
}
