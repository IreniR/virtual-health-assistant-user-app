import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/cards/settings_cards.dart';
import 'package:health_assistant/pages/about_page.dart';
import 'package:health_assistant/pages/login_page.dart';
import 'package:health_assistant/pages/notifications.dart';

final userRef = FirebaseFirestore.instance.collection('Users');
final String docId = userRef.id; //Collection name gets printed
final FirebaseAuth auth = FirebaseAuth.instance;

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
                  Card(
                    color: Colors.transparent,
                    elevation: 0,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            backgroundImage:
                                NetworkImage('https://via.placeholder.com/150'),
                            radius: 70,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            auth.currentUser.email,
                            //'${usersName.text}',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink.shade900),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  SettingsCards(
                      title: Text('Account',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.pink.shade900,
                              fontWeight: FontWeight.bold)),
                      icon: Icon(Icons.chevron_right_outlined,
                          color: Colors.pink.shade900),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationPage()));
                      }),
                  SizedBox(height: 5),
                  SettingsCards(
                      title: Text('Notification Settings',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.pink.shade900,
                              fontWeight: FontWeight.bold)),
                      icon: Icon(Icons.chevron_right_outlined,
                          color: Colors.pink.shade900),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationPage()));
                      }),
                  SizedBox(height: 5),
                  SettingsCards(
                      title: Text('Progress',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.pink.shade900,
                              fontWeight: FontWeight.bold)),
                      icon: Icon(Icons.chevron_right_outlined,
                          color: Colors.pink.shade900),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationPage()));
                      }),
                  SizedBox(height: 5),
                  SettingsCards(
                      title: Text('About',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.pink.shade900,
                              fontWeight: FontWeight.bold)),
                      icon: Icon(Icons.chevron_right_outlined,
                          color: Colors.pink.shade900),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutPage()));
                      }),
                  SizedBox(height: 5),
                  SettingsCards(
                      title: Text('Privacy Policy',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.pink.shade900,
                              fontWeight: FontWeight.bold)),
                      icon: Icon(Icons.chevron_right_outlined,
                          color: Colors.pink.shade900),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutPage()));
                      }),
                  SizedBox(height: 25),
                  Padding(
                      padding: EdgeInsets.only(left: 100, right: 100),
                      child: ElevatedButton(
                        onPressed: _showDialog,
                        style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            primary: Colors.transparent,
                            shadowColor: Colors.transparent),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.pink.shade400,
                                  Colors.pink.shade200
                                ]),
                            borderRadius:
                                BorderRadius.all(Radius.circular(80.0)),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(15),
                            constraints: const BoxConstraints(
                                minWidth: 30, minHeight: 40),
                            alignment: Alignment.center,
                            child: const Text(
                              'Log Out',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
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
