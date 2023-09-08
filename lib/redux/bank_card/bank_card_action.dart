import '../../../models/bank_card.dart';
import '../../../models/user.dart';

class GetBankCardCommandAction {
  final String cardId;
  final AuthenticatedUser user;

  GetBankCardCommandAction({
    required this.user,
    required this.cardId,
  });
}

class BankCardChoosePinCommandAction {
  final AuthenticatedUser user;
  final BankCard bankCard;
  final String pin;

  BankCardChoosePinCommandAction({required this.pin, required this.user, required this.bankCard});
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

class BankCardLoadingEventAction {}

class BankCardFailedEventAction {}

class BankCardNoBoundedDevicesEventAction {}

class BankCardPinChoosenEventAction {
  final String pin;
  final BankCard bankcard;
  final AuthenticatedUser user;
  BankCardPinChoosenEventAction({required this.pin, required this.user, required this.bankcard});
}

class BankCardFetchedEventAction {
  final AuthenticatedUser user;
  final BankCard bankCard;
  BankCardFetchedEventAction({
    required this.bankCard,
    required this.user,
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
