import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:solarisdemo/ivory_app.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
//import 'package:solarisdemo/screens/landing/landing_screen.dart';
import 'package:solarisdemo/screens/login/login_consent_screen.dart';
import 'package:solarisdemo/screens/login/login_screen.dart';
import 'package:solarisdemo/screens/welcome/welcome_screen.dart';
//import 'package:solarisdemo/services/auth_service.dart';
import 'package:solarisdemo/themes/default_theme.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/platform_text_input.dart';
import 'package:solarisdemo/widgets/screen.dart';
import 'package:solarisdemo/widgets/screen_title.dart';
import 'package:solarisdemo/widgets/tab_view.dart';
//import 'package:solarisdemo/widgets/sticky_bottom_content.dart';
import 'package:solarisdemo/widgets/tan_input.dart';
// package:flutter_tools/src/test/integration_test_device.dart
import 'package:solarisdemo/main.dart' as app;

void main() {
  group("Login flow test", () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('Check if the user is able to login with valid credential', (WidgetTester tester) async {
      app.main();
      await dotenv.load();
      await tester.pumpAndSettle();

      Finder loginButton = find.text('Log in');
      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      Finder emailButton = find.widgetWithText(TabView, "Email");
      await tester.tap(emailButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      Finder emailTextInput = find.widgetWithText(IvoryTextField, "Email address");
      Finder passwordTextInput = find.widgetWithText(IvoryTextField, "Password");
      await tester.enterText(emailTextInput, "anca.nechita@thinslices.com");
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.enterText(passwordTextInput, "123456");
      await tester.pumpAndSettle(const Duration(seconds: 1));
      Finder authentification = find.widgetWithText(Button, 'Continue');
      await tester.tap(authentification);
      await tester.pumpAndSettle();

      //expect(IvoryTextField, findsOneWidget);
      // expect(passwordTextInput, findsOneWidget);
      // expect(authentification, findsWidgets);
      expect(emailButton, findsOneWidget);
    });
  });

  testWidgets(
      'Check if the user is directed to the TAN screen, and if he is able to complete login flow after enters a valid TAN',
      (WidgetTester tester) async {
    Finder passcodeInput = find.byType(TanInput);

    await tester.enterText(passcodeInput.first, "1");
    await tester.enterText(passcodeInput.at(1), "2");
    print('aici e printul passcode');
    await tester.enterText(passcodeInput.at(2), "3");

    await tester.enterText(passcodeInput.at(3), "4");
    await tester.enterText(passcodeInput.at(4), "4");
    await tester.enterText(passcodeInput.at(5), "4");

    // await tester.pumpAndSettle();
  });

  // Finder passcodeInput = find.byType(TanInput);

  // await tester.enterText(passcodeInput.first, "1");
  // await tester.enterText(passcodeInput.at(1), "2");
  // print('aici e printul passcode');
  // await tester.enterText(passcodeInput.at(2), "3");

  // await tester.enterText(passcodeInput.at(3), "4");
  // await tester.enterText(passcodeInput.at(4), "4");
  // await tester.enterText(passcodeInput.at(5), "4");

  // await tester.pumpAndSettle();

//

//       Finder emailButton = find.widgetWithText(PlatformElevatedButton, "Email");
//       await tester.tap(emailButton);
//       await tester.pumpAndSettle(const Duration(seconds: 3));

//       Finder emailTextInput =
//           find.widgetWithText(PlatformTextInput, "Email Address");
//       Finder passwordTextInput =
//           find.widgetWithText(PlatformTextInput, "Password");
//       await tester.enterText(emailTextInput, "anca.nechita@thinslices.com");
//       await tester.pumpAndSettle(const Duration(seconds: 2));
//       await tester.enterText(passwordTextInput, "123456");
//       await tester.pumpAndSettle(const Duration(seconds: 2));

//       Finder loginButton1 = find.widgetWithText(PrimaryButton, "Continue");
//       await tester.tap(loginButton1);
//       await tester.pumpAndSettle(const Duration(seconds: 3));

//       Finder consentPage =
//           find.widgetWithText(GdprConsentScreen, "Welcome to SolarisDemo!");

//       if (consentPage.evaluate().isNotEmpty) {
//         Finder consentButton =
//             find.widgetWithText(StickyBottomContent, "I agree");

//         await tester.tap(consentButton);
//         await tester.pumpAndSettle(const Duration(seconds: 3));
//       }

//       Finder passcodeInput = find.byType(InputCodeBox);

//       await tester.enterText(passcodeInput.first, "1");
//       await tester.enterText(passcodeInput.at(1), "2");
//       print('aici e printul passcode');
//       await tester.enterText(passcodeInput.at(2), "3");
//       await tester.enterText(passcodeInput.at(3), "4");

//       await tester.pumpAndSettle();

//       //Finder homeScreenFinder = find.byKey(Key(homeRoute.name));
//       //Finder homeScreenFinder = find.widgetWithText(HomeScreen, 'Hello, Anca!');
//       // Finder homeScreenFinder = find.byType(PlatformScaffold);
//       //
//       // expect(consentPage, findsOneWidget);
//       // expect(HomeScreen(), findsOneWidget);
//       Finder homeScreenFinder =
//           find.byElementType(InheritedModelElement<Object>);
//       await tester.tapAt(const Offset(100, 200));
//       await tester.pumpAndSettle(const Duration(seconds: 15));
//     });

//     testWidgets('Should throw an error message when passcode is invalid',
//         (WidgetTester tester) async {
//       //Arrange
//       await dotenv.load();
//       await tester.pumpWidget(
//         PlatformApp.router(
//           routerConfig: goRouter,
//           material: (context, platform) => MaterialAppRouterData(
//             theme: defaultMaterialTheme,
//           ),
//           cupertino: (context, platform) => CupertinoAppRouterData(
//             theme: cupertinoTheme,
//           ),
//           localizationsDelegates: const [
//             DefaultMaterialLocalizations.delegate,
//             DefaultWidgetsLocalizations.delegate,
//             DefaultCupertinoLocalizations.delegate,
//           ],
//         ),
//       );
//       Finder loginButton = find.text('Login');
//       await tester.tap(loginButton);
//       await tester.pumpAndSettle(const Duration(seconds: 3));

//       Finder emailButton = find.widgetWithText(PlatformElevatedButton, "Email");
//       await tester.tap(emailButton);
//       await tester.pumpAndSettle(const Duration(seconds: 3));

//       Finder emailTextInput =
//           find.widgetWithText(PlatformTextInput, "Email Address");
//       Finder passwordTextInput =
//           find.widgetWithText(PlatformTextInput, "Password");
//       await tester.enterText(emailTextInput, "anca.nechita@thinslices.com");
//       await tester.pumpAndSettle(const Duration(seconds: 2));
//       await tester.enterText(passwordTextInput, "123456");
//       await tester.pumpAndSettle(const Duration(seconds: 2));

//       Finder loginButtone = find.widgetWithText(PrimaryButton, "Continue");
//       await tester.tap(loginButtone);
//       await tester.pumpAndSettle(const Duration(seconds: 3));

//       Finder consentPage =
//           find.widgetWithText(GdprConsentScreen, "Welcome to SolarisDemo!");

//       if (consentPage.evaluate().isNotEmpty) {
//         Finder consentButton =
//             find.widgetWithText(StickyBottomContent, "I agree");

//         await tester.tap(consentButton);
//         await tester.pumpAndSettle(const Duration(seconds: 3));
//       }

//       Finder passcodeInput = find.byType(InputCodeBox);

//       await tester.enterText(passcodeInput.first, "1");
//       await tester.enterText(passcodeInput.at(1), "1");
//       await tester.enterText(passcodeInput.at(2), "1");
//       await tester.enterText(passcodeInput.at(3), "1");
//       await tester.pumpAndSettle(const Duration(seconds: 3));
//     });

//     testWidgets(
//         'Check if the user is not able to log in with invalid credentials (email address)',
//         (WidgetTester tester) async {
//       //Arrange
//       await dotenv.load();
//       await tester.pumpWidget(
//         PlatformApp.router(
//           routerConfig: goRouter,
//           material: (context, platform) => MaterialAppRouterData(
//             theme: defaultMaterialTheme,
//           ),
//           cupertino: (context, platform) => CupertinoAppRouterData(
//             theme: cupertinoTheme,
//           ),
//           localizationsDelegates: const [
//             DefaultMaterialLocalizations.delegate,
//             DefaultWidgetsLocalizations.delegate,
//             DefaultCupertinoLocalizations.delegate,
//           ],
//         ),
//       );

//       Finder loginButton2 = find.text('Login');
//       await tester.tap(loginButton2);
//       await tester.pumpAndSettle(const Duration(seconds: 5));

//       expect(goRouter.location, equals(loginRoute.path));

//       Finder emailButton = find.widgetWithText(PlatformElevatedButton, "Email");
//       await tester.tap(emailButton);
//       await tester.pumpAndSettle(const Duration(seconds: 5));

//       Finder emailTextInput =
//           find.widgetWithText(PlatformTextInput, "Email Address");
//       Finder passwordTextInput =
//           find.widgetWithText(PlatformTextInput, "Password");
//       await tester.enterText(emailTextInput, "cocorociuschita@yahoo.com");
//       await tester.pumpAndSettle(const Duration(seconds: 2));
//       await tester.enterText(passwordTextInput, "456789");
//       await tester.pumpAndSettle(const Duration(seconds: 2));

//       // bool GdprConsentScreen = false;
//       // expect(find.byType(Screen), findsNothing);

//       Finder consentPage =
//           find.widgetWithText(GdprConsentScreen, "Welcome to ...!");

//       if (consentPage.evaluate().isEmpty) {
//         Finder loginButton1 = find.widgetWithText(PrimaryButton, "Continue");
//         await tester.tap(loginButton1);
//         await tester.pumpAndSettle(const Duration(seconds: 3));
//       }

//       Finder errorMessage =
//           find.widgetWithText(LoginCubit, "Wrong username or password".trim());

//       // Finder errorText =
//       //     find.widgetWithText(LoginCubit, "Wrong username or password".trim());
//       // expect(find.text("Wrong username or password"), findsOneWidget);
//     });
//     testWidgets('Un .nou test', (WidgetTester tester) async {});
//   });
}
