import '../../../models/bank_card.dart';
import '../../../models/user.dart';

class CreateCardCommandAction {
  final String firstName;
  final String lastName;
  final BankCardType type;
  final String businessId;

  CreateCardCommandAction({
    required this.firstName,
    required this.lastName,
    required this.type,
    required this.businessId,
  });
}

class GetBankCardCommandAction {
  final String cardId;
  final bool forceReloadCardData;

  GetBankCardCommandAction({
    required this.cardId,
    required this.forceReloadCardData,
  });
}

class GetBankCardsCommandAction {
  final bool forceCardsReload;

  GetBankCardsCommandAction({
    required this.forceCardsReload,
  });
}

class BankCardChoosePinCommandAction {
  final BankCard bankCard;
  final String pin;

  BankCardChoosePinCommandAction({required this.pin, required this.bankCard});
}

class BankCardConfirmPinCommandAction {
  final BankCard bankCard;
  final String pin;

  BankCardConfirmPinCommandAction({required this.pin, required this.bankCard});
}

class BankCardActivateCommandAction {
  final String cardId;

  BankCardActivateCommandAction({required this.cardId});
}

class BankCardFetchDetailsCommandAction {
  final BankCard bankCard;

  BankCardFetchDetailsCommandAction({required this.bankCard});
}

class BankCardFreezeCommandAction {
  final BankCard bankCard;
  final List<BankCard> bankCards;

  BankCardFreezeCommandAction({required this.bankCard, required this.bankCards});
}

class BankCardUnfreezeCommandAction {
  final BankCard bankCard;
  final List<BankCard> bankCards;

  BankCardUnfreezeCommandAction({required this.bankCard, required this.bankCards});
}

class BankCardInitiatePinChangeCommandAction {
  final BankCard bankCard;

  BankCardInitiatePinChangeCommandAction({required this.bankCard});
}

class BankCardLoadingEventAction {}

class BankCardsLoadingEventAction {}

class BankCardFailedEventAction {}

class BankCardsFailedEventAction {}

class BankCardNoBoundedDevicesEventAction {
  final BankCard bankCard;

  BankCardNoBoundedDevicesEventAction({required this.bankCard});
}

class BankCardPinChoosenEventAction {
  final String pin;
  final BankCard bankcard;
  final AuthenticatedUser user;
  BankCardPinChoosenEventAction({required this.pin, required this.user, required this.bankcard});
}

class BankCardPinConfirmedEventAction {
  final String pin;
  final BankCard bankcard;
  final AuthenticatedUser user;
  BankCardPinConfirmedEventAction({required this.pin, required this.user, required this.bankcard});
}

class BankCardPinChangedEventAction {}

class BankCardFetchedEventAction {
  final AuthenticatedUser user;
  final BankCard bankCard;
  BankCardFetchedEventAction({
    required this.bankCard,
    required this.user,
  });
}

class BankCardsFetchedEventAction {
  final List<BankCard> bankCards;
  BankCardsFetchedEventAction({
    required this.bankCards,
  });
}

class UpdateBankCardsEventAction {
  final List<BankCard> bankCards;
  final BankCard updatedCard;
  UpdateBankCardsEventAction({
    required this.bankCards,
    required this.updatedCard,
  });
}

class BankCardActivatedEventAction {
  final BankCard bankCard;
  final AuthenticatedUser user;
  BankCardActivatedEventAction({required this.bankCard, required this.user});
}

class BankCardDetailsFetchedEventAction {
  final BankCard bankCard;
  final BankCardFetchedDetails cardDetails;

  BankCardDetailsFetchedEventAction({required this.cardDetails, required this.bankCard});
}
