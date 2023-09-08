import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/change_request/change_request_service.dart';
import 'package:solarisdemo/infrastructure/transfer/transfer_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/transfer/transfer_action.dart';

class TransferMiddleware extends MiddlewareClass<AppState> {
  final TransferService _transferService;
  final ChangeRequestService _changeRequestService;

  TransferMiddleware(this._transferService, this._changeRequestService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is TransferCommandAction) {
      final response = await _transferService.createPayoutTransfer(
          user: action.user, transfer: action.transfer);

      if (response is CreatePayoutTransferSuccessResponse) {
        store.dispatch(
          SendTransferSuccessEventAction(
            transferAuthorizationRequest: response.transferAuthorizationRequest,
          ),
        );
      } else {
        store.dispatch(SendTransferFailedEventAction());
      }
    } else if (action is ConfirmTransferCommandAction) {
      final response = await _changeRequestService.confirmTransferChangeRequest(
        user: action.user,
        changeRequestId: action.changeRequestId,
        tan: action.tan,
      );

      if (response is ConfirmTransferChangeRequestSuccessResponse) {
        store.dispatch(
          ConfirmTransferSuccessEventAction(
            transfer: response.transferConfirmation.transfer,
          ),
        );
      } else {
        store.dispatch(ConfirmTransferFailedEventAction());
      }
    }
  }
}
