import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:health_assistant/model/account_model.dart';
import 'package:health_assistant/pages/login_page.dart';
import 'package:health_assistant/utils/local_storage.dart';
import 'package:health_assistant/utils/notifications.dart';
import 'package:provider/provider.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    importance: Importance.high, playSound: true);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
LocalStorage cache;

void init() async {
  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  var initalizationSettingsIOS = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: (id, title, body, payload) => {},
  );

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initalizationSettingsIOS,
      macOS: null);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  init();

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

    NotificationApi.init(initScheduled: true);
    listenNotifications();
  }

  void listenNotifications() => NotificationApi.onNotifications;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(value: accountModel),
    ]);
  }

  void onClickedNotification(String payload) {
    //what to do when notifications is clicked
  }
}
