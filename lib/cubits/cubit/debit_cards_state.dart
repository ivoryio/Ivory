part of 'debit_cards_cubit.dart';

abstract class DebitCardsState extends Equatable {
  final List<DebitCard> physicalCards;
  final List<DebitCard> virtualCards;

  const DebitCardsState({
    this.physicalCards = const [],
    this.virtualCards = const [],
  });

  @override
  List<Object> get props => [];
}

class DebitCardsInitial extends DebitCardsState {
  const DebitCardsInitial({
    super.physicalCards,
    super.virtualCards,
  });
}

class DebitCardsLoading extends DebitCardsState {
  const DebitCardsLoading({
    super.physicalCards,
    super.virtualCards,
  });
}

class DebitCardsLoaded extends DebitCardsState {
  const DebitCardsLoaded({
    super.physicalCards,
    super.virtualCards,
  });
}

class DebitCardsError extends DebitCardsState {
  final String message;

  const DebitCardsError({
    super.physicalCards,
    super.virtualCards,
    required this.message,
  });
}
