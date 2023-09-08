import 'bank_card_action.dart';
import 'bank_card_state.dart';

BankCardState bankCardReducer(BankCardState currentState, dynamic action) {
  if (action is BankCardLoadingEventAction) {
    return BankCardLoadingState();
  } else if (action is BankCardFailedEventAction) {
    return BankCardErrorState();
  } else if (action is BankCardFetchedEventAction) {
    return BankCardFetchedState(action.bankCard, action.user);
  } else if (action is BankCardPinChoosenEventAction) {
    return BankCardPinChoosenState(action.pin, action.user, action.bankcard);
  } else if (action is BankCardActivatedEventAction) {
    return BankCardActivatedState(action.bankCard, action.user);
  } else if (action is BankCardDetailsFetchedEventAction) {
    return BankCardDetailsFetchedState(action.cardDetails, action.bankCard);
  }

  return currentState;
}
