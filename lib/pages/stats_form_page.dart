import 'package:flutter/material.dart';
import 'package:health_assistant/model/account_model.dart';
import 'package:health_assistant/widgets/appbar.dart';
import 'package:health_assistant/widgets/fields.dart';
import 'package:provider/provider.dart';
import 'package:health_assistant/widgets/menu.dart';

class SubmitHealthFormPage extends StatefulWidget {
  static const String id = 'submit_health_form_page';

  @override
  _SubmitHealthFormPage createState() => _SubmitHealthFormPage();
}

class _SubmitHealthFormPage extends State<SubmitHealthFormPage> {
  final GlobalKey<FormState> _healthFormKey = GlobalKey<FormState>();
  int userWeight, userHeight, userAge;
  int selectedRadioTile;
  int _value;

  @override
  void initState() {
    super.initState();
    selectedRadioTile = 0;
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: Text('About You'),
      ),
      body: Container(
        child: Form(
          key: _healthFormKey,
          child: Column(
            children: <Widget>[
              InputTextField(
                hintText: 'Weight(lbs)',
                keyBoardType: TextInputType.number,
                onSaved: (value) => userWeight = value as int,
              ),
              InputTextField(
                hintText: 'Height (ft, in)',
                keyBoardType: TextInputType.number,
                onSaved: (value) => userWeight = value as int,
              ),
              InputTextField(
                hintText: 'Age',
                keyBoardType: TextInputType.number,
                onSaved: (value) => userWeight = value as int,
              ),
              RadioListTile(
                title: Text('Female'),
                value: 1,
                groupValue: _value,
                onChanged: (val) {
                  setState(() {
                    _value = val;
                    print("$val Female Button Pressed");
                    // setSelectedRadio(val);
                  });
                },
              ),
              RadioListTile(
                  title: Text('Male'),
                  value: 2,
                  groupValue: _value,
                  onChanged: (val) {
                    setState(() {
                      _value = val;
                      print("$val Male Button Pressed");
                      // setSelectedRadio(val);
                    });
                  }),
              RadioListTile(
                  title: Text('Intersex'),
                  value: 3,
                  groupValue: _value,
                  onChanged: (val) {
                    setState(() {
                      _value = val;
                      print("$val Intersex Button Pressed");
                      // setSelectedRadio(val);
                    });
                  }),
              Padding(padding: EdgeInsets.all(20)),
              TextButton(
                onPressed: () {
                  context.read<AccountModel>().hasSubmittedHealthForm = true;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NavigationPage()));
                },
                child: Text('Submit Information'),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.black,
                    textStyle: TextStyle(fontSize: 20)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
