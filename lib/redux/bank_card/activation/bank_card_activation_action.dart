import '../../../models/bank_card.dart';
import '../../../models/user.dart';

class GetBankCardActivationCommandAction {
  final String cardId;
  final User user;

  GetBankCardActivationCommandAction({
    required this.user,
    required this.cardId,
  });
}

class BankCardActivationLoadingEventAction {}

class BankCardActivationFailedEventAction {}

class BankCardActivationFetchedEventAction {
  final BankCard bankCard;
  BankCardActivationFetchedEventAction({required this.bankCard});
}
