import 'package:solarisdemo/redux/repayments/change_repayment/change_repayment_action.dart';
import 'package:solarisdemo/redux/repayments/change_repayment/change_repayment_state.dart';

CardApplicationState cardApplicationReducer(CardApplicationState currentState, dynamic action) {
  if (action is CardApplicationLoadingEventAction) {
    return CardApplicationLoadingState();
  } else if (action is CardApplicationFailedEventAction) {
    return CardApplicationErrorState();
  } else if (action is CardApplicationFetchedEventAction) {
    return CardApplicationFetchedState(action.creditCardApplication);
  } else if (action is UpdateCardApplicationEventAction) {
    return CardApplicationUpdatedState(action.creditCardApplication);
  }

  return currentState;
}
