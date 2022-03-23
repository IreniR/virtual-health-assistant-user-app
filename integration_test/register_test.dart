// import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'shared/elements.dart' as elements;
import 'package:health_assistant/main.dart' as app;
import 'shared/helper.dart' as tester;

main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // await DotEnv.dotenv.load(fileName: 'env/.env');
    app.main();
  });
  registerTest();
}

void registerTest() {
  group('Register Feature Functionality', () {
    testWidgets("'Navigate to Register Page'", (WidgetTester tester) async {
      await tester.pumpAndSettle(Duration(seconds: 2));

      //Given user has app
      //when user presses register button
      await tester.tap(elements.registerBtn);
      await tester.pumpAndSettle();

      //then navigate to register page
      expect(elements.registerEmailField, findsOneWidget);
    });

    testWidgets("'Verify Register Page Elements'", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      //Given user has app
      //when user presses register button
      await tester.tap(elements.registerBtn);
      await tester.pumpAndSettle();

      //then navigate to register page
      expect(elements.registerEmailField, findsOneWidget);
      expect(elements.registerBackButton, findsOneWidget);
      expect(elements.registerPasswordField, findsOneWidget);
      expect(elements.registerUsernameField, findsOneWidget);
    });

    testWidgets("'Navigate Back to Login Page'", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      //Given user has app
      //when user presses register button
      await tester.tap(elements.registerBtn);
      await tester.pumpAndSettle();
      await tester.tap(elements.registerBackButton);
      await tester.pumpAndSettle();

      //then navigate to register page
      expect(elements.loginBtn, findsOneWidget);
    });

    testWidgets("'Empty Field Flow'", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      //Given user has app
      //when user presses register button
      await tester.tap(elements.registerBtn);
      await tester.pumpAndSettle();
      await tester.tap(elements.nextBtn);
      await tester.pumpAndSettle();

      //then navigate to register page
      expect(elements.emptyFieldValidator, findsWidgets);
      expect(elements.emptyEmailValidator, findsOneWidget);
      expect(elements.emptyPasswordValidator, findsOneWidget);
    });

    testWidgets("'Invalid Entry Field Flow'", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      //Given user has app
      //when user presses register button
      await tester.tap(elements.registerBtn);
      await tester.pumpAndSettle();
      await tester.enterText(elements.registerUsernameField, elements.username);
      await tester.pumpAndSettle();
      await tester.enterText(
          elements.registerEmailField, elements.invalidEmail);
      await tester.pumpAndSettle();
      await tester.enterText(
          elements.registerPasswordField, elements.invalidPassword);
      await tester.pumpAndSettle();
      await tester.enterText(
          elements.confirmPasswordField, elements.invalidPassword);
      await tester.pumpAndSettle();
      await tester.tap(elements.nextBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      //then navigate to register page
      expect(elements.invalidPasswordValidator, findsOneWidget);
      expect(elements.invalidEmailValidator, findsOneWidget);
    });

    testWidgets("'Password Do Not Match Flow'", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      //Given user has app
      //when user presses register button
      await tester.tap(elements.registerBtn);
      await tester.pumpAndSettle();
      await tester.enterText(elements.registerUsernameField, elements.username);
      await tester.pumpAndSettle();
      await tester.enterText(elements.registerEmailField, elements.validEmail);
      await tester.pumpAndSettle();
      await tester.enterText(
          elements.registerPasswordField, elements.validPassword);
      await tester.pumpAndSettle();
      await tester.enterText(
          elements.confirmPasswordField, elements.invalidPassword);
      await tester.pumpAndSettle();
      await tester.tap(elements.nextBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      //then navigate to register page
      expect(elements.passwordsDoNotMatch, findsOneWidget);
    });

    testWidgets("'Navigate to User Deails Page'", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      //Given user has app
      //when user presses register button
      await tester.registerUserInfo();

      //then navigate to register page
      expect(elements.submitBtn, findsOneWidget);
    });

    testWidgets("'Navigate to Back from User Details Page'",
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      //Given user has app
      //when user presses register button
      await tester.registerUserInfo();

      //then navigate to register page
      expect(elements.nextBtn, findsOneWidget);
    });

    testWidgets("'Verify User Details Elements'", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      //Given user has app
      //when user presses register button
      await tester.registerUserInfo();

      //then navigate to register page
      expect(elements.userDetailsBackBtn, findsOneWidget);
      expect(elements.weightField, findsOneWidget);
      expect(elements.heightField, findsOneWidget);
      expect(elements.dobField, findsOneWidget);
      expect(elements.submitBtn, findsOneWidget);
    });

    testWidgets("'Empty Details Elements'", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      //Given user has app
      //when user presses register button
      await tester.registerUserInfo();
      await tester.tap(elements.submitBtn);
      await tester.pumpAndSettle(Duration(seconds: 2));

      //then navigate to register page
      expect(elements.emptyNumericValidator, findsWidgets);
    });

    testWidgets("'Invalid Details Elements'", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      //Given user has app
      //when user presses register button
      await tester.registerUserInfo();
      await tester.tap(elements.submitBtn);
      await tester.pumpAndSettle(Duration(seconds: 10));

      //then navigate to register page
      expect(elements.emptyNumericValidator, findsWidgets);
      expect(elements.enterValidBirthday, findsOneWidget);
    });

    testWidgets("'Verify Gender Cards'", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      //Given user has app
      //when user presses register button
      await tester.registerUserInfo();
      await tester.tap(elements.genderMale);
      await tester.pumpAndSettle();
      await tester.tap(elements.genderFemale);
      await tester.pumpAndSettle();
      await tester.tap(elements.genderOther);
      await tester.pumpAndSettle();

      //then navigate to register page
      expect(elements.genderFemale, findsOneWidget);
      expect(elements.genderMale, findsOneWidget);
      expect(elements.genderOther, findsOneWidget);
    });

    testWidgets("'Valid User Detail Flow'", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      //Given user has app
      //when user presses register button
      await tester.registerUserInfo();
      await tester.enterText(elements.dobField, "1970/11/11");
      await tester.pumpAndSettle();
      await tester.enterText(elements.heightField, "170");
      await tester.pumpAndSettle();
      await tester.enterText(elements.weightField, "60");
      await tester.pumpAndSettle();
      await tester.tap(elements.genderOther);
      await tester.pumpAndSettle();
      await tester.tap(elements.submitBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      //then navigate to register page >> email already in use
      //need to mock if project continues further
      //expect(elements.loginBtn, findsWidgets);
      // expect(elements.enterValidBirthday, findsOneWidget);
    });
  });
}
