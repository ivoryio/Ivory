import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// ignore: library_prefixes
import 'package:solarisdemo/main.dart' as MyApp;
import 'package:solarisdemo/router/routing_constants.dart';
import 'package:solarisdemo/screens/landing/landing_screen.dart';
import 'package:solarisdemo/screens/login/login_screen.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/router/router.dart';
import 'package:solarisdemo/widgets/screen.dart';
// package:flutter_tools/src/test/integration_test_device.dart

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Login Interface Test', (WidgetTester tester) async {
    //Arrange
    final goRouter = GoRouter(
      routes: [
        GoRoute(
            path: landingRoute.path,
            name: landingRoute.name,
            pageBuilder: (context, state) => const MaterialPage<void>(child: LandingScreen()), // your Screen widget
            ),
        GoRoute(
          path: loginRoute.path,
          name: loginRoute.name,
          pageBuilder: (context, state) => const MaterialPage<void>(child: LoginScreen()), // your Screen widget
        ),
      ],
    );
    await tester.pumpWidget(
      MaterialApp.router(
        routerDelegate: goRouter.routerDelegate,
        routeInformationParser: goRouter.routeInformationParser,
        routeInformationProvider: goRouter.routeInformationProvider,
        
      ),
    );
    await tester.pumpWidget(const MyApp.MyApp());
    await tester.pumpWidget(const MaterialApp(
      home: LandingScreen(),

    ));
    // await tester.pumpWidget(MaterialApp.router(
    //   routeInformationParser: goRouter.routeInformationParser,
    //   routerDelegate: goRouter.routerDelegate,
    // ));

    
    //Act
    //Finder loginButton = find.widgetWithText(Button, 'Login');
    Finder loginButton = find.text("Manage");

   //print('aici e printul $loginButton');

    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    //Assert
    expect(loginButton, findsOneWidget);
  });

  // Build the app

  // // Find the login input fields and submit button
  // final loginButton = find.byKey(Key('Login'));
  // //final loginButton = find.byType('button');

  // await tester.tap(loginButton);
  // await tester.pump();

  // final emailField = find.byKey(Key('email_field'));
  // final passwordField = find.byKey(Key('password_field'));

  // // Enter test values in the input fields
  // await tester.enterText(emailField, 'ilie.lupu@thinslices.com');
  // await tester.enterText(passwordField, '123456');

  // // Tap the login button
  // // await tester.tap(loginButton);
  // // await tester.pump();

  // // Check if the login is successful
  // expect(find.text('Welcome'), findsOneWidget);
  // expect(find.text('test@example.com'), findsOneWidget);
  // });
}

class IntegrationTestWidgetsFlutterBinding {
  static void ensureInitialized() {}
}
