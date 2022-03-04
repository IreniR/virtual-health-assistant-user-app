import 'package:flutter/material.dart';
import 'package:health_assistant/charts/charts.dart';
import 'package:health_assistant/chat/messaging.dart';
import 'package:health_assistant/pages/health_page.dart';
import 'package:health_assistant/widgets/appbar.dart';
import 'package:toggle_bar/toggle_bar.dart';

class ChartPage extends StatefulWidget {
  static const String id = 'chats_page';

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<String> labels = ['BMI', 'BODY FAT'];
  int counter = 0;

  Widget chatType(BuildContext context) {
    switch (counter) {
      case 0:
        return (bmi(context));
      case 1:
        return (messageDoctor(context));
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
          appBar: BaseAppBar(
            title: Text('Charts'),
            appBar: AppBar(
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
                    chatType(context),
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
