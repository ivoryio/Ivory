import 'package:flutter/material.dart';

class NavigationGeneralObserver extends RouteObserver<ModalRoute<dynamic>> {
  List<String> routeStack = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    routeStack.add(route.settings.name ?? '');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    if (routeStack.length > 1) {
      routeStack.removeLast();
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    routeStack.removeWhere((element) => route.settings.name == element);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    routeStack.removeWhere((element) => oldRoute?.settings.name == element);
    routeStack.add(newRoute?.settings.name ?? '');
  }

  bool isRouteInStack(String routeName) {
    return routeStack.contains(routeName);
  }

  bool isRouteInStackButNotCurrent(String routeName) {
    return routeStack.contains(routeName) && routeStack.last != routeName;
  }
}
