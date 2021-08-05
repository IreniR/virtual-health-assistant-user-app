import 'package:flutter/material.dart';

Widget messageDoctor(BuildContext context) {
  return WillPopScope(
    onWillPop: () {
      return Future.value(false);
    },
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Align(
            alignment: FractionalOffset.bottomRight,
            child: ElevatedButton(
              onPressed: () {},
              child: Icon(Icons.person_add_alt_1),
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                  onPrimary: Colors.white,
                  primary: Colors.black,
                  elevation: 15),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget messageChatBox(BuildContext context) {
  return Container(
    child: Column(
      children: [],
    ),
  );
}
