import 'package:flutter/material.dart';
import 'package:health_assistant/utils/Gender.dart';

class radio_button_cards extends StatelessWidget {
  RadioButton _radio_button;

  radio_button_cards(this._radio_button);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _radio_button.isSelected ? Colors.cyan : Colors.white,
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
              _radio_button.icon,
              color: _radio_button.isSelected ? Colors.white : Colors.black,
              size: 40,
            ),
            SizedBox(height: 10),
            Text(
              _radio_button.name,
              style: TextStyle(
                  color:
                      _radio_button.isSelected ? Colors.white : Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
