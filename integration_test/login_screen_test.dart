// ignore_for_file: unused_element

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:solarisdemo/screens/login/login_screen.dart';
import 'package:solarisdemo/widgets/button.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    "Should submit form when user email&password are valid",
    (WidgetTester tester) async {
      //Arrange
      await tester.pumpWidget(const MaterialApp(
        home: EmailLoginForm(),
      ));

      //ACT

      // Finder userNameTextField = find.byWidget(widget);
      Finder continueButton = find.byWidget(PrimaryButton as Widget);
      await tester.tap(continueButton);
      await tester.pumpAndSettle();
      // ignore: unused_local_variable
      //Finder errorTexts = find.text("Please enter your email address");
    },
  );
}
// testWidgets("Should submit form when user email&password are valid", (WidgetTester tester,) async) {
//   await tester.pumpWidget(const MaterialApp(home:LoginScreen())
//   );

//   Finder userNameTextField = find.by
// };
// }
