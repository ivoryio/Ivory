import 'package:redux/redux.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/device/device_action.dart';

import 'device_service.dart';

class DeviceBindingMiddleware extends MiddlewareClass<AppState> {
  final DeviceBindingService _deviceBindingService;

  DeviceBindingMiddleware(this._deviceBindingService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is CreateDeviceBindingCommandAction) {
      store.dispatch(DeviceBindingLoadingEventAction());
    }

    if (action is FetchBoundDevicesCommandAction) {
      store.dispatch(DeviceBindingLoadingEventAction());
      final deviceName = await DeviceBindingService.getDeviceName();
      final deviceId = await DeviceBindingService.getDeviceIdFromCache();
      if (deviceId != '') {
        store.dispatch(BoundDevicesFetchedEventAction(
          deviceId: deviceId,
          deviceName: deviceName,
        ));
      } else {
        store.dispatch(BoundDevicesFetchedButEmptyEventAction(
          deviceName: deviceName,
        ));
      }
    }
  }
}
