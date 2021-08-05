import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/model/account_model.dart';
import 'package:health_assistant/pages/health_page.dart';
import 'package:health_assistant/pages/stats_form_page.dart';
import 'package:provider/provider.dart';

class LaunchScreen extends StatefulWidget {
  static const String id = 'launch_screen';

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    final accountModel = context.read<AccountModel>();
    String routeName;

    if (!accountModel.hasSubmittedHealthForm)
      routeName = SubmitHealthFormPage.id;
    else
      routeName = HealthPage.id;
    Future.delayed(Duration(milliseconds: 100),
        () => Navigator.pushReplacementNamed(context, routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white);
  }
}
