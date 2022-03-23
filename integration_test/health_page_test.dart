import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'shared/elements.dart' as elements;
import 'package:health_assistant/main.dart' as app;
import 'shared/helper.dart' as tester;

main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // await DotEnv.dotenv.load(fileName: 'env/.env');
  });
  healthPageTest();
}

void healthPageTest() {
  group("Login Feature Functionality Test", () {
    testWidgets("'Verify Health Page Elements'", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.loginUser();
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(elements.userAvatar, findsOneWidget);
      // expect(elements.bmiCard, findsOneWidget);
      expect(elements.heartRate, findsOneWidget);
      expect(elements.oxygenLvl, findsOneWidget);
    });
  });
}
