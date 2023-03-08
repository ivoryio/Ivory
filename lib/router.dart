import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:solaris_structure_1/main.dart';
import 'package:solaris_structure_1/screens/hub/hub_screen.dart';
import 'package:solaris_structure_1/screens/home/home_screen.dart';
import 'package:solaris_structure_1/screens/transfer/transfer_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  debugLogDiagnostics: true,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AppScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: '/transfer',
          builder: (BuildContext context, GoRouterState state) {
            return const TransferScreen();
          },
        ),
        GoRoute(
          path: '/hub',
          builder: (BuildContext context, GoRouterState state) {
            return const HubScreen();
          },
        ),
      ],
    ),
  ],
);

int calculateSelectedIndex(BuildContext context) {
  final GoRouter route = GoRouter.of(context);
  final String location = route.location;
  if (location.startsWith('/home')) {
    return 0;
  }
  if (location.startsWith('/transfer')) {
    return 1;
  }
  if (location.startsWith('/hub')) {
    return 2;
  }
  return 0;
}

void onTap(int value, BuildContext context) {
  switch (value) {
    case 0:
      context.push('/home');
      break;
    case 1:
      context.push('/transfer');
      break;
    case 2:
      context.push('/hub');
      break;
    default:
      context.push('/home');
  }
}
