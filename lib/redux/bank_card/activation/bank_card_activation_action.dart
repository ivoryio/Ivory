import '../../../models/bank_card.dart';
import '../../../models/user.dart';

class GetBankCardActivationCommandAction {
  final String cardId;
  final AuthenticatedUser user;

  GetBankCardActivationCommandAction({
    required this.user,
    required this.cardId,
  });
}

class BankCardActivationChoosePinCommandAction {
  final String pin;

  BankCardActivationChoosePinCommandAction({required this.pin});
}

class BankCardActivationLoadingEventAction {}

class BankCardActivationFailedEventAction {}

class BankCardActivationPinChoosenEventAction {
  final String pin;
  BankCardActivationPinChoosenEventAction({required this.pin});
}

class BankCardActivationFetchedEventAction {
  final AuthenticatedUser user;
  final BankCard bankCard;
  BankCardActivationFetchedEventAction({
    required this.bankCard,
    required this.user,
  });
}
