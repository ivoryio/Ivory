// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
// // ignore: library_prefixes
// import 'package:solarisdemo/router/routing_constants.dart';
// import 'package:solarisdemo/screens/home/home_screen.dart';
// import 'package:solarisdemo/screens/landing/landing_screen.dart';
// import 'package:solarisdemo/screens/login/login_consent_screen.dart';
// import 'package:solarisdemo/screens/login/login_screen.dart';
// import 'package:solarisdemo/screens/login/login_tan_screen.dart';
// import 'package:solarisdemo/screens/signup/confirm_email_screen.dart';
// import 'package:solarisdemo/screens/signup/signup_screen.dart';
// import 'package:solarisdemo/services/auth_service.dart';
// import 'package:solarisdemo/themes/default_theme.dart';
// import 'package:solarisdemo/widgets/button.dart';
// import 'package:solarisdemo/widgets/checkbox.dart';
// import 'package:solarisdemo/widgets/platform_text_input.dart';
// import 'package:solarisdemo/widgets/screen.dart';
// import 'package:solarisdemo/widgets/sticky_bottom_content.dart';
// import 'package:solarisdemo/widgets/tab_view.dart';
// import 'package:solarisdemo/widgets/tan_input.dart';
// // package:flutter_tools/src/test/integration_test_device.dart

// void main() {
//   group("Signup flow test", () {
//     IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//     final authCubit = AuthCubit(authService: AuthService());

//     final goRouter = GoRouter(
//       routes: [
//         GoRoute(
//           path: landingRoute.path,
//           name: landingRoute.name,
//           pageBuilder: (context, state) => MaterialPage<void>(
//             child: BlocProvider.value(
//               value: authCubit,
//               child: const LandingScreen(),
//             ),
//           ),
//         ),
//         GoRoute(
//           path: signupRoute.path,
//           name: signupRoute.name,
//           pageBuilder: (context, state) => MaterialPage<void>(
//             child: BlocProvider.value(
//               value: authCubit,
//               child: const SignupScreen(),
//             ),
//           ),
//         ),
//       ],
//       initialLocation: landingRoute.path,
//     );

//     testWidgets(
//         'Should tap signup button from the landing screen, and redirect the user to the signup screen',
//         (WidgetTester tester) async {
//       //Arrange
//       // await dotenv.load();
//       // await tester.pumpWidget(
//       //   MaterialApp.router(
//       //     routerDelegate: goRouter.routerDelegate,
//       //     routeInformationParser: goRouter.routeInformationParser,
//       //     routeInformationProvider: goRouter.routeInformationProvider,
//       //   ),
//       // );
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

//       Finder signUpButton = find.text('Signup');
//       await tester.tap(signUpButton);
//       await tester.pumpAndSettle(const Duration(seconds: 5));

//       // Check if the current page is the login page
//       expect(goRouter.location, equals(signupRoute.path));
//     });

//     testWidgets(
//         'Should redirect the user to the GDPR screen after completing the modal for authentification',
//         (WidgetTester tester) async {
//       //Arrange
//       // await dotenv.load();
//       // await tester.pumpWidget(
//       //   MaterialApp.router(
//       //     routerDelegate: goRouter.routerDelegate,
//       //     routeInformationParser: goRouter.routeInformationParser,
//       //     routeInformationProvider: goRouter.routeInformationProvider,
//       //   ),
//       // );

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

//       Finder signUpButton = find.text('Signup');
//       await tester.tap(signUpButton);
//       await tester.pumpAndSettle(const Duration(seconds: 5));

//       Finder firstNameTextInput =
//           find.widgetWithText(PlatformTextInput, "First name");

//       Finder lastNameTextInput =
//           find.widgetWithText(PlatformTextInput, "Last name");
//       Finder emailAddressTextInput =
//           find.widgetWithText(PlatformTextInput, "Email Address");
//       Finder phoneNumberTextInput =
//           find.widgetWithText(PlatformTextInput, "Phone Number");
//       Finder passcodeTextInput =
//           find.widgetWithText(PlatformTextInput, "Passcode");

//       await tester.enterText(firstNameTextInput, "Miruna");
//       await tester.enterText(lastNameTextInput, "Luca");
//       await tester.enterText(
//           emailAddressTextInput, "anca.nechita.moldavia@gmail.com");
//       await tester.enterText(phoneNumberTextInput, "0749310430");
//       await tester.enterText(passcodeTextInput, "123456");
//       await tester.pumpAndSettle();

// //Example1
//       await tester.pumpWidget(
//         CheckboxWidget(
//           isChecked: false,
//           onChanged: (checked) {
//             // Setăm starea dorită pentru test
//             expect(checked,
//                 true); // Verificați aici dacă starea este cea așteptată
//           },
//         ),
//       );
//       //Example2
//       //Găsim widget-ul Checkbox

