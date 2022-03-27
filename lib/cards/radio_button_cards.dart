import 'package:flutter/material.dart';
import 'package:health_assistant/utils/Gender.dart';

class radio_button_cards extends StatelessWidget {
  RadioButton _radio_button;

  radio_button_cards(this._radio_button);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _radio_button.isSelected
          ? Color.fromARGB(255, 212, 0, 106)
          : Color.fromARGB(255, 247, 217, 229),
      child: Container(
        height: 80,
        width: 80,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              _radio_button.icon,
              color: _radio_button.isSelected
                  ? Color.fromARGB(255, 252, 252, 252)
                  : Colors.black,
              size: 25,
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                  _radio_button.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: _radio_button.isSelected
                          ? Colors.white
                          : Colors.black),
                ))
          ],
        ),
      ),
    );
  }
}
