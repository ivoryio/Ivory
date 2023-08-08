import 'package:flutter/material.dart';

class NavigationLoggingObserver extends RouteObserver<ModalRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print("[PUSH] ${previousRoute?.settings.name} ⬆️ ${route.settings.name}");
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print("[POP] ${route.settings.name} ⬇️ ${previousRoute?.settings.name}");
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print("[REMOVE] ${route.settings.name} ➡️ ${previousRoute?.settings.name}");
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    print("[REPLACE] ${oldRoute?.settings.name} ➡️ ${newRoute?.settings.name}");
  }
}
