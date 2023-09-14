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
    } else if (bankCardState is BankCardNoBoundedDevicesState) {
      return BankCardNoBoundedDevicesViewModel();
    } else if (bankCardState is BankCardFetchedState) {
      return BankCardFetchedViewModel(
        user: user,
        bankCard: bankCardState.bankCard,
      );
    } else if (bankCardState is BankCardPinChoosenState) {
      return BankCardPinChoosenViewModel(
        pin: bankCardState.pin,
        bankCard: bankCardState.bankCard,
      );
    } else if (bankCardState is BankCardPinConfirmedState) {
      return BankCardPinConfirmedViewModel(
        user: user,
        bankCard: bankCardState.bankCard,
      );
    } else if (bankCardState is BankCardPinChangedState) {
      return BankCardPinChangedViewModel();
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

class BankCardNoBoundedDevicesViewModel extends BankCardViewModel {}

class BankCardFetchedViewModel extends BankCardViewModel {


  const BankCardFetchedViewModel({
    required BankCard bankCard,
    required AuthenticatedUser user,
  }) : super(bankCard: bankCard, user: user);

  @override
  List<Object?> get props => [bankCard];
}

class BankCardPinChoosenViewModel extends BankCardViewModel {
  const BankCardPinChoosenViewModel({
    required String pin,
    required BankCard bankCard,
  }) : super(pin: pin, bankCard: bankCard);

  @override
  List<Object?> get props => [pin];
}

class BankCardPinConfirmedViewModel extends BankCardViewModel {
  const BankCardPinConfirmedViewModel({
    required BankCard bankCard,
    required AuthenticatedUser user,
  }) : super(bankCard: bankCard, user: user);

  @override
  List<Object?> get props => [bankCard];
}

class BankCardActivatedViewModel extends BankCardViewModel {
  const BankCardActivatedViewModel({
    required BankCard bankCard,
    required AuthenticatedUser user,
  }) : super(bankCard: bankCard, user: user);

  @override
  List<Object?> get props => [bankCard];
}

class BankCardDetailsFetchedViewModel extends BankCardViewModel {
  const BankCardDetailsFetchedViewModel({
    required BankCardFetchedDetails cardDetails,
    required BankCard bankCard,
  }) : super(bankCard: bankCard, cardDetails: cardDetails);

  @override
  List<Object?> get props => [cardDetails, bankCard];
}

class BankCardPinChangedViewModel extends BankCardViewModel {}
