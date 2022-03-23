import 'package:flutter/material.dart';
import 'package:health_assistant/charts/charts.dart';
import 'package:health_assistant/pages/health_page.dart';
import 'package:toggle_bar/toggle_bar.dart';

class ChartPage extends StatefulWidget {
  static const String id = 'chats_page';

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<String> labels = ['BMI', 'BODY FAT'];
  int counter = 0;

  Widget chartType(BuildContext context) {
    switch (counter) {
      case 0:
        return (bmi(context));
      case 1:
        return (bodyfat(context));
      default:
        return Container(color: Colors.transparent);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              title: Text(' Progression Charts',
                  style: TextStyle(color: Colors.pink.shade900)),
              leading: IconButton(
                key: Key('ChartBackButton'),
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
                    child: Column(children: [
                  Padding(padding: EdgeInsets.all(35)),
                  SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ToggleBar(
                            labels: labels,
                            backgroundColor: Colors.pink.shade200,
                            selectedTabColor: Colors.pink.shade700,
                            onSelectionUpdated: (index) {
                              setState(() {
                                counter = index;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          chartType(context),
                        ],
                      ),
                    ),
                  ),
                ])))
            //]))),
            // floatingActionButton: FloatingActionButton(
            //     onPressed: () {},
            //     backgroundColor: Colors.black,
            //     child: Icon(Icons.person_add_alt_1_rounded)),
            // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            ));
  }
}
