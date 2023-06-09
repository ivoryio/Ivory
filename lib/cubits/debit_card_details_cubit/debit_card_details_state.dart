import 'package:equatable/equatable.dart';

import '../../models/debit_card.dart';

class DebitCardDetailsState extends Equatable {
  final DebitCard? debitCard;

  const DebitCardDetailsState({this.debitCard});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class DebitCardDetailsInitialState extends DebitCardDetailsState {
  const DebitCardDetailsInitialState() : super();
}

class DebitCardDetailsLoadingState extends DebitCardDetailsState {
  const DebitCardDetailsLoadingState() : super();
}

class DebitCardDetailsLoadedState extends DebitCardDetailsState {
  const DebitCardDetailsLoadedState({required DebitCard debitCard})
      : super(debitCard: debitCard);
}

class DebitCardDetailsErrorState extends DebitCardDetailsState {
  final String message;

  const DebitCardDetailsErrorState(this.message) : super();
}
