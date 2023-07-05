part of 'cards_cubit.dart';

abstract class BankCardsState extends Equatable {
  final List<BankCard> physicalCards;
  final List<BankCard> virtualCards;

  const BankCardsState({
    this.physicalCards = const [],
    this.virtualCards = const [],
  });

  @override
  List<Object> get props => [];
}

class BankCardsInitial extends BankCardsState {
  const BankCardsInitial({
    super.physicalCards,
    super.virtualCards,
  });
}

class BankCardsLoading extends BankCardsState {
  const BankCardsLoading({
    super.physicalCards,
    super.virtualCards,
  });
}

class BankCardsLoaded extends BankCardsState {
  const BankCardsLoaded({
    super.physicalCards,
    super.virtualCards,
  });
}

class BankCardsError extends BankCardsState {
  final String message;

  const BankCardsError({
    super.physicalCards,
    super.virtualCards,
    required this.message,
  });
}
