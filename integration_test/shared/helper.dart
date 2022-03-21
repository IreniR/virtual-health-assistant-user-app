import 'package:flutter_test/flutter_test.dart';
import 'elements.dart' as elements;

extension UiHelper on WidgetTester {
  Future<void> loginUser() async {
    //Given username and password fields are empty
    await enterText(elements.usernamewidget, elements.validEmail);
    await pumpAndSettle();
    await enterText(elements.passwordwidget, elements.validPassword);
    await pumpAndSettle();

    //When user taps the login button
    await tap(elements.loginBtn);
    await pumpAndSettle();
  }

  Future<void> registerUserInfo() async {
    await tap(elements.registerBtn);
    await pumpAndSettle();
    await enterText(elements.registerUsernameField, elements.username);
    await pumpAndSettle();
    await enterText(elements.registerEmailField, elements.validEmail);
    await pumpAndSettle();
    await enterText(elements.registerPasswordField, elements.validPassword);
    await pumpAndSettle();
    await enterText(elements.confirmPasswordField, elements.validPassword);
    await pumpAndSettle();
    await tap(elements.nextBtn);
    await pumpAndSettle();
  }
}
