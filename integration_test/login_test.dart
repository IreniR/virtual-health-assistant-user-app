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
  loginTest();
}

void loginTest() {
  group("Login Feature Functionality Test", () {
    testWidgets("'Empty Username and Password Fields'",
        (WidgetTester tester) async {
      await tester.pumpAndSettle(Duration(seconds: 2));

      //Given username and password fields are empty
      await tester.enterText(elements.usernamewidget, '');
      await tester.pumpAndSettle();
      await tester.enterText(elements.passwordwidget, '');
      await tester.pumpAndSettle();

      //When user taps the login button
      await tester.tap(elements.loginBtn);
      await tester.pumpAndSettle();

      //then expect error message
      expect(elements.emptyEmailValidator, findsOneWidget);
      expect(elements.emptyPasswordValidator, findsOneWidget);
    });

    testWidgets("'Invalid Username and Password Fields'",
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      //Given username and password fields are invalid
      await tester.enterText(elements.usernamewidget, 'email');
      await tester.pumpAndSettle();
      await tester.enterText(elements.passwordwidget, 'password');
      await tester.pumpAndSettle();

      //When user taps the login button
      await tester.tap(elements.loginBtn);
      await tester.pumpAndSettle();

      //then expect error message
      expect(elements.invalidEmailValidator, findsOneWidget);
      expect(elements.invalidPasswordValidator, findsOneWidget);
    });

    testWidgets("'Password Incorrect Format'", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      //Given username is correct and password is invalid
      await tester.enterText(elements.usernamewidget, elements.validEmail);
      await tester.pumpAndSettle();
      await tester.enterText(elements.passwordwidget, elements.invalidPassword);
      await tester.pumpAndSettle();

      //When user taps the login button
      await tester.tap(elements.loginBtn);
      await tester.pumpAndSettle();

      //then expect error message
      expect(elements.invalidPasswordValidator, findsOneWidget);
    });

    testWidgets("'Unregistered User Login'", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      //Given username and password fields are valid but user does not exist
      await tester.enterText(
          elements.usernamewidget, elements.correctFormatEmail);
      await tester.pumpAndSettle();
      await tester.enterText(
          elements.passwordwidget, elements.correctFormatPassword);
      await tester.pumpAndSettle();

      //When user taps the login button
      await tester.tap(elements.loginBtn);
      await tester.pumpAndSettle();

      //then expect error message
      expect(elements.userNotFoundMsg, findsOneWidget);

      //when dismiss message
      await tester.tap(elements.loginBtn);
      await tester.pumpAndSettle();

      //then user can view Login screen
      expect(elements.usernamewidget, findsOneWidget);
    });

    testWidgets("'Visibility of Buttons'", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      //Given user has application installed
      //when user has first accessed the application

      //then user can view all buttons available
      expect(elements.loginBtn, findsOneWidget);
      expect(elements.registerBtn, findsOneWidget);
      expect(elements.forgotPasswordBtn, findsOneWidget);
    });

    testWidgets("'Successful Login'", (WidgetTester tester) async {
      await tester.pumpAndSettle(Duration(seconds: 2));

      //Given username and password fields are empty
      await tester.enterText(elements.usernamewidget, elements.validEmail);
      await tester.pumpAndSettle();
      await tester.enterText(elements.passwordwidget, elements.validPassword);
      await tester.pumpAndSettle();

      //When user taps the login button
      await tester.tap(elements.loginBtn);
      await tester.pumpAndSettle();

      //then user is navigated to the Health Page
      expect(elements.userAvatar, findsOneWidget);
    });
  });
}
