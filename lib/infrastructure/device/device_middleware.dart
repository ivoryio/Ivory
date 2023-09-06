import 'package:redux/redux.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/device/device_action.dart';
import 'package:solarisdemo/utilities/device_info/device_info.dart';
import 'package:solarisdemo/utilities/device_info/device_utils.dart';

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
      if (createBindingResponse is CreateDeviceBindingSuccessResponse) {
        store.dispatch(DeviceBindingCreatedEventAction());
      } else {
        store.dispatch(DeviceBindingFailedEventAction());
      }
    }

    if (action is VerifyDeviceBindingSignatureCommandAction) {
      store.dispatch(DeviceBindingLoadingEventAction());
      final deviceId = await DeviceUtils.getDeviceIdFromCache();

      final verifyDeviceBindingChallenegeResponse = await _deviceBindingService.verifyDeviceBindingSignature(
        user: action.user,
        tan: action.tan,
        deviceId: deviceId,
      );
      if (verifyDeviceBindingChallenegeResponse is DeviceBindingServiceErrorResponse) {
        store.dispatch(DeviceBindingFailedEventAction());
        return;
      }

      final createRestrictedKeyResponse = await _deviceBindingService.createRestrictedKey(
        user: action.user,
        deviceId: deviceId,
      );
      if (createRestrictedKeyResponse is DeviceBindingServiceErrorResponse) {
        store.dispatch(DeviceBindingFailedEventAction());
        return;
      }

      store.dispatch(DeviceBindingChallengeVerifiedEventAction());
    }
    


    if (action is FetchBoundDevicesCommandAction) {
      store.dispatch(DeviceBindingLoadingEventAction());
      final deviceName = await _deviceBindingService.deviceInfo.getDeviceName();
      final deviceId = await DeviceUtils.getDeviceIdFromCache();
      List<Device> devices = [];
      if (deviceId != '') {
        Device thisDevice = Device(
          deviceId: deviceId,
          deviceName: deviceName,
        );
        devices.add(thisDevice);
        store.dispatch(BoundDevicesFetchedEventAction(devices, thisDevice));
      } else {
        store.dispatch(BoundDevicesFetchedButEmptyEventAction(Device(
          deviceId: '',
          deviceName: deviceName,
        )));
      }
    }

    if (action is DeleteBoundDeviceCommandAction) {
      store.dispatch(DeviceBindingLoadingEventAction());
      final unpairDeviceResponse = await _deviceBindingService.deleteDeviceBinding(
        user: action.user,
        deviceId: action.deviceId,
      );
      if (unpairDeviceResponse is DeleteDeviceBindingSuccessResponse) {
        store.dispatch(BoundDeviceDeletedEventAction());
      } else {
        store.dispatch(DeviceBindingFailedEventAction());
      }
    }
  }
}
