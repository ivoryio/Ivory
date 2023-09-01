import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/change_request/change_request_service.dart';
import 'package:solarisdemo/infrastructure/device/device_service.dart';
import 'package:solarisdemo/models/change_request/change_request_delivery_method.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_action.dart';

class TransactionApprovalMiddleware extends MiddlewareClass<AppState> {
  final ChangeRequestService _changeRequestService;

  TransactionApprovalMiddleware(this._changeRequestService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is RequestTransactionApprovalChallengeCommandAction) {
      final consentId = await DeviceService.getDeviceConsentId();
      final deviceId = await DeviceService.getDeviceIdFromCache();
      final deviceData = await DeviceService.getDeviceFingerprint(consentId);

      final isDeviceIdNotEmpty = deviceId != null && deviceId.isNotEmpty;
      final isDeviceDataNotEmpty = deviceData != null && deviceData.isNotEmpty;

      if (isDeviceIdNotEmpty && isDeviceDataNotEmpty) {
        final response = await _changeRequestService.authorize(
          user: action.user,
          changeRequestId: action.changeRequestId,
          deliveryMethod: ChangeRequestDeliveryMethod.deviceSigning,
          deviceId: deviceId,
          deviceData: deviceData,
        );

        if (response is AuthorizeChangeRequestSuccessResponse) {
          store.dispatch(TransactionApprovalChallengeFetchedEventAction(
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
  }
}
