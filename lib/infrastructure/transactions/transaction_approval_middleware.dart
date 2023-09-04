import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/change_request/change_request_service.dart';
import 'package:solarisdemo/infrastructure/device/device_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_action.dart';
import 'package:solarisdemo/utilities/crypto/crypto_message_signer.dart';

class TransactionApprovalMiddleware extends MiddlewareClass<AppState> {
  final ChangeRequestService _changeRequestService;

  TransactionApprovalMiddleware(this._changeRequestService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is AuthorizeTransactionApprovalChallengeCommandAction) {
      final consentId = await DeviceService.getDeviceConsentId();
      final deviceId = await DeviceService.getDeviceIdFromCache();
      final deviceData = await DeviceService.getDeviceFingerprint(consentId);

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
      final isBiometricsAuthenticated =
          await BiometricAuthentication(message: 'Please use biometric authentication.').authenticateWithBiometrics();

      if (!isBiometricsAuthenticated) {
        store.dispatch(TransactionApprovalFailedEventAction());
        return;
      }

      final privateKey = await DeviceService.getPrivateKeyFromCache(restricted: true);

      if (privateKey == null) {
        store.dispatch(TransactionApprovalFailedEventAction());
        return;
      }

      final signature = CryptoMessageSigner().signMessage(
        message: action.stringToSign,
        encodedPrivateKey: privateKey,
      );

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
