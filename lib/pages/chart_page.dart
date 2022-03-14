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
          appBar: AppBar(
            backgroundColor: Colors.pink,
            title: Text('Charts'),
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context,
                    MaterialPageRoute(builder: (context) => HealthPage()));
              },
            ),
          ),
          body: Container(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ToggleBar(
                      labels: labels,
                      backgroundColor: Colors.black,
                      selectedTabColor: Colors.red,
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
          ),
          // floatingActionButton: FloatingActionButton(
          //     onPressed: () {},
          //     backgroundColor: Colors.black,
          //     child: Icon(Icons.person_add_alt_1_rounded)),
          // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ));
  }
}
