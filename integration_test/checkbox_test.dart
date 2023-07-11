// import 'package:flutter_driver/flutter_driver.dart';
// import 'package:test/test.dart';
// import 'package:solarisdemo/widgets/checkbox.dart';


// void main() {
//   group('CheckboxWidget Integration Test', () {
//     late FlutterDriver driver;

//     // Setarea driverului înainte de rularea testelor
//     setUpAll(() async {
//       driver = await FlutterDriver.connect();
//     });

//     // Închiderea driverului după rularea testelor
//     tearDownAll(() async {
//       if (driver != null) {
//         driver.close();
//       }
//     });

//     test('Testarea schimbării stării checkbox-ului', () async {
//       // Verificăm inițial că valoarea checkbox-ului este falsă
//       final initialValue = await driver.getCheckboxValue('checkbox');
//       expect(initialValue, equals('false'));

//       // Apăsăm pe checkbox pentru a schimba starea
//       await driver.tap(find.byValueKey('checkbox'));

//       // Verificăm că starea checkbox-ului a fost actualizată
//       final updatedValue = await driver.getCheckboxValue('checkbox');
//       expect(updatedValue, equals('true'));
//     });
//   });
// }
