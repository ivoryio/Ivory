import 'package:solarisdemo/models/change_request/change_request_error_type.dart';
import 'package:solarisdemo/redux/transfer/transfer_action.dart';
import 'package:solarisdemo/redux/transfer/transfer_state.dart';

TransferState transferReducer(TransferState state, dynamic action) {
  if (action is TransferCommandAction || action is ConfirmTransferCommandAction) {
    return TransferLoadingState();
  } else if (action is SendTransferSuccessEventAction) {
    return TransferNeedConfirmationState(transferAuthorizationRequest: action.transferAuthorizationRequest);
  } else if (action is SendTransferFailedEventAction) {
    return TransferFailedState(ChangeRequestErrorType.unknown);
  } else if(action is ConfirmTransferFailedEventAction) {
    return TransferFailedState(action.errorType);
  } else if (action is ConfirmTransferSuccessEventAction) {
    return TransferConfirmedState(amount: action.transfer.amount.value);
  }

  return state;
}
