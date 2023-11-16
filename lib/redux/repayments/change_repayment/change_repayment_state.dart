import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/transfer/credit_card_application.dart';

abstract class CardApplicationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CardApplicationInitialState extends CardApplicationState {}

class CardApplicationLoadingState extends CardApplicationState {}

class CardApplicationErrorState extends CardApplicationState {}

class CardApplicationFetchedState extends CardApplicationState {
  final CreditCardApplication cardApplication;

  CardApplicationFetchedState(this.cardApplication);

  @override
  List<Object?> get props => [cardApplication];
}

class CardApplicationUpdatedState extends CardApplicationState {
  final CreditCardApplication cardApplication;

  CardApplicationUpdatedState(this.cardApplication);

  @override
  List<Object?> get props => [cardApplication];
}
