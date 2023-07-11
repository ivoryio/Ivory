import 'package:equatable/equatable.dart';

import '../../models/bank_card.dart';

class BankCardDetailsState extends Equatable {
  final BankCard? card;

  const BankCardDetailsState({this.card});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class BankCardDetailsInitialState extends BankCardDetailsState {
  const BankCardDetailsInitialState() : super();
}

class BankCardDetailsLoadingState extends BankCardDetailsState {
  const BankCardDetailsLoadingState() : super();
}

class BankCardDetailsLoadedState extends BankCardDetailsState {
  const BankCardDetailsLoadedState({required BankCard card})
      : super(card: card);
}

class BankCardDetailsInfoState extends BankCardDetailsState {
  const BankCardDetailsInfoState() : super();
}

class BankCardDetailsChoosePinState extends BankCardDetailsState {
  const BankCardDetailsChoosePinState() : super();
}

class BankCardDetailsConfirmPinState extends BankCardDetailsState {
  const BankCardDetailsConfirmPinState() : super();
}

class BankCardDetailsActivationSuccessState extends BankCardDetailsState {
  const BankCardDetailsActivationSuccessState() : super();
}

class BankCardDetailsErrorState extends BankCardDetailsState {
  final String message;

  const BankCardDetailsErrorState(this.message) : super();
}
