// import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'shared/elements.dart' as elements;
import 'package:health_assistant/main.dart' as app;

main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // await DotEnv.dotenv.load(fileName: 'env/.env');
    app.main();
  });
  forgotPasswordTest();
}

void forgotPasswordTest() {
  group("Forgot Password Feature Functionality Test", () {
    testWidgets("'Visibility of Forgot Password Button'",
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(elements.forgotPasswordBtn, findsOneWidget);
    });

    testWidgets("'Navigate to Forgot Password Page'",
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(elements.forgotPasswordBtn);
      await tester.pumpAndSettle();

      expect(elements.forgotPasswordBackBtn, findsOneWidget);
    });

    testWidgets("'Verify Forgot Password Page Buttons'",
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(elements.forgotPasswordBtn);
      await tester.pumpAndSettle();

      expect(elements.forgotPasswordBackBtn, findsOneWidget);
      expect(elements.resetPasswordBtn, findsOneWidget);
    });

    testWidgets("'Invalid Email Entered'", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(elements.forgotPasswordBtn);
      await tester.pumpAndSettle();

      await tester.enterText(
          elements.resetPassEmailValidator, elements.invalidEmail);
      await tester.pumpAndSettle();
      await tester.tap(elements.resetPasswordBtn);
      await tester.pumpAndSettle();

      expect(elements.invalidEmailValidator, findsOneWidget);
    });

    testWidgets("'Navigate Back to Login Page'", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(elements.forgotPasswordBtn);
      await tester.pumpAndSettle();
      await tester.tap(elements.forgotPasswordBackBtn);
      await tester.pumpAndSettle();

      expect(elements.loginBtn, findsOneWidget);
    });

    testWidgets("'User Not Found flow'", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(elements.forgotPasswordBtn);
      await tester.pumpAndSettle();
      await tester.enterText(
          elements.resetPassEmailValidator, elements.validEmail);
      await tester.pumpAndSettle();
      await tester.tap(elements.resetPasswordBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect('Invalid Email', findsOneWidget);
      expect('User may have been deleted', findsOneWidget);

      await tester.tap(elements.confirmResetButton);
      await tester.pumpAndSettle();

      expect(elements.forgotPasswordBackBtn, findsOneWidget);
    });

    testWidgets("'Valid Reset Flow'", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(elements.forgotPasswordBtn);
      await tester.pumpAndSettle();
      await tester.enterText(
          elements.resetPassEmailValidator, elements.validEmail);
      await tester.pumpAndSettle();
      await tester.tap(elements.resetPasswordBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(elements.successResetPassword, findsOneWidget);
      expect(elements.confirmResetButton, findsOneWidget);

      await tester.tap(elements.confirmResetButton);
      await tester.pumpAndSettle();

      expect(elements.forgotPasswordBackBtn, findsOneWidget);
    });
  });
}
