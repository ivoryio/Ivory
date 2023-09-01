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
        return;
      }

      final verifyDeviceBindingChallenegeResponse = await _deviceBindingService.verifyDeviceBindingSignature(
        user: action.user,
        tan: '212212',
        deviceId: (createBindingResponse as CreateDeviceBindingSuccessResponse).deviceId,
      );
      if (verifyDeviceBindingChallenegeResponse is DeviceBindingServiceErrorResponse) {
        store.dispatch(DeviceBindingFailedEventAction());
        return;
      }

      final createRestrictedKeyResponse = await _deviceBindingService.createRestrictedKey(
        user: action.user,
        deviceId: createBindingResponse.deviceId,
      );
      if (createRestrictedKeyResponse is DeviceBindingServiceErrorResponse) {
        store.dispatch(DeviceBindingFailedEventAction());
        return;
      }

      List<Device> devices = [];
      Device thisDevice = Device(
        deviceId: createBindingResponse.deviceId,
        deviceName: createBindingResponse.deviceName,
      );

      //refactor this logic after final implementation
      devices.add(thisDevice);
      store.dispatch(BoundDevicesFetchedEventAction(devices, thisDevice));
    }

    if (action is FetchBoundDevicesCommandAction) {
      store.dispatch(DeviceBindingLoadingEventAction());
      final deviceName = await DeviceBindingService.getDeviceName();
      final deviceId = await DeviceBindingService.getDeviceIdFromCache();
      List<Device> devices = [];
      if (deviceId != '') {
        Device thisDevice = Device(
          deviceId: deviceId,
          deviceName: deviceName,
        );
        //refactor this logic after final implementation
        devices.add(thisDevice);
        store.dispatch(BoundDevicesFetchedEventAction(devices, thisDevice));
      } else {
        store.dispatch(BoundDevicesFetchedButEmptyEventAction(Device(
          deviceId: '',
          deviceName: deviceName,
        )));
      }
    }
  }
}
