//w/o mocking
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await DotEnv.dotenv.load(fileName: 'env/.env');
  });
  loginTest();
}

void loginTest() {}
