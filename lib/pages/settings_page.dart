import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/cards/settings_cards.dart';
import 'package:health_assistant/pages/about_page.dart';
import 'package:health_assistant/pages/login_page.dart';
import 'package:health_assistant/pages/notifications.dart';
import 'package:health_assistant/widgets/appbar.dart';

final userRef = FirebaseFirestore.instance.collection('Users');
final String docId = userRef.id; //Collection name gets printed

class SettingsPage extends StatefulWidget {
  static const String id = 'settings_page';
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() {
    StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot val = snapshot.data.docs[index];
                return ListTile(
                  title: Text(val['Name']),
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          appBar: BaseAppBar(title: Text('Settings'), appBar: AppBar()),
          body: Container(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'Users name',
                            //'${usersName.text}',
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  SettingsCards(
                      title: Text('Notification Settings',
                          style: TextStyle(fontSize: 20)),
                      icon: Icon(Icons.chevron_right_outlined,
                          color: Colors.black),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationPage()));
                      }),
                  SizedBox(height: 5),
                  SettingsCards(
                      title: Text('About', style: TextStyle(fontSize: 20)),
                      icon: Icon(Icons.chevron_right_outlined,
                          color: Colors.black),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutPage()));
                      }),
                  SizedBox(height: 5),
                  SettingsCards(
                      title: Text('Log Out', style: TextStyle(fontSize: 20)),
                      icon: Icon(Icons.logout, color: Colors.black),
                      onTap: () {
                        _showDialog();
                      }),
                ],
              ),
            ),
          ),
          backgroundColor: Colors.white,
        ));
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logout'),
            content: Text('Verify Logout'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: Text('Confirm'),
                  onPressed: () {
                    //Firebase Integration
                    FirebaseAuth.instance.signOut();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  }),
            ],
          );
        });
  }
}
