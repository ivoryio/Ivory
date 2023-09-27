import 'package:solarisdemo/redux/person/account_summary/account_summay_action.dart';
import 'package:solarisdemo/redux/person/account_summary/account_summay_state.dart';

AccountSummaryState accountSummaryReducer(
    AccountSummaryState currentState,
    dynamic action ) {
  if(action is AccountSummaryLoadingEventAction) {
    return AccountSummaryLoadingState();
  } else if(action is AccountSummaryFailedEventAction) {
    return AccountSummaryErrorState();
  } else if(action is AccountSummaryFetchedEventAction) {
    return WithAccountSummaryState(action.accountSummary);
  }
  return currentState;
}