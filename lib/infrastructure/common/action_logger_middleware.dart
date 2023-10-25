import 'dart:developer';

import 'package:redux/redux.dart';
import 'package:solarisdemo/redux/app_state.dart';

class ActionLoggerMiddleware extends MiddlewareClass<AppState> {
  @override
  call(Store<AppState> store, action, NextDispatcher next) {
    next(action);

    if (action is Object) {
      log(action.runtimeType.toString(), name: "DISPATCH");
    }
  }
}
