import 'package:flutter/material.dart';
import 'package:health_assistant/utils/Gender.dart';

class gender_cards extends StatelessWidget {
  Gender _gender;

  gender_cards(this._gender);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _gender.isSelected ? Colors.cyan : Colors.white,
      child: Container(
        height: 80,
        width: 80,
        alignment: Alignment.center,
        margin: new EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              _gender.icon,
              color: _gender.isSelected ? Colors.white : Colors.black,
              size: 40,
            ),
            SizedBox(height: 10),
            Text(
              _gender.name,
              style: TextStyle(
                  color: _gender.isSelected ? Colors.white : Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
