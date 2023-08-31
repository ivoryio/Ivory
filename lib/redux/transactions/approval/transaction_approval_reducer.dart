import 'package:solarisdemo/redux/transactions/approval/transaction_approval_action.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_state.dart';

TransactionApprovalState transactionApprovalReducer(TransactionApprovalState state, dynamic action) {
  if (action is TransactionApprovalRequestChallengeCommandAction) {
    return TransactionApprovalLoadingState();
  } else if (action is TransactionApprovalChallengeFetchedEventAction) {
    return TransactionApprovalChallengeFetchedState(stringToSign: action.stringToSign);
  }

  return state;
}
