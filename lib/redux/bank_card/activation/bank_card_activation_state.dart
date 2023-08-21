import 'package:equatable/equatable.dart';

import '../../../models/bank_card.dart';
import '../../../models/user.dart';

abstract class BankCardActivationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BankCardActivationInitialState extends BankCardActivationState {}

class BankCardActivationLoadingState extends BankCardActivationState {
  BankCardActivationLoadingState();
}

class BankCardActivationErrorState extends BankCardActivationState {}

class BankCardActivationFetchedState extends BankCardActivationState {
  final AuthenticatedUser user;
  final BankCard bankCard;

  BankCardActivationFetchedState(this.bankCard, this.user);

  @override
  List<Object?> get props => [bankCard, user];
}

class BankCardActivationPinChoosenState extends BankCardActivationState {
  final String pin;

  BankCardActivationPinChoosenState(this.pin);

  @override
  List<Object?> get props => [pin];
}
