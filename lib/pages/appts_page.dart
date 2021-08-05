import 'package:flutter/material.dart';
import 'package:health_assistant/pages/health_page.dart';
import 'package:health_assistant/widgets/calendar.dart';

class AppointmentsPage extends StatefulWidget {
  static const String id = 'appointments_page';

  @override
  _AppointmentsPage createState() => _AppointmentsPage();
}

class _AppointmentsPage extends State<AppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text('Schedule'),
            leading: IconButton(
              icon: Icon(Icons.chevron_left_outlined,
                  size: 20, color: Colors.white),
              onPressed: () {
                Navigator.pop(context,
                    MaterialPageRoute(builder: (context) => HealthPage()));
              },
            ),
          ),
          body: Column(
            children: [
              Calendar(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.black,
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ));
  }
}
