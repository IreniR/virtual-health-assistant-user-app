import 'package:flutter/material.dart';
import 'package:health_assistant/pages/about_page.dart';
import 'package:health_assistant/pages/appts_page.dart';
import 'package:health_assistant/pages/chat_page.dart';
import 'package:health_assistant/pages/fitness_page.dart';
import 'package:health_assistant/pages/forgot_pswrd_page.dart';
import 'package:health_assistant/pages/health_page.dart';
import 'package:health_assistant/pages/launch_screen.dart';
import 'package:health_assistant/pages/login_page.dart';
import 'package:health_assistant/pages/notifications.dart';
import 'package:health_assistant/pages/prescriptions_page.dart';
import 'package:health_assistant/pages/register_page.dart';
import 'package:health_assistant/pages/settings_page.dart';
import 'package:health_assistant/pages/stats_form_page.dart';

class AppRoutes {
  static final Map<String, Widget Function(BuildContext)> routeMap = {
    LoginPage.id: (_) => LoginPage(),
    SettingsPage.id: (_) => SettingsPage(),
    NotificationPage.id: (_) => NotificationPage(),
    HealthPage.id: (_) => HealthPage(),
    FitnessPage.id: (_) => FitnessPage(),
    AboutPage.id: (_) => AboutPage(),
    ForgotPasswordPage.id: (_) => ForgotPasswordPage(),
    RegisterPage.id: (_) => RegisterPage(),
    PrescriptionPage.id: (_) => PrescriptionPage(),
    AppointmentsPage.id: (_) => AppointmentsPage(),
    ChatPage.id: (_) => ChatPage(),
    SubmitHealthFormPage.id: (_) => SubmitHealthFormPage(),
    LaunchScreen.id: (_) => LaunchScreen(),
  };
}
