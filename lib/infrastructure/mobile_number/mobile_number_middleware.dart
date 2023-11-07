import 'package:redux/redux.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/mobile_number/mobile_number_action.dart';

class MobileNumberMiddleware extends MiddlewareClass<AppState> {
  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is CreateMobileNumberCommandAction) {
      
    }
  }
}
