import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/change_request/change_request_service.dart';
import 'package:solarisdemo/infrastructure/transfer/transfer_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/transfer/transfer_action.dart';

import '../../redux/auth/auth_state.dart';

class TransferMiddleware extends MiddlewareClass<AppState> {
  final TransferService _transferService;
  final ChangeRequestService _changeRequestService;

  TransferMiddleware(this._transferService, this._changeRequestService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final authState = store.state.authState;
    if(authState is! AuthenticatedState) {
      return;
    }


    if (action is TransferCommandAction) {
      final response = await _transferService.createPayoutTransfer(
        user: authState.authenticatedUser.cognito,
        transfer: action.transfer,
      );

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
        user: authState.authenticatedUser.cognito,
        changeRequestId: action.changeRequestId,
        tan: action.tan,
      );

      if (response is ConfirmTransferChangeRequestSuccessResponse) {
        store.dispatch(
          ConfirmTransferSuccessEventAction(
            transfer: response.transferConfirmation.transfer,
          ),
        );
      } else if(response is ChangeRequestServiceErrorResponse) {
        store.dispatch(ConfirmTransferFailedEventAction(response.errorType));
      }
    }
  }
}
