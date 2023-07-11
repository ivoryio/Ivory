// import 'package:flutter_driver/flutter_driver.dart';
// import 'package:test/test.dart';

// void main() {
//   group('AlertDialog Integration Test', () {
//     late FlutterDriver driver;

//     // Set up the driver before running the tests
//     setUpAll(() async {
//       driver = await FlutterDriver.connect();
//     });

//     // Close the driver after running the tests
//     tearDownAll(() async {
//       if (driver != null) {
//         driver.close();
//       }
//     });

//     test('Testing the display and button press in AlertDialog', () async {
//       // Tap on a button that triggers the AlertDialog
//       await driver.tap(find.byValueKey('show_alert_dialog_button'));

//       // Verify the presence of the text in the AlertDialog
//       expect(await driver.getText(find.text('Message Text')), 'Message Text');

//       // Tap on the OK button
//       await driver.tap(find.text('OK'));

//       // Verify the closing of the AlertDialog
//       expect(await driver.getText(find.byType('AlertDialog')), throwsException);
//     });
//   });
// }
