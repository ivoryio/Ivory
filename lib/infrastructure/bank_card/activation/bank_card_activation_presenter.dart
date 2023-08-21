import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/user.dart';

import '../../../models/bank_card.dart';
import '../../../redux/bank_card/activation/bank_card_activation_state.dart';

class BankCardActivationPresenter {
  static BankCardActivationViewModel presentBankCardActivation({
    required BankCardActivationState bankCardActivationState,
    required AuthenticatedUser user,
  }) {
    if (bankCardActivationState is BankCardActivationInitialState) {
      return BankCardActivationInitialViewModel();
    } else if (bankCardActivationState is BankCardActivationLoadingState) {
      return BankCardActivationLoadingViewModel();
    } else if (bankCardActivationState is BankCardActivationErrorState) {
      return BankCardActivationErrorViewModel();
    } else if (bankCardActivationState is BankCardActivationFetchedState) {
      return BankCardActivationFetchedViewModel(
        user: bankCardActivationState.user,
        bankCard: bankCardActivationState.bankCard,
      );
    } else if (bankCardActivationState is BankCardActivationPinChoosenState) {
      return BankCardActivationPinChoosenViewModel(
        pin: bankCardActivationState.pin,
      );
    }
    return BankCardActivationInitialViewModel();
  }
}

abstract class BankCardActivationViewModel extends Equatable {
  final String? pin;
  final BankCard? bankCard;
  final AuthenticatedUser? user;

  const BankCardActivationViewModel({this.user, this.pin, this.bankCard});

  @override
  List<Object?> get props => [pin];
}

class BankCardActivationPinChoosenViewModel
    extends BankCardActivationViewModel {
  final String pin;

  const BankCardActivationPinChoosenViewModel({required this.pin});

  @override
  List<Object?> get props => [pin];
}

class BankCardActivationInitialViewModel extends BankCardActivationViewModel {}

class BankCardActivationLoadingViewModel extends BankCardActivationViewModel {}

class BankCardActivationErrorViewModel extends BankCardActivationViewModel {}

class BankCardActivationFetchedViewModel extends BankCardActivationViewModel {
  final BankCard bankCard;
  final AuthenticatedUser user;

  const BankCardActivationFetchedViewModel(
      {required this.bankCard, required this.user});

  @override
  List<Object?> get props => [bankCard];
}
