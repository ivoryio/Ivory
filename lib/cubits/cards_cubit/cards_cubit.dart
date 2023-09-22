import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/bank_card.dart';
import '../../services/card_service.dart';

part 'cards_state.dart';

class BankCardsCubit extends Cubit<BankCardsState> {
  final BankCardsService cardsService;

  BankCardsCubit({required this.cardsService}) : super(const BankCardsInitial());

  Future<void> getCards({BankCardsListFilter? filter}) async {
    try {
      emit(const BankCardsLoading());

      List<BankCard>? cards = await cardsService.getCards(filter: filter);

      if (cards is List<BankCard>) {
        emit(BankCardsLoaded(cards: cards));
      }
    } catch (e) {
      emit(BankCardsError(message: e.toString()));
    }
  }

  Future<void> createCard(CreateBankCard card) async {
    try {
      emit(const BankCardsLoading());

      await cardsService.createCard(card);

      List<BankCard>? cards = await cardsService.getCards();

      if (cards is List<BankCard>) {
        emit(BankCardsLoaded(cards: cards));
      }
    } catch (e) {
      emit(BankCardsError(message: e.toString()));
    }
  }
}