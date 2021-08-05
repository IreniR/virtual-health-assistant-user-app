import 'package:flutter/material.dart';

class HealthSubCards extends StatelessWidget {
  final Text title;
  final Text subtitle;
  final List<Widget> widgets;
  final VoidCallback onTap;

  const HealthSubCards(
      {Key key, @required this.title, this.subtitle, this.widgets, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 4,
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Card(
          elevation: 15,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          color: Colors.black,
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: title),
                  InkWell(
                    onTap: onTap,
                    child: Icon(
                      Icons.chevron_right_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HealthRiskCards extends StatelessWidget {
  final Text title;
  final List<Widget> widgets;
  final VoidCallback onTap;

  const HealthRiskCards(
      {Key key, @required this.title, this.widgets, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 100,
      child: Padding(
        padding: EdgeInsets.only(left: 16),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          color: Colors.black,
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  title,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
