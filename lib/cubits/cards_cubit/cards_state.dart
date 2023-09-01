part of 'cards_cubit.dart';

abstract class BankCardsState extends Equatable {
  final List<BankCard> cards;

  const BankCardsState({this.cards = const []});

  @override
  List<Object> get props => [];
}

class BankCardsInitial extends BankCardsState {
  const BankCardsInitial({super.cards});
}

class BankCardsLoading extends BankCardsState {
  const BankCardsLoading({super.cards});
}

class BankCardsLoaded extends BankCardsState {
  const BankCardsLoaded({super.cards});
}

class BankCardsError extends BankCardsState {
  final String message;

  const BankCardsError({
    super.cards,
    required this.message,
  });
}
