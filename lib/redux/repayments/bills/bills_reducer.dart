import 'package:solarisdemo/redux/repayments/bills/bills_action.dart';

import 'bills_state.dart';

BillsState billsReducer(BillsState currentState, dynamic action) {
  if (action is BillsLoadingEventAction) {
    return BillsLoadingState();
  } else if (action is BillsFailedEventAction) {
    return BillsErrorState();
  } else if (action is BillsFetchedEventAction) {
    return BillsFetchedState(action.bills);
  }
  return currentState;
}
