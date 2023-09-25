import 'bank_card_action.dart';
import 'bank_card_state.dart';

BankCardState bankCardReducer(BankCardState currentState, dynamic action) {
  if (action is BankCardLoadingEventAction) {
    return BankCardLoadingState();
  } else if (action is BankCardFailedEventAction) {
    return BankCardErrorState(action.message);
  } else if (action is BankCardNoBoundedDevicesEventAction) {
    return BankCardNoBoundedDevicesState(action.bankCard);
  } else if (action is BankCardFetchedEventAction) {
    return BankCardFetchedState(action.bankCard, action.user);
  } else if (action is BankCardPinChoosenEventAction) {
    return BankCardPinChoosenState(action.pin, action.user, action.bankcard);
  } else if (action is BankCardPinConfirmedEventAction) {
    return BankCardPinConfirmedState(action.user, action.bankcard);
  } else if (action is BankCardActivatedEventAction) {
    return BankCardActivatedState(action.bankCard, action.user);
  } else if (action is BankCardDetailsFetchedEventAction) {
    return BankCardDetailsFetchedState(action.cardDetails, action.bankCard);
  } else if (action is BankCardPinChangedEventAction) {
    return BankCardPinChangedState();
  }
  return currentState;
}

BankCardsState bankCardsReducer(BankCardsState currentState, dynamic action) {
  if (action is BankCardsLoadingEventAction) {
    return BankCardsLoadingState();
  } else if (action is BankCardsFetchedEventAction) {
    return BankCardsFetchedState(action.bankCards);
  } else if (action is UpdateBankCardsEventAction) {
    final bankCards = action.bankCards;

    if (bankCards.indexWhere((element) => element.id == action.updatedCard.id) == -1) {
      bankCards.add(action.updatedCard);
    } else {
      final index = bankCards.indexWhere((element) => element.id == action.updatedCard.id);
      bankCards[index] = action.updatedCard;
    }

    return BankCardsFetchedState(bankCards);
  } else if (action is BankCardFailedEventAction) {
    return BankCardsErrorState();
  }

  return currentState;
}
