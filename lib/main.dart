import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/model/account_model.dart';
import 'package:health_assistant/pages/login_page.dart';
import 'package:health_assistant/utils/local_storage.dart';
import 'package:provider/provider.dart';

LocalStorage cache;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthAssistant',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class ProvidersSetup extends StatefulWidget {
  final Widget child;

  const ProvidersSetup({
    this.child,
    Key key,
  });

  @override
  _ProvidersSetupState createState() => _ProvidersSetupState();
}

class _ProvidersSetupState extends State<ProvidersSetup> {
  AccountModel accountModel;

  void _initializeModels() {
    accountModel = AccountModel(
      hasSubmittedHealthForm: cache.loadHealthForm() ?? true,
    );
  }

  void _initializeListeners() {
    accountModel.addListener(() {
      cache.saveSubmittedHealthForm(accountModel.hasSubmittedHealthForm);
    });
  }

  @override
  void initState() {
    _initializeModels();
    _initializeListeners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(value: accountModel),
    ]);
  }
}
