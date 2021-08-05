# health_assistant

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Running App

To launch application on emulator use following command

'flutter run'

# Unit Tests
To run Unit tests

'flutter test'

To find code coverage 

'flutter test --coverage genhtml coverage/lcov.info -o coverage/html'

# Integration Tests

Need environment variables to run integration tests

'email=YOURTESTEMAIL'

'password=YOURTESTPASSWORD'

Define these variables in file env/.env

To run integration tests

flutter drive --driver=test_driver/integration_test_driver.dart --target=integration_test/main_test.dart
