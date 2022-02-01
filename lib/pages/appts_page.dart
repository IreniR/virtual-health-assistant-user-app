import 'package:flutter/material.dart';
import 'package:health_assistant/pages/health_page.dart';
import 'package:health_assistant/widgets/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentsPage extends StatefulWidget {
  static const String id = 'appointments_page';

  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  TextEditingController _textEditingController;
  Map<DateTime, List<dynamic>> _events;
  // SharedPreferences prefs;

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};

    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });

    return newMap;
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};

    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });

    return newMap;
  }

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
            onPressed: () {
              _showScheduleDialog;
            },
            backgroundColor: Colors.black,
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ));
  }

  _showScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(controller: _textEditingController),
        actions: [
          TextButton(
            onPressed: () {
              if (_textEditingController.text.isEmpty) return;
              if (_events[CalendarController().selectedDay] != null) {
                _events[CalendarController().selectedDay]
                    .add(_textEditingController);
              } else {
                _events[CalendarController().selectedDay] = [
                  _textEditingController.text
                ];
              }
            },
            child: Text('Save Date'),
          )
        ],
      ),
    );
  }
}
