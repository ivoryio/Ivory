import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarisdemo/infrastructure/device/device_fingerprint_service.dart';
import 'package:solarisdemo/infrastructure/device/device_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/device/device_action.dart';
import 'package:solarisdemo/utilities/device_info/device_info.dart';

import '../../models/device.dart';
import '../../redux/auth/auth_state.dart';
import 'device_binding_service.dart';

class DeviceBindingMiddleware extends MiddlewareClass<AppState> {
  final DeviceInfoService _deviceInfoService;
  final DeviceBindingService _deviceBindingService;
  final DeviceService _deviceService;
  final DeviceFingerprintService _deviceFingerprintService;

  DeviceBindingMiddleware(this._deviceBindingService, this._deviceService, this._deviceInfoService, this._deviceFingerprintService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final authState = store.state.authState;

    if (action is CreateDeviceBindingCommandAction) {
      if(authState is! AuthenticatedState) {
        return;
      }

      store.dispatch(DeviceBindingLoadingEventAction());

      String? consentId = await _deviceService.getConsentId();

      if (consentId == null) {
        store.dispatch(DeviceBindingFailedEventAction());
        return null;
      }

      String? deviceFingerPrint = await _deviceFingerprintService.getDeviceFingerprint(consentId);
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

      if (authState.authenticatedUser.cognito.personId == null) {
        store.dispatch(DeviceBindingFailedEventAction());
        return null;
      }
      final createBindingResponse = await _deviceBindingService.createDeviceBinding(
          user: authState.authenticatedUser.cognito,
          reqBody: CreateDeviceBindingRequest(
            personId: authState.authenticatedUser.cognito.personId!,
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
      if(authState is! AuthenticatedState) {
        return;
      }

      store.dispatch(DeviceBindingLoadingEventAction());

      final deviceId = await _deviceService.getDeviceId();
      String? consentId = await _deviceService.getConsentId();

      if (consentId == null) {
        store.dispatch(DeviceBindingFailedEventAction());
        return null;
      }

      String? deviceFingerPrint = await _deviceFingerprintService.getDeviceFingerprint(consentId);
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
        user: authState.authenticatedUser.cognito,
        deviceId: deviceId!,
        deviceFingerPrint: deviceFingerPrint,
        signature: signature,
      );
      if (verifyDeviceBindingChallenegeResponse is DeviceBindingServiceErrorResponse) {
        store.dispatch(DeviceBindingChallengeVerificationFailedEventAction(deviceId));
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
        user: authState.authenticatedUser.cognito,
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
      if(authState is! AuthenticatedState) {
        return;
      }

      store.dispatch(DeviceBindingLoadingEventAction());
      final unpairDeviceResponse = await _deviceBindingService.deleteDeviceBinding(
        user: authState.authenticatedUser.cognito,
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
