import 'package:flutter/material.dart';

class NotificationSwitch extends StatelessWidget {
  final Text title;
  final bool initialValue;
  final void Function(bool) switchValue;

  NotificationSwitch({Key key, this.title, this.initialValue, this.switchValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: SwitchListTile(
        value: initialValue,
        title: title,
        activeColor: Colors.pink.shade900,
        inactiveTrackColor: Colors.grey,
        onChanged: switchValue,
      ),
    );
  }
}
