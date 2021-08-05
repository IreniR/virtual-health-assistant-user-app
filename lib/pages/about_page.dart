import 'package:flutter/material.dart';
import 'package:health_assistant/pages/settings_page.dart';

class AboutPage extends StatefulWidget {
  static const String id = 'about_page';

  @override
  _AboutPage createState() => _AboutPage();
}

class _AboutPage extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text('About'),
            leading: IconButton(
              icon: Icon(Icons.chevron_left_outlined,
                  size: 20, color: Colors.white),
              onPressed: () {
                Navigator.pop(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            ),
          ),
        ));
  }
}
