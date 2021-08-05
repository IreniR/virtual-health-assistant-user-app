import 'package:flutter/material.dart';
import 'package:health_assistant/pages/settings_page.dart';

class ProfilePage extends StatefulWidget {
  static const String id = 'profile_page';

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text('Profile'),
            leading: IconButton(
              icon: Icon(Icons.chevron_left_outlined,
                  size: 20, color: Colors.white),
              onPressed: () {
                Navigator.pop(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            ),
          ),
          body: Column(
            children: <Widget>[
              // FutureBuilder(
              //   future: Provider.of(context).auth.,
              // )
            ],
          ),
        ));
  }
}
