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

class BankCardErrorState extends BankCardState {}

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
