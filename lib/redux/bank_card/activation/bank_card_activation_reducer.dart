import 'package:solarisdemo/redux/bank_card/activation/bank_card_activation_state.dart';

import 'bank_card_activation_action.dart';

BankCardActivationState bankCardActivationReducer(
    BankCardActivationState currentState, dynamic action) {
  if (action is BankCardActivationLoadingEventAction) {
    return BankCardActivationLoadingState();
  } else if (action is BankCardActivationFailedEventAction) {
    return BankCardActivationErrorState();
  } else if (action is BankCardActivationFetchedEventAction) {
    return BankCardActivationFetchedState(action.bankCard);
  }

  return currentState;
}
