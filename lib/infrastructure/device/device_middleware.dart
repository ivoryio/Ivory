import 'package:redux/redux.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/device/device_action.dart';

import '../../models/device.dart';
import 'device_service.dart';

class DeviceBindingMiddleware extends MiddlewareClass<AppState> {
  final DeviceBindingService _deviceBindingService;

  DeviceBindingMiddleware(this._deviceBindingService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is CreateDeviceBindingCommandAction) {
      store.dispatch(DeviceBindingLoadingEventAction());

      final createBindingResponse = await _deviceBindingService.createDeviceBinding(user: action.user);
      if (createBindingResponse is DeviceBindingServiceErrorResponse) {
        store.dispatch(DeviceBindingFailedEventAction());
      }

      final verifyDeviceBindingChallenegeResponse = await _deviceBindingService.verifyDeviceBindingSignature(
        user: action.user,
        tan: '212212',
        deviceId: (createBindingResponse as CreateDeviceBindingSuccessResponse).deviceId,
      );
      if (verifyDeviceBindingChallenegeResponse is DeviceBindingServiceErrorResponse) {
        store.dispatch(DeviceBindingFailedEventAction());
      }

      final createRestrictedKeyResponse = await _deviceBindingService.createRestrictedKey(
        user: action.user,
        deviceId: createBindingResponse.deviceId,
      );
      if (createRestrictedKeyResponse is DeviceBindingServiceErrorResponse) {
        store.dispatch(DeviceBindingFailedEventAction());
      }

      List<Device> devices = [];
      devices.add(Device(
        deviceId: createBindingResponse.deviceId,
        deviceName: createBindingResponse.deviceName,
      ));

      store.dispatch(BoundDevicesFetchedEventAction(devices));
    }

    if (action is FetchBoundDevicesCommandAction) {
      store.dispatch(DeviceBindingLoadingEventAction());
      final deviceName = await DeviceBindingService.getDeviceName();
      final deviceId = await DeviceBindingService.getDeviceIdFromCache();
      List<Device> devices = [];
      if (deviceId != '') {
        devices.add(Device(
          deviceId: deviceId,
          deviceName: deviceName,
        ));
        store.dispatch(BoundDevicesFetchedEventAction(devices));
      } else {
        devices.add(Device(
          deviceId: '',
          deviceName: deviceName,
        ));
        store.dispatch(BoundDevicesFetchedButEmptyEventAction(devices));
      }
    }
  }
}
