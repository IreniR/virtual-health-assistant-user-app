import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:health_assistant/model/event_model.dart';
import 'package:health_assistant/pages/settings_page.dart';
import 'package:health_assistant/widgets/notification_tiles.dart';

class NotificationPage extends StatefulWidget {
  static const String id = 'notifications_page';

  @override
  _NotificationPage createState() => _NotificationPage();
}

class _NotificationPage extends State<NotificationPage> {
  bool _isToggledAppointments = false;
  bool _isToggledChat = false;
  bool _isToggledMedication = false;
  bool _isToggledExercise = false;

  EventModel eventModel;

  void toggleAppt(bool value) {
    setState(() async {
      _isToggledAppointments = value;

      if (value == true) {
        await FlutterLocalNotificationsPlugin().cancelAll();
      }
    });
  }

  void toggleChat(bool value) {
    setState(() {
      _isToggledChat = value;
    });
  }

  void toggleMed(bool value) {
    setState(() {
      _isToggledMedication = value;
    });
  }

  void toggleExercise(bool value) {
    setState(() {
      _isToggledExercise = value;
    });
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
              title: Text('Notification Settings',
                  style: TextStyle(color: Colors.pink.shade900)),
              leading: IconButton(
                key: Key('NotificationButton'),
                icon: Icon(
                  Icons.chevron_left,
                  color: Colors.pink.shade900,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => SettingsPage()));
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
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 70)),
                      Padding(
                          padding: EdgeInsets.only(top: 10, left: 5, right: 5)),
                      NotificationSwitch(
                        title: Text('Silence Reminders',
                            style: TextStyle(
                                color: Colors.pink.shade900, fontSize: 20)),
                        initialValue: _isToggledAppointments,
                        switchValue: toggleAppt,
                      ),
                    ],
                  ),
                ))));
  }
}
