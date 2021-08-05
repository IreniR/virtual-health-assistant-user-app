import 'package:flutter/material.dart';
import 'package:health_assistant/cards/fitness_cards.dart';
import 'package:health_assistant/widgets/appbar.dart';

class FitnessPage extends StatefulWidget {
  static const String id = 'fitness_page';

  @override
  _FitnessPageState createState() => _FitnessPageState();
}

class _FitnessPageState extends State<FitnessPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: BaseAppBar(title: Text('Fitness'), appBar: AppBar()),
        body: Column(
          children: [
            ActivityCard(
              title: Text('Pedometer', style: TextStyle(color: Colors.white)),
            ),
            ActivityCard(
              title: Text('Calories Burned',
                  style: TextStyle(color: Colors.white)),
            ),
            ActivityCard(
              title: Text('Activity Circle / Goals',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
