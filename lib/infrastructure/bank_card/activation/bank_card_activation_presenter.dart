import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/user.dart';

import '../../../models/bank_card.dart';
import '../../../redux/bank_card/activation/bank_card_activation_state.dart';

class BankCardActivationPresenter {
  static BankCardActivationViewModel presentBankCardActivation(
      {required BankCardActivationState bankCardActivationState,
      required AuthenticatedUser user}) {
    if (bankCardActivationState is BankCardActivationInitialState) {
      return BankCardActivationInitialViewModel();
    } else if (bankCardActivationState is BankCardActivationLoadingState) {
      return BankCardActivationLoadingViewModel();
    } else if (bankCardActivationState is BankCardActivationErrorState) {
      return BankCardActivationErrorViewModel();
    } else if (bankCardActivationState is BankCardActivationFetchedState) {
      return BankCardActivationFetchedViewModel(
        bankCard: bankCardActivationState.bankCard,
      );
    }
    return BankCardActivationInitialViewModel();
  }
}

abstract class BankCardActivationViewModel extends Equatable {
  const BankCardActivationViewModel();

  @override
  List<Object?> get props => [];
}

class BankCardActivationInitialViewModel extends BankCardActivationViewModel {}

class BankCardActivationLoadingViewModel extends BankCardActivationViewModel {}

class BankCardActivationErrorViewModel extends BankCardActivationViewModel {}

class BankCardActivationFetchedViewModel extends BankCardActivationViewModel {
  final BankCard bankCard;

  const BankCardActivationFetchedViewModel({required this.bankCard});

  @override
  List<Object?> get props => [bankCard];
}
