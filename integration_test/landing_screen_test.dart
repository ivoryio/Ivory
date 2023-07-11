// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter/material.dart';

// import 'login_flow_test.dart';
// import '../..landing'

// // void main() {
// //   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
// //   testWidgets('Login Interface Test', (WidgetTester tester) async {


// void main() {
//   group('LandingScreen integration test', () {
//     FlutterDriver driver;

//     // Connect to the Flutter driver before running any tests.
//     setUpAll(() async {
//       driver = await FlutterDriver.connect();
//     });

//     // Close the connection to the driver after the tests have completed.
//     tearDownAll(() async {
//       if (driver != null) {
//         driver.close();
//       }
//     });

//     test('Login button opens login screen', () async {
//       // Find the Login button by its text and tap it.
//       final loginButtonFinder = find.byValueKey('login_button');
//       await driver.tap(loginButtonFinder);

//       // Wait for the next screen to appear.
//       await driver.waitFor(find.text('Login Screen'));

//       // Check if the Login screen is displayed.
//       final loginScreenFinder = find.text('Login Screen');
//       expect(await driver.getText(loginScreenFinder), 'Login Screen');
//     });

//     test('Signup button opens signup screen', () async {
//       // Find the Signup button by its text and tap it.
//       final signupButtonFinder = find.byValueKey('signup_button');
//       await driver.tap(signupButtonFinder);

//       // Wait for the next screen to appear.
//       await driver.waitFor(find.text('Signup Screen'));

//       // Check if the Signup screen is displayed.
//       final signupScreenFinder = find.text('Signup Screen');
//       expect(await driver.getText(signupScreenFinder), 'Signup Screen');
//     });
//   });
// }

// class FlutterDriver {
//   tap(signupButtonFinder) {}
  
//   getText(Finder signupScreenFinder) {}
  
//   waitFor(Finder text) {}
// }
