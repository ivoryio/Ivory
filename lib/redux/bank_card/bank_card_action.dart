import '../../../models/bank_card.dart';
import '../../../models/user.dart';

class CreateCardCommandAction {
  final AuthenticatedUser user;
  final String firstName;
  final String lastName;
  final BankCardType type;
  final String businessId;

  CreateCardCommandAction({
    required this.user,
    required this.firstName,
    required this.lastName,
    required this.type,
    required this.businessId,
  });
}

class GetBankCardCommandAction {
  final String cardId;
  final AuthenticatedUser user;

  GetBankCardCommandAction({
    required this.user,
    required this.cardId,
  });
}

class GetBankCardsCommandAction {
  final User user;
  final bool forceCardsReload;

  GetBankCardsCommandAction({
    required this.user,
    required this.forceCardsReload,
  });
}

class BankCardChoosePinCommandAction {
  final AuthenticatedUser user;
  final BankCard bankCard;
  final String pin;

  BankCardChoosePinCommandAction({required this.pin, required this.user, required this.bankCard});
}

class BankCardConfirmPinCommandAction {
  final AuthenticatedUser user;
  final BankCard bankCard;
  final String pin;

  BankCardConfirmPinCommandAction({required this.pin, required this.user, required this.bankCard});
}

class BankCardActivateCommandAction {
  final AuthenticatedUser user;
  final String cardId;

  BankCardActivateCommandAction({required this.cardId, required this.user});
}

class BankCardFetchDetailsCommandAction {
  final AuthenticatedUser user;
  final BankCard bankCard;

  BankCardFetchDetailsCommandAction({required this.bankCard, required this.user});
}

class BankCardFreezeCommandAction {
  final AuthenticatedUser user;
  final BankCard bankCard;
  final List<BankCard> bankCards;

  BankCardFreezeCommandAction({required this.bankCard, required this.user, required this.bankCards});
}

class BankCardUnfreezeCommandAction {
  final AuthenticatedUser user;
  final BankCard bankCard;
  final List<BankCard> bankCards;

  BankCardUnfreezeCommandAction({required this.bankCard, required this.user, required this.bankCards});
}

class BankCardInitiatePinChangeCommandAction {
  final AuthenticatedUser user;
  final BankCard bankCard;

  BankCardInitiatePinChangeCommandAction({required this.bankCard, required this.user});
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
