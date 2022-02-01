import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final bool obscureText;
  final List<Widget> widgets;
  final Icon icon;
  final TextInputType textInputType;
  final String Function(String) validator;
  final Function(String) onSaved;
  final TextInputType keyBoardType;
  final controller;

  InputTextField(
      {Key key,
      this.hintText,
      this.labelText,
      this.obscureText,
      this.controller,
      this.widgets,
      this.icon,
      this.textInputType,
      this.onSaved,
      @required this.keyBoardType,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              keyboardType: keyBoardType,
              validator: validator,
              onSaved: onSaved,
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                border: OutlineInputBorder(),
                focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: hintText,
                labelText: labelText,
                prefixIcon: icon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget doctorType() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      SizedBox(height: 10),
      Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
        child: Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            obscureText: false,
            decoration: InputDecoration(
              labelText: "Practice",
              border: OutlineInputBorder(),
              hintText: 'Practice',
              prefixIcon: Icon(
                Icons.medical_services,
                color: Colors.lightBlueAccent,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
