import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:solaris_structure_1/main.dart';
import 'package:solaris_structure_1/router/routing_constants.dart';
import 'package:solaris_structure_1/screens/hub/hub_screen.dart';
import 'package:solaris_structure_1/screens/home/home_screen.dart';
import 'package:solaris_structure_1/screens/login/login_screen.dart';
import 'package:solaris_structure_1/screens/transfer/transfer_screen.dart';

import '../cubits/login_cubit/login_cubit.dart';

class AppRouter {
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _shellNavigatorKey = GlobalKey<NavigatorState>();

  final LoginCubit loginCubit;
  AppRouter(this.loginCubit);

  late final router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: homePageRoutePath,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: loginPageRoutePath,
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          },
        ),
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return AppScaffold(child: child);
          },
          routes: [
            GoRoute(
              path: homePageRoutePath,
              name: homePageRouteName,
              builder: (BuildContext context, GoRouterState state) {
                return const HomeScreen();
              },
            ),
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

        if (!loggedIn) {
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
    if (location.startsWith(homePageRoutePath)) {
      return 0;
    }
    if (location.startsWith(transferPageRoutePath)) {
      return 1;
    }
    if (location.startsWith(hubPageRoutePath)) {
      return 2;
    }
    return 0;
  }

  static void navigateToPage(int pageIndex, BuildContext context) {
    switch (pageIndex) {
      case 0:
        context.push(homePageRoutePath);
        break;
      case 1:
        context.push(transferPageRoutePath);
        break;
      case 2:
        context.push(hubPageRoutePath);
        break;
      default:
        context.push(homePageRouteName);
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
