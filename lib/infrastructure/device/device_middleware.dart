import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarisdemo/infrastructure/device/device_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/device/device_action.dart';
import 'package:solarisdemo/utilities/device_info/device_info.dart';

import '../../models/device.dart';
import 'device_binding_service.dart';

class DeviceBindingMiddleware extends MiddlewareClass<AppState> {
  final DeviceInfoService _deviceInfoService;
  final DeviceBindingService _deviceBindingService;
  final DeviceService _deviceService;

  DeviceBindingMiddleware(this._deviceBindingService, this._deviceService, this._deviceInfoService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is CreateDeviceBindingCommandAction) {
      store.dispatch(DeviceBindingLoadingEventAction());

      String? consentId = await _deviceService.getConsentId();

      if (consentId == null) {
        store.dispatch(DeviceBindingFailedEventAction());
        return null;
      }

      String? deviceFingerPrint = await _deviceService.getDeviceFingerprint(consentId);
      if (deviceFingerPrint == null || deviceFingerPrint.isEmpty) {
        store.dispatch(DeviceBindingFailedEventAction());
        return null;
      }

      DeviceKeyPairs? newKeypair = _deviceService.generateECKey();
      if (newKeypair == null) {
        store.dispatch(DeviceBindingFailedEventAction());
        return null;
      }

      await _deviceService.saveKeyPairIntoCache(
        keyPair: newKeypair,
      );

      String deviceName = await _deviceInfoService.getDeviceName();

      if (action.user.personId == null) {
        store.dispatch(DeviceBindingFailedEventAction());
        return null;
      }
      final createBindingResponse = await _deviceBindingService.createDeviceBinding(
          user: action.user,
          reqBody: CreateDeviceBindingRequest(
            personId: action.user.personId!,
            key: newKeypair.publicKey,
            name: deviceName,
            deviceData: deviceFingerPrint,
          ));
      if (createBindingResponse is CreateDeviceBindingSuccessResponse) {
        await _deviceService.saveDeviceIdIntoCache(createBindingResponse.deviceId);
        store.dispatch(DeviceBindingCreatedEventAction());
      } else {
        store.dispatch(DeviceBindingFailedEventAction());
      }
    }

    if (action is VerifyDeviceBindingSignatureCommandAction) {
      store.dispatch(DeviceBindingLoadingEventAction());

      final deviceId = await _deviceService.getDeviceId();
      String? consentId = await _deviceService.getConsentId();

      if (consentId == null) {
        store.dispatch(DeviceBindingFailedEventAction());
        return null;
      }

      String? deviceFingerPrint = await _deviceService.getDeviceFingerprint(consentId);
      if (deviceFingerPrint == null || deviceFingerPrint.isEmpty) {
        store.dispatch(DeviceBindingFailedEventAction());
        return null;
      }

      final existingUnrestrictedKeyPair = await _deviceService.getDeviceKeyPairs();

      if (existingUnrestrictedKeyPair == null) {
        store.dispatch(DeviceBindingFailedEventAction());
        return null;
      }

      final signature = _deviceService.generateSignature(
        privateKey: existingUnrestrictedKeyPair.privateKey,
        stringToSign: action.tan,
      );

      if (signature == null) {
        store.dispatch(DeviceBindingFailedEventAction());
        return null;
      }

      final verifyDeviceBindingChallenegeResponse = await _deviceBindingService.verifyDeviceBindingSignature(
        user: action.user,
        deviceId: deviceId!,
        deviceFingerPrint: deviceFingerPrint,
        signature: signature,
      );
      if (verifyDeviceBindingChallenegeResponse is DeviceBindingServiceErrorResponse) {
        store.dispatch(DeviceBindingFailedEventAction());
        return null;
      }

      DeviceKeyPairs? newKeypair = _deviceService.generateECKey();
      if (newKeypair == null) {
        store.dispatch(DeviceBindingFailedEventAction());
        return null;
      }

      final signatureForRestrictedKey = _deviceService.generateSignature(
        privateKey: existingUnrestrictedKeyPair.privateKey,
        stringToSign: newKeypair.publicKey,
      );

      if (signatureForRestrictedKey == null) {
        store.dispatch(DeviceBindingFailedEventAction());
        return null;
      }

      CreateRestrictedKeyRequest reqBody = CreateRestrictedKeyRequest(
        deviceId: deviceId,
        deviceData: deviceFingerPrint,
        deviceSignature: DeviceSignature(
          signature: signatureForRestrictedKey,
        ),
        key: newKeypair.publicKey,
      );

      final createRestrictedKeyResponse = await _deviceBindingService.createRestrictedKey(
        user: action.user,
        reqBody: reqBody,
      );
      if (createRestrictedKeyResponse is DeviceBindingServiceErrorResponse) {
        store.dispatch(DeviceBindingFailedEventAction());
        return null;
      }

      await _deviceService.saveKeyPairIntoCache(
        keyPair: newKeypair,
        restricted: true,
      );

      store.dispatch(DeviceBindingChallengeVerifiedEventAction(
        Device(
          deviceId: deviceId,
          deviceName: await _deviceInfoService.getDeviceName(),
        ),
      ));
    }

    if (action is FetchBoundDevicesCommandAction) {
      store.dispatch(DeviceBindingLoadingEventAction());
      final deviceName = await _deviceInfoService.getDeviceName();
      final deviceId = await _deviceService.getDeviceId();
      List<Device> devices = [];
      if (deviceId != '') {
        Device thisDevice = Device(
          deviceId: deviceId!,
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

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('device_id');
      prefs.remove('restrictedKeyPair');
      prefs.remove('unrestrictedKeyPair');

      if (unpairDeviceResponse is DeleteDeviceBindingSuccessResponse) {
        store.dispatch(BoundDeviceDeletedEventAction());
      } else {
        store.dispatch(DeviceBindingFailedEventAction());
      }
    }

    if (action is DeleteIncompleteDeviceBindingCommandAction) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('device_id');
      prefs.remove('restrictedKeyPair');
      prefs.remove('unrestrictedKeyPair');

      final deviceName = await _deviceInfoService.getDeviceName();

      Device thisDevice = Device(
        deviceId: '',
        deviceName: deviceName,
      );
      store.dispatch(BoundDevicesFetchedButEmptyEventAction(thisDevice));
    }
  }
}
