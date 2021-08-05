import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/pages/chat_page.dart';
import 'package:health_assistant/pages/fitness_page.dart';
import 'package:health_assistant/pages/health_page.dart';
import 'package:health_assistant/pages/settings_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key key, this.user}) : super(key: key);
  final UserCredential user;

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationPage> {
  int _selectedIndex = 0;
  final _pageList = [
    HealthPage(),
    FitnessPage(),
    ChatPage(),
    SettingsPage(),
  ];

  void _onTapped(int i) {
    setState(() {
      _selectedIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.healing_outlined),
            label: 'Health',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Fitness',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.redAccent,
        onTap: _onTapped,
      ),
    );
  }
}
