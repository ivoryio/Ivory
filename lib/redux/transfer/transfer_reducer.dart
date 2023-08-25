import 'package:solarisdemo/redux/transfer/transfer_action.dart';
import 'package:solarisdemo/redux/transfer/transfer_state.dart';

TransferState transferReducer(TransferState state, dynamic action) {
  if (action is TransferCommandAction || action is ConfirmTransferCommandAction) {
    return TransferLoadingState();
  } else if (action is SendTransferSuccessEventAction) {
    return TransferNeedConfirmationState(transferAuthorizationRequest: action.transferAuthorizationRequest);
  } else if (action is SendTransferFailedEventAction || action is ConfirmTransferFailedEventAction) {
    return TransferFailedState();
  } else if (action is ConfirmTransferSuccessEventAction) {
    return TransferConfirmedState();
  }

  return state;
}
