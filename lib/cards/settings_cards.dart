import 'package:flutter/material.dart';

class SettingsCards extends StatelessWidget {
  final Text title;
  final List<Widget> widgets;
  final VoidCallback onTap;
  final Icon icon;

  const SettingsCards(
      {Key key, this.title, this.widgets, this.onTap, @required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            title,
            InkWell(
              onTap: onTap,
              child: icon,
            ),
          ],
        ),
      ),
    );
  }
}
