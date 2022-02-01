import 'package:flutter/material.dart';

class HealthSubCards extends StatelessWidget {
  final Text title;
  final Text subtitle;
  final Color color;
  final List<Widget> widgets;
  final Icon icon;

  const HealthSubCards(
      {Key key,
      @required this.title,
      this.subtitle,
      this.widgets,
      this.color,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 4,
      child: Padding(
        padding: EdgeInsets.only(left: 5, right: 5, bottom: 10),
        child: Card(
          elevation: 15,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          color: color,
          child: Container(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15, left: 15),
                    child: title,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(padding: EdgeInsets.all(20), child: icon),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, left: 15, right: 5),
                  child: subtitle,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HealthRiskCards extends StatelessWidget {
  final Text title;
  final Text value;
  final List<Widget> widgets;
  final VoidCallback onTap;
  final Color color;

  const HealthRiskCards(
      {Key key,
      @required this.title,
      this.value,
      this.widgets,
      this.onTap,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: Padding(
        padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          color: color,
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  title,
                  value,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
