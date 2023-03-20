import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';
import '../screens/landing/landing_screen.dart';
import '../screens/profile/profile_screen.dart';
import 'routing_constants.dart';
import '../screens/home/home_screen.dart';
import '../screens/login/login_screen.dart';
import '../cubits/auth_cubit/auth_cubit.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/wallet_screen/wallet_screen.dart';
import '../screens/transactions/transactions_screen.dart';

class AppRouter {
  final _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'rootNavigatorKey');

  final AuthCubit loginCubit;
  AppRouter(this.loginCubit);

  late final router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: splashScreenRoutePath,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: splashScreenRoute.path,
          name: splashScreenRouteName,
          builder: (BuildContext context, GoRouterState state) {
            return const SplashScreen();
          },
        ),
        GoRoute(
            path: landingRoute.path,
            name: landingRoute.name,
            builder: (BuildContext context, GoRouterState state) {
              return const LandingScreen();
            }),
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
        final bool loggedIn =
            loginCubit.state.status == AuthStatus.authenticated;
        final bool logginIn = state.subloc == loginPageRoutePath;
        final bool splashScreen = state.subloc == splashScreenRoutePath;

        if (!loggedIn && !splashScreen) {
          return logginIn ? null : landingRoute.path;
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
