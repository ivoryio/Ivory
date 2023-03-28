import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/login/login_passcode.dart';
import '../screens/login/login_passcode_error.dart';
import '../screens/signup/signup_screen.dart';

import '../screens/landing/landing_screen.dart';
import '../screens/profile/profile_screen.dart';
import 'routing_constants.dart';
import '../screens/home/home_screen.dart';
import '../screens/login/login_screen.dart';
import '../cubits/auth_cubit/auth_cubit.dart';
import '../screens/wallet_screen/wallet_screen.dart';
import '../screens/transactions/transactions_screen.dart';

class AppRouter {
  final _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'rootNavigatorKey');

  final AuthCubit loginCubit;
  AppRouter(this.loginCubit);

  late final router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: landingRoute.path,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
            path: landingRoute.path,
            name: landingRoute.name,
            builder: (BuildContext context, GoRouterState state) {
              return const LandingScreen();
            }),
        GoRoute(
          path: loginRoute.path,
          name: loginRoute.name,
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          },
        ),
        GoRoute(
          path: loginPasscodeRoute.path,
          name: loginPasscodeRoute.name,
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPasscodeScreen();
          },
        ),
        GoRoute(
          path: loginPasscodeErrorRoute.path,
          name: loginPasscodeErrorRoute.name,
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPasscodeErrorScreen();
          },
        ),
        GoRoute(
          path: signupRoute.path,
          name: signupRoute.name,
          builder: (BuildContext context, GoRouterState state) {
            return const SignupScreen();
          },
        ),
        GoRoute(
          path: homeRoute.path,
          name: homeRoute.name,
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: walletRoute.path,
          name: walletRoute.name,
          builder: (BuildContext context, GoRouterState state) {
            return const WalletScreen();
          },
        ),
        GoRoute(
          path: transactionsRoute.path,
          name: transactionsRoute.name,
          builder: (BuildContext context, GoRouterState state) {
            return const TransactionsScreen();
          },
        ),
        GoRoute(
          path: profileRoute.path,
          name: profileRoute.name,
          builder: (BuildContext context, GoRouterState state) {
            return const ProfileScreen();
          },
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        final bool isAuthenticated =
            loginCubit.state.status == AuthStatus.authenticated;
        final bool isOnLoginPage = state.subloc.startsWith(loginRoute.path);

        if (isAuthenticated && isOnLoginPage) {
          return homeRoute.path;
        }

        return null;
      },
      refreshListenable: GoRouterRefreshStream(loginCubit.stream));

  static int calculateSelectedIndex(BuildContext context) {
    final GoRouter route = GoRouter.of(context);
    final String location = route.location;

    if (location == homeRoute.path) {
      return homeRoute.navbarIndex!;
    }
    if (location == walletRoute.path) {
      return walletRoute.navbarIndex!;
    }
    if (location == transactionsRoute.path) {
      return transactionsRoute.navbarIndex!;
    }
    if (location == profileRoute.path) {
      return profileRoute.navbarIndex!;
    }

    return 0;
  }

  static void navigateToPage(int pageIndex, BuildContext context) {
    if (pageIndex == homeRoute.navbarIndex) {
      context.push(homeRoute.path);
    }
    if (pageIndex == walletRoute.navbarIndex) {
      context.push(walletRoute.path);
    }
    if (pageIndex == transactionsRoute.navbarIndex) {
      context.push(transactionsRoute.path);
    }
    if (pageIndex == profileRoute.navbarIndex) {
      context.push(profileRoute.path);
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
