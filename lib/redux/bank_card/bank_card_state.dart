import 'package:equatable/equatable.dart';

import '../../../models/bank_card.dart';
import '../../../models/user.dart';

abstract class BankCardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BankCardInitialState extends BankCardState {}

class BankCardLoadingState extends BankCardState {
  BankCardLoadingState();
}

class BankCardErrorState extends BankCardState {
  final String message;

  BankCardErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class BankCardNoBoundedDevicesState extends BankCardState {
  final BankCard bankCard;

  BankCardNoBoundedDevicesState(this.bankCard);

  @override
  List<Object?> get props => [bankCard];
}

class BankCardFetchedState extends BankCardState {
  final AuthenticatedUser user;
  final BankCard bankCard;

  BankCardFetchedState(this.bankCard, this.user);

  @override
  List<Object?> get props => [bankCard, user];
}

class BankCardPinChoosenState extends BankCardState {
  final AuthenticatedUser user;
  final BankCard bankCard;
  final String pin;

  BankCardPinChoosenState(this.pin, this.user, this.bankCard);

  @override
  List<Object?> get props => [pin];
}

class BankCardPinConfirmedState extends BankCardState {
  final AuthenticatedUser user;
  final BankCard bankCard;

  BankCardPinConfirmedState(this.user, this.bankCard);

  @override
  List<Object?> get props => [user, bankCard];
}

class BankCardActivatedState extends BankCardState {
  final BankCard card;
  final AuthenticatedUser user;

  BankCardActivatedState(this.card, this.user);

  @override
  List<Object?> get props => [user, card];
}

class BankCardDetailsFetchedState extends BankCardState {
  final BankCardFetchedDetails cardDetails;
  final BankCard bankCard;

  BankCardDetailsFetchedState(this.cardDetails, this.bankCard);

  @override
  List<Object?> get props => [cardDetails, bankCard];
}

class BankCardPinChangedState extends BankCardState {}



abstract class BankCardsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BankCardsInitialState extends BankCardsState {}

class BankCardsLoadingState extends BankCardsState {}

class BankCardsErrorState extends BankCardsState {}

class BankCardsFetchedState extends BankCardsState {
  final List<BankCard> bankCards;

  BankCardsFetchedState(this.bankCards);

  @override
  List<Object?> get props => [bankCards];
}
