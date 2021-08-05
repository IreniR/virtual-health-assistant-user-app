import 'package:flutter/material.dart';
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

  void toggleAppt(bool value) {
    setState(() {
      _isToggledAppointments = value;
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
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text('Notifications'),
            leading: IconButton(
              icon: Icon(Icons.chevron_left_outlined,
                  size: 20, color: Colors.white),
              onPressed: () {
                Navigator.pop(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            ),
          ),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              NotificationSwitch(
                title: Text('Appointment Reminders',
                    style: TextStyle(color: Colors.black, fontSize: 20)),
                initialValue: _isToggledAppointments,
                switchValue: toggleAppt,
              ),
              NotificationSwitch(
                title: Text('Medication Reminders',
                    style: TextStyle(color: Colors.black, fontSize: 20)),
                initialValue: _isToggledMedication,
                switchValue: toggleMed,
              ),
              NotificationSwitch(
                title: Text('Chat Messages',
                    style: TextStyle(color: Colors.black, fontSize: 20)),
                initialValue: _isToggledChat,
                switchValue: toggleChat,
              ),
              NotificationSwitch(
                title: Text('Exercise Reminders',
                    style: TextStyle(color: Colors.black, fontSize: 20)),
                initialValue: _isToggledExercise,
                switchValue: toggleExercise,
              ),
            ],
          ),
        ));
  }
}
