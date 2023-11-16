import 'package:solarisdemo/redux/transactions/approval/transaction_approval_action.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_state.dart';

TransactionApprovalState transactionApprovalReducer(TransactionApprovalState state, dynamic action) {
  if (action is AuthorizeTransactionCommandAction ||
      action is ConfirmTransactionCommandAction ||
      action is RejectTransactionCommandAction) {
    return TransactionApprovalLoadingState();
  } else if (action is AuthorizedTransactionEventAction) {
    return TransactionApprovalAuthorizedState(
      deviceId: action.deviceId,
      deviceData: action.deviceData,
      stringToSign: action.stringToSign,
      changeRequestId: action.changeRequestId,
    );
  } else if (action is TransactionApprovalFailedEventAction) {
    return TransactionApprovalFailedState();
  } else if (action is TransactionConfirmedEventAction) {
    return TransactionApprovalSucceededState();
  } else if (action is TransactionRejectedEventAction) {
    return TransactionApprovalRejectedState();
  } else if (action is TransactionApprovalDeviceNotBoundedEventAction) {
    return TransactionApprovalDeviceNotBoundedState();
  }

  return state;
}
