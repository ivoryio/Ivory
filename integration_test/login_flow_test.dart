import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
// ignore: library_prefixes
import 'package:solarisdemo/router/routing_constants.dart';
import 'package:solarisdemo/screens/landing/landing_screen.dart';
import 'package:solarisdemo/screens/login/login_screen.dart';
import 'package:solarisdemo/services/auth_service.dart';
// package:flutter_tools/src/test/integration_test_device.dart

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Login Interface Test', (WidgetTester tester) async {
    //Arrange
    final authCubit = AuthCubit(authService: AuthService());

    final goRouter = GoRouter(
      routes: [
        GoRoute(
          path: landingRoute.path,
          name: landingRoute.name,
          pageBuilder: (context, state) => MaterialPage<void>(
            child: BlocProvider.value(
              value: authCubit,
              child: const LandingScreen(),
            ),
          ),
        ),
        GoRoute(
          path: loginRoute.path,
          name: loginRoute.name,
          pageBuilder: (context, state) => MaterialPage<void>(
            child: BlocProvider.value(
              value: authCubit,
              child: const LoginScreen(),
            ),
          ),
        ),
      ],
      initialLocation: landingRoute.path,
    );
    await tester.pumpWidget(
      MaterialApp.router(
        routerDelegate: goRouter.routerDelegate,
        routeInformationParser: goRouter.routeInformationParser,
        routeInformationProvider: goRouter.routeInformationProvider,
      ),
    );

    Finder loginButton = find.text('Login');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    print('aici e printul $loginButton');

    // Check if the current page is the login page
    expect(goRouter.location, equals(loginRoute.path));
  });
}

class IntegrationTestWidgetsFlutterBinding {
  static void ensureInitialized() {}
}
