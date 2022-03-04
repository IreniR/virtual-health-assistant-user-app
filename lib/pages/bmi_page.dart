import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:health_assistant/pages/health_page.dart';

class BMIPage extends StatefulWidget {
  static const String id = 'bmi_page';

  @override
  _BMIPageState createState() => _BMIPageState();
}

class _BMIPageState extends State<BMIPage> {
  String email = FirebaseAuth.instance.currentUser.email.toString();
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
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('BMI', style: TextStyle(color: Colors.pink.shade900)),
              leading: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: Colors.pink.shade900,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => HealthPage()));
                },
              ),
            ),
            body: Form(
              child: Center(
                child: Container(
                  height: 450,
                  child: GridView.count(crossAxisCount: 2, children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => BMIPage()));
                      },
                      child: FutureBuilder<QuerySnapshot>(
                        future: dates.get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text("Something went wrong");
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            final allData = snapshot.data.docs
                                .map((doc) => doc.data())
                                .toList();
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
                  ]),
                ),
              ),
            )));
  }

  Widget makePlot(List allData) {
    return Container();
  }
}
