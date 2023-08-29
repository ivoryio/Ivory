import 'package:redux/redux.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/device/device_action.dart';

import 'device_service.dart';

class DeviceMiddleware extends MiddlewareClass<AppState> {
  final DeviceService _deviceService;

  DeviceMiddleware(this._deviceService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is CreateDeviceBindingCommandAction) {
      store.dispatch(DeviceLoadingEventAction());
      
    }
  }
}
