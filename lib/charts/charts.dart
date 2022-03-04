import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

String email = FirebaseAuth.instance.currentUser.email.toString();
@override
Widget bmi(BuildContext context) {
  CollectionReference dates = FirebaseFirestore.instance
      .collection('User Details')
      .doc(email)
      .collection("dates");

  return WillPopScope(
    onWillPop: () {
      return Future.value(false);
    },
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Align(
            alignment: FractionalOffset.bottomRight,
            child: FutureBuilder<QuerySnapshot>(
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
                  return makePlot(allData);
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ),
      ],
    ),
  );
}

Widget makePlot(List allData) {
  List<ChartData> chartData = <ChartData>[];
  for (var i = 0; i < allData.length; i++) {
    var map = allData[i] as Map;
    chartData
        .add(new ChartData(map["datetime"].toDate(), map["bmi"].toDouble()));
  }

  return Container(
      child: Center(
          child: Container(
              child: SfCartesianChart(
                  primaryXAxis: DateTimeAxis(
                      //Specified date time interval type in hours
                      intervalType: DateTimeIntervalType.days),
                  series: <ChartSeries<ChartData, DateTime>>[
        LineSeries<ChartData, DateTime>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y)
      ]))));
}

class ChartData {
  final DateTime time;
  final double bmi;

  ChartData(this.time, this.bmi);

  get x => this.time;
  get y => this.bmi;
}
