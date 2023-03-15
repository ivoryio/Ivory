import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';
import '../screens/splash/splash_screen.dart';
import 'routing_constants.dart';
import '../cubits/auth_cubit/auth_cubit.dart';
import '../screens/home/home_screen.dart';
import '../screens/hub/hub_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/transfer/transfer_screen.dart';

class AppRouter {
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _shellNavigatorKey = GlobalKey<NavigatorState>();

  final AuthCubit loginCubit;
  AppRouter(this.loginCubit);

  late final router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: splashScreenRoutePath,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: splashScreenRoutePath,
          name: splashScreenRouteName,
          builder: (BuildContext context, GoRouterState state) {
            return const SplashScreen();
          },
        ),
        GoRoute(
          path: loginPageRoutePath,
          name: loginPageRouteName,
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          },
        ),
        GoRoute(
          path: homePageRoutePath,
          name: homePageRouteName,
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return AppScaffold(child: child);
          },
          routes: [
            GoRoute(
              path: transferPageRoutePath,
              name: transferPageRouteName,
              builder: (BuildContext context, GoRouterState state) {
                return const TransferScreen();
              },
            ),
            GoRoute(
              path: hubPageRoutePath,
              name: hubPageRouteName,
              builder: (BuildContext context, GoRouterState state) {
                return const HubScreen();
              },
            ),
          ],
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        final bool loggedIn =
            loginCubit.state.status == AuthStatus.authenticated;
        final bool logginIn = state.subloc == loginPageRoutePath;
        final bool splashScreen = state.subloc == splashScreenRoutePath;

        if (!loggedIn && !splashScreen) {
          return logginIn ? null : loginPageRoutePath;
        }
        if (logginIn) {
          return homePageRoutePath;
        }
        return null;
      },
      refreshListenable: GoRouterRefreshStream(loginCubit.stream));

  static int calculateSelectedIndex(BuildContext context) {
    final GoRouter route = GoRouter.of(context);
    final String location = route.location;

    if (location.startsWith(transferPageRoutePath)) {
      return 2;
    }

    return 0;
  }

  static void navigateToPage(int pageIndex, BuildContext context) {
    switch (pageIndex) {
      case 0:
        context.push(homePageRoutePath);
        break;
      case 2:
        context.push(transferPageRoutePath);
        break;
      default:
        context.push(homePageRoutePath);
    }
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((dynamic _) {
      notifyListeners();
    });
  }
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
