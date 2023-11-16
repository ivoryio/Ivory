import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/change_request/change_request_service.dart';
import 'package:solarisdemo/infrastructure/device/biometrics_service.dart';
import 'package:solarisdemo/infrastructure/device/device_fingerprint_service.dart';
import 'package:solarisdemo/infrastructure/device/device_service.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_action.dart';

import '../../redux/auth/auth_state.dart';

class TransactionApprovalMiddleware extends MiddlewareClass<AppState> {
  final DeviceService _deviceService;
  final DeviceFingerprintService _deviceFingerprintService;
  final BiometricsService _biometricsService;
  final ChangeRequestService _changeRequestService;

  TransactionApprovalMiddleware(
    this._changeRequestService,
    this._deviceService,
    this._deviceFingerprintService,
    this._biometricsService,
  );

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final authState = store.state.authState;
    if(authState is! AuthenticatedState) {
      return;
    }

    if (action is AuthorizeTransactionCommandAction) {
      final consentId = await _deviceService.getConsentId();
      final deviceId = await _deviceService.getDeviceId();
      final deviceData = await _deviceFingerprintService.getDeviceFingerprint(consentId);

      final isDeviceIdNotEmpty = deviceId != null && deviceId.isNotEmpty;
      final isDeviceDataNotEmpty = deviceData != null && deviceData.isNotEmpty;

      if (isDeviceIdNotEmpty && isDeviceDataNotEmpty) {
        final response = await _changeRequestService.authorizeWithDevice(
          user: authState.authenticatedUser.cognito,
          changeRequestId: action.changeRequestId,
          deviceId: deviceId,
          deviceData: deviceData,
        );

        if (response is AuthorizeChangeRequestSuccessResponse) {
          store.dispatch(AuthorizedTransactionEventAction(
            changeRequestId: action.changeRequestId,
            stringToSign: response.stringToSign,
            deviceId: deviceId,
            deviceData: deviceData,
          ));
        } else {
          store.dispatch(TransactionApprovalFailedEventAction());
        }
      } else {
        store.dispatch(TransactionApprovalDeviceNotBoundedEventAction());
      }
    }

    if (action is ConfirmTransactionCommandAction) {
      final response = await _confirmWithDevice(
        store,
        stringToSign: action.stringToSign,
        user: authState.authenticatedUser.cognito,
        changeRequestId: action.changeRequestId,
        deviceData: action.deviceData,
        deviceId: action.deviceId,
      );

      if (response is ConfirmChangeRequestSuccessResponse) {
        store.dispatch(TransactionConfirmedEventAction());
      } else {
        store.dispatch(TransactionApprovalFailedEventAction());
      }
    }

    if (action is RejectTransactionCommandAction) {
      final authorizeResponse = await _changeRequestService.authorizeWithDevice(
        user:authState.authenticatedUser.cognito,
        changeRequestId: action.declineChangeRequestId,
        deviceId: action.deviceId,
        deviceData: action.deviceData,
      );

      if (authorizeResponse is AuthorizeChangeRequestSuccessResponse) {
        final response = await _confirmWithDevice(
          store,
          stringToSign: authorizeResponse.stringToSign,
          user: authState.authenticatedUser.cognito,
          changeRequestId: action.declineChangeRequestId,
          deviceData: action.deviceData,
          deviceId: action.deviceId,
        );

        if (response is ConfirmChangeRequestSuccessResponse) {
          store.dispatch(TransactionRejectedEventAction());
        } else {
          store.dispatch(TransactionApprovalFailedEventAction());
        }
      } else {
        store.dispatch(TransactionApprovalFailedEventAction());
      }
    }
  }

  Future<ChangeRequestServiceResponse?> _confirmWithDevice(
    Store<AppState> store, {
    required String stringToSign,
    required User user,
    required String changeRequestId,
    required String deviceData,
    required String deviceId,
  }) async {
    String? consentId = await _deviceService.getConsentId();

    final isBiometricsAuthenticated =
        await _biometricsService.authenticateWithBiometrics(message: "Please use biometric authentication.");

    if (consentId == null || !isBiometricsAuthenticated) {
      store.dispatch(TransactionApprovalFailedEventAction());
      return null;
    }

    final keyPairs = await _deviceService.getDeviceKeyPairs(restricted: true);

    if (keyPairs == null) {
      store.dispatch(TransactionApprovalFailedEventAction());
      return null;
    }

    final signature = _deviceService.generateSignature(
      privateKey: keyPairs.privateKey,
      stringToSign: stringToSign,
    );

    if (signature == null) {
      store.dispatch(TransactionApprovalFailedEventAction());
      return null;
    }

    return await _changeRequestService.confirmWithDevice(
      user: user,
      changeRequestId: changeRequestId,
      deviceData: deviceData,
      deviceId: deviceId,
      signature: signature,
    );
  }
}
