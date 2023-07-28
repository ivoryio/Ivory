import 'package:equatable/equatable.dart';

import '../../models/bank_card.dart';

class BankCardDetailsState extends Equatable {
  final BankCard? card;
  final String? pin;
  final bool? isActive;

  const BankCardDetailsState({this.card, this.pin, this.isActive});

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
  const BankCardDetailsLoadedState(
      {required BankCard card, required bool isActive})
      : super(card: card, isActive: isActive);
}

class BankCardDetailsInfoState extends BankCardDetailsState {
  const BankCardDetailsInfoState({required BankCard card}) : super(card: card);
}

class BankCardDetailsChoosePinState extends BankCardDetailsState {
  const BankCardDetailsChoosePinState({required BankCard card})
      : super(card: card);
}

class BankCardDetailsConfirmPinState extends BankCardDetailsState {
  const BankCardDetailsConfirmPinState({
    required BankCard card,
    required pin,
  }) : super(
          card: card,
          pin: pin,
        );
}

class BankCardDetailsAppleWalletState extends BankCardDetailsState {
  const BankCardDetailsAppleWalletState({
    required BankCard card,
    required pin,
  }) : super(
          card: card,
          pin: pin,
        );
}

class BankCardDetailsActivationSuccessState extends BankCardDetailsState {
  const BankCardDetailsActivationSuccessState({
    required BankCard card,
  }) : super(
          card: card,
        );
}

class BankCardActivatedState extends BankCardDetailsState {
  const BankCardActivatedState({
    required BankCard card,
  }) : super(
          card: card,
        );
}

class BankCardDetailsMainState extends BankCardDetailsState {
  const BankCardDetailsMainState({
    required BankCard card,
  }) : super(
          card: card,
        );
}

class BankCardViewDetailsState extends BankCardDetailsState {
  const BankCardViewDetailsState({
    required BankCard card,
    required bool isActive,
  }) : super(
          card: card,
          isActive: isActive,
        );
}

class BankCardDetailsErrorState extends BankCardDetailsState {
  final String message;

  const BankCardDetailsErrorState(this.message) : super();
}
