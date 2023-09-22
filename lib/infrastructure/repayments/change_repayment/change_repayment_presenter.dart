import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/transfer/credit_card_application.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/repayments/change_repayment/change_repayment_state.dart';

class CardApplicationPresenter {
  static CardApplicationViewModel presentCardApplication({
    required CardApplicationState cardApplicationState,
    required AuthenticatedUser user,
  }) {
    if (cardApplicationState is CardApplicationLoadingState) {
      return CardApplicationLoadingViewModel();
    } else if (cardApplicationState is CardApplicationErrorState) {
      return CardApplicationErrorViewModel();
    } else if (cardApplicationState is CardApplicationFetchedState) {
      return CardApplicationFetchedViewModel(cardApplication: cardApplicationState.cardApplication);
    } else if (cardApplicationState is CardApplicationUpdatedState) {
      return CardApplicationUpdatedViewModel(cardApplication: cardApplicationState.cardApplication);
    }

    return CardApplicationInitialViewModel();
  }
}

abstract class CardApplicationViewModel extends Equatable {
  final AuthenticatedUser? user;
  const CardApplicationViewModel({this.user});

  @override
  List<Object?> get props => [];
}

class CardApplicationInitialViewModel extends CardApplicationViewModel {}

class CardApplicationLoadingViewModel extends CardApplicationViewModel {}

class CardApplicationErrorViewModel extends CardApplicationViewModel {}

class CardApplicationFetchedViewModel extends CardApplicationViewModel {
  final CreditCardApplication cardApplication;

  const CardApplicationFetchedViewModel({
    required this.cardApplication,
  });

  @override
  List<Object?> get props => [cardApplication];
}

class CardApplicationUpdatedViewModel extends CardApplicationViewModel {
  final CreditCardApplication cardApplication;

  const CardApplicationUpdatedViewModel({
    required this.cardApplication,
  });

  @override
  List<Object?> get props => [cardApplication];
}
