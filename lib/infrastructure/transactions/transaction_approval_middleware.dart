import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/change_request/change_request_service.dart';
import 'package:solarisdemo/models/change_request/change_request_delivery_method.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_action.dart';

class TransactionApprovalMiddleware extends MiddlewareClass<AppState> {
  final ChangeRequestService _changeRequestService;

  TransactionApprovalMiddleware(this._changeRequestService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is TransactionApprovalRequestChallengeCommandAction) {
      final response = await _changeRequestService.authorize(
        user: action.user,
        changeRequestId: action.changeRequestId,
        deliveryMethod: ChangeRequestDeliveryMethod.deviceSigning,
        deviceId: action.deviceId,
        deviceData: action.deviceData,
      );

      if (response is AuthorizeChangeRequestSuccessResponse) {
        store.dispatch(TransactionApprovalChallengeFetchedEventAction(
          changeRequestId: action.changeRequestId,
          stringToSign: response.stringToSign,
        ));
      } else {
        store.dispatch(TransactionApprovalFailedEventAction());
      }
    }
  }
}