//       Finder checkboxFinder = find.byType(CheckboxWidget);
//       // Verificăm că am găsit un singur widget de tip Checkbox
//       expect(checkboxFinder, findsOneWidget);

//       // Apăsăm pe widget-ul Checkbox pentru a activa/dezactiva

//       await tester.tap(checkboxFinder);

//       // Pomparea pentru a reflecta schimbarea stării
//       //await tester.pumpAndSettle(const Duration(seconds: 2));
//       await tester.pumpAndSettle(const Duration(seconds: 3));
//       print('Aici este widgetul checkbox');
//       //Checkbox checkboxWidget = tester.widget(checkboxFinder);
//       expect(checkboxFinder, findsOneWidget);

//       // Finder signupButton = find.widgetWithText(SizedBox, "Continue");
//       // await tester.tap(signupButton);
//       // await tester.pumpAndSettle();

//       // Finder consentPage =
//       //     find.widgetWithText(GdprConsentScreen, "Welcome to SolarisDemo!");

//       // if (consentPage.evaluate().isNotEmpty) {
//       //   Finder consentButton =
//       //       find.widgetWithText(StickyBottomContent, "I agree");

//       // Găsiți widget-ul Checkbox
//       // Finder checkboxFinder = find.byType(Checkbox);

//       // // Verificați că am găsit un singur widget de tip Checkbox
//       // expect(checkboxFinder, findsOneWidget);

//       // // Apăsați pe widget-ul Checkbox pentru a-l bifa
//       // await tester.tap(checkboxFinder);

//       // // Pompați pentru a reflecta schimbarea stării
//       // await tester.pumpAndSettle(const Duration(seconds: 5));

//       // // Obțineți instanța widget-ului Checkbox
//       // Checkbox checkboxWidget = tester.widget(checkboxFinder);

//       // // Verificați starea actualizată a widget-ului Checkbox
//       //
//       // }
//     });
//     testWidgets('''Should show error messages,
//          whend the user tap on "Continue" button 
//          without filling the fields with required informationa for signUp''',
//         (WidgetTester tester) async {
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

//       Finder signUpButton = find.text('Signup');
//       await tester.tap(signUpButton);
//       await tester.pumpAndSettle(const Duration(seconds: 5));

//       Finder signupButton1 = find.widgetWithText(SizedBox, "Continue");
//       await tester.tap(signupButton1);
//       await tester.pumpAndSettle(const Duration(seconds: 3));

//       expect(find.text('Please enter your first name'), findsOneWidget);
//       expect(find.text('Please enter your last name'), findsOneWidget);
//       expect(find.text('Please enter your email address'), findsOneWidget);
//       expect(find.text('Please enter your phone number'), findsOneWidget);
//       expect(find.text('Please enter your passcode'), findsOneWidget);
//     });

//     testWidgets('''Should show error messages,
//          whend the user introduces a wrong email&passcode''',
//         (WidgetTester tester) async {
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

//       Finder signUpButton = find.text('Signup');
//       await tester.tap(signUpButton);
//       await tester.pumpAndSettle(const Duration(seconds: 5));

//       Finder firstNameTextInput =
//           find.widgetWithText(PlatformTextInput, "First name");

//       Finder lastNameTextInput =
//           find.widgetWithText(PlatformTextInput, "Last name");
//       Finder emailAddressTextInput =
//           find.widgetWithText(PlatformTextInput, "Email Address");
//       Finder phoneNumberTextInput =
//           find.widgetWithText(PlatformTextInput, "Phone Number");
//       Finder passcodeTextInput =
//           find.widgetWithText(PlatformTextInput, "Passcode");

//       await tester.enterText(firstNameTextInput, "Miruna");
//       await tester.enterText(lastNameTextInput, "Luca");
//       await tester.enterText(emailAddressTextInput, "anca");
//       await tester.enterText(phoneNumberTextInput, "0749310430");
//       await tester.enterText(passcodeTextInput, "12");
//       await tester.pumpAndSettle();

//       Finder signupButton1 = find.widgetWithText(SizedBox, "Continue");
//       await tester.tap(signupButton1);
//       await tester.pumpAndSettle(const Duration(seconds: 3));

//       //expect(find.text('Please enter your first name'), findsOneWidget);
//       // expect(find.text('Please enter your last name'), findsOneWidget);
//       expect(find.text('Please enter a valid email address'), findsOneWidget);
//       //expect(find.text('Please enter your phone number'), findsOneWidget);
//       expect(find.text('Please enter a valid passcode, with at least 6 digits'),
//           findsOneWidget);
//     });
//   });
// }
