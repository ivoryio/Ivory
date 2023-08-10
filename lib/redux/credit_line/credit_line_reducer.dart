import 'package:solarisdemo/redux/credit_line/credit_line_state.dart';

import 'credit_line_action.dart';

CreditLineState creditLineReducer(CreditLineState currentState, dynamic action) {
  if (action is CreditLineLoadingEventAction) {
    return CreditLineLoadingState();
  } else if (action is CreditLineFailedEventAction) {
    return CreditLineErrorState();
  } else if (action is CreditLineFetchedEventAction) {
    return CreditLineFetchedState(action.creditLine);
  }

  return currentState;
}
