import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final Text title;
  final List<Widget> widgets;

  const ActivityCard({Key key, @required this.title, this.widgets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 4,
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
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
      ),
    );
  }
}
