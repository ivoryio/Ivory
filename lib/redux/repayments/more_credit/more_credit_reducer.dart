import 'package:solarisdemo/redux/repayments/more_credit/more_credit_action.dart';

import 'more_credit_state.dart';

MoreCreditState moreCreditReducer(
    MoreCreditState currentState, dynamic action) {
  if (action is MoreCreditLoadingEventAction) {
    return MoreCreditLoadingState();
  } else if (action is MoreCreditFailedEventAction) {
    return MoreCreditErrorState();
  } else if (action is MoreCreditFetchedEventAction) {
    return MoreCreditFetchedState(action.waitlist);
  }
  return currentState;
}
