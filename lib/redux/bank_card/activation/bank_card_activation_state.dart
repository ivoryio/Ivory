import 'package:equatable/equatable.dart';

import '../../../models/bank_card.dart';

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
  final BankCard bankCard;

  BankCardActivationFetchedState(this.bankCard);

  @override
  List<Object?> get props => [bankCard];
}
