import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/user.dart';

import '../../../models/bank_card.dart';
import '../../../redux/bank_card/bank_card_state.dart';

class BankCardPresenter {
  static BankCardViewModel presentBankCard({
    required BankCardState bankCardState,
    required AuthenticatedUser user,
  }) {
    if (bankCardState is BankCardInitialState) {
      return BankCardInitialViewModel();
    } else if (bankCardState is BankCardLoadingState) {
      return BankCardLoadingViewModel();
    } else if (bankCardState is BankCardErrorState) {
      return BankCardErrorViewModel();
    } else if (bankCardState is BankCardFetchedState) {
      return BankCardFetchedViewModel(
        user: user,
        bankCard: bankCardState.bankCard,
      );
    } else if (bankCardState is BankCardPinChoosenState) {
      return BankCardPinChoosenViewModel(
        user: user,
        pin: bankCardState.pin,
        bankCard: bankCardState.bankCard,
      );
    } else if (bankCardState is BankCardActivatedState) {
      return BankCardActivatedViewModel(
        user: user,
        bankCard: bankCardState.card,
      );
    } else if (bankCardState is BankCardDetailsFetchedState) {
      return BankCardDetailsFetchedViewModel(
        cardDetails: bankCardState.cardDetails,
        bankCard: bankCardState.bankCard,
      );
    }
    return BankCardInitialViewModel();
  }
}

abstract class BankCardViewModel extends Equatable {
  final String? pin;
  final BankCard? bankCard;
  final AuthenticatedUser? user;
  final BankCardFetchedDetails? cardDetails;

  const BankCardViewModel({this.user, this.pin, this.bankCard, this.cardDetails});

  @override
  List<Object?> get props => [pin];
}

class BankCardInitialViewModel extends BankCardViewModel {}

class BankCardLoadingViewModel extends BankCardViewModel {}

class BankCardErrorViewModel extends BankCardViewModel {}

class BankCardFetchedViewModel extends BankCardViewModel {
  final BankCard bankCard;
  final AuthenticatedUser user;

  const BankCardFetchedViewModel({required this.bankCard, required this.user});

  @override
  List<Object?> get props => [bankCard];
}

class BankCardPinChoosenViewModel extends BankCardViewModel {
  final BankCard bankCard;
  final String pin;
  final AuthenticatedUser user;

  const BankCardPinChoosenViewModel({required this.pin, required this.user, required this.bankCard});

  @override
  List<Object?> get props => [pin];
}

class BankCardActivatedViewModel extends BankCardViewModel {
  final BankCard bankCard;
  final AuthenticatedUser user;

  const BankCardActivatedViewModel({required this.bankCard, required this.user});

  @override
  List<Object?> get props => [bankCard];
}

class BankCardDetailsFetchedViewModel extends BankCardViewModel {
  final BankCardFetchedDetails cardDetails;
  final BankCard bankCard;

  const BankCardDetailsFetchedViewModel({required this.cardDetails, required this.bankCard});

  @override
  List<Object?> get props => [cardDetails, bankCard];
}
