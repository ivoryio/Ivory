import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/change_request/change_request_service.dart';
import 'package:solarisdemo/infrastructure/device/biometrics_service.dart';
import 'package:solarisdemo/infrastructure/device/device_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_action.dart';
import 'package:solarisdemo/utilities/device_info/device_utils.dart';

class TransactionApprovalMiddleware extends MiddlewareClass<AppState> {
  final ChangeRequestService _changeRequestService;
  final DeviceService _deviceService;
  final BiometricsService _biometricsService;

  TransactionApprovalMiddleware(
    this._changeRequestService,
    this._deviceService,
    this._biometricsService,
  );

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is AuthorizeTransactionApprovalChallengeCommandAction) {
      final consentId = await _deviceService.getConsentId();
      final deviceId = await _deviceService.getDeviceId();
      final deviceData = await _deviceService.getDeviceFingerprint(consentId!);

      final isDeviceIdNotEmpty = deviceId != null && deviceId.isNotEmpty;
      final isDeviceDataNotEmpty = deviceData != null && deviceData.isNotEmpty;

      if (isDeviceIdNotEmpty && isDeviceDataNotEmpty) {
        final response = await _changeRequestService.authorizeWithDevice(
          user: action.user,
          changeRequestId: action.changeRequestId,
          deviceId: deviceId,
          deviceData: deviceData,
        );

        if (response is AuthorizeChangeRequestSuccessResponse) {
          store.dispatch(TransactionApprovalChallengeAuthorizedEventAction(
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

    if (action is ConfirmTransactionApprovalChallengeCommandAction) {
      String? consentId = await _deviceService.getConsentId();

      final isBiometricsAuthenticated =
          await _biometricsService.authenticateWithBiometrics(message: "Please use biometric authentication.");

      if (consentId == null || !isBiometricsAuthenticated) {
        store.dispatch(TransactionApprovalFailedEventAction());
        return;
      }

      final keyPairs = await _deviceService.getDeviceKeyPairs(restricted: true);

      if (keyPairs == null) {
        store.dispatch(TransactionApprovalFailedEventAction());
        return;
      }

      final signature = _deviceService.generateSignature(
        privateKey: keyPairs.privateKey,
        stringToSign: action.stringToSign,
      );

      if (signature == null) {
        store.dispatch(TransactionApprovalFailedEventAction());
        return;
      }

      final response = await _changeRequestService.confirmWithDevice(
        user: action.user,
        changeRequestId: action.changeRequestId,
        deviceData: action.deviceData,
        deviceId: action.deviceId,
        signature: signature,
      );

      if (response is ConfirmChangeRequestSuccessResponse) {
        store.dispatch(TransactionApprovalSucceededEventAction());
      } else {
        store.dispatch(TransactionApprovalFailedEventAction());
      }
    }
  }
}
