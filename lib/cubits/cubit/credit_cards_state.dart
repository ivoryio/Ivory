part of 'credit_cards_cubit.dart';

abstract class CreditCardsState extends Equatable {
  final List<CreditCard> physicalCards;
  final List<CreditCard> virtualCards;

  const CreditCardsState({
    this.physicalCards = const [],
    this.virtualCards = const [],
  });

  @override
  List<Object> get props => [];
}

class CreditCardsInitial extends CreditCardsState {
  const CreditCardsInitial({
    super.physicalCards,
    super.virtualCards,
  });
}

class CreditCardsLoading extends CreditCardsState {
  const CreditCardsLoading({
    super.physicalCards,
    super.virtualCards,
  });
}

class CreditCardsLoaded extends CreditCardsState {
  const CreditCardsLoaded({
    super.physicalCards,
    super.virtualCards,
  });
}

class CreditCardsError extends CreditCardsState {
  final String message;

  const CreditCardsError({
    super.physicalCards,
    super.virtualCards,
    required this.message,
  });
}
