import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/debit_card.dart';
import '../../services/debit_card_service.dart';

part 'debit_cards_state.dart';

class DebitCardsCubit extends Cubit<DebitCardsState> {
  final DebitCardsService debitCardsService;

  DebitCardsCubit({required this.debitCardsService})
      : super(const DebitCardsInitial());

  Future<void> getDebitCards({DebitCardsListFilter? filter}) async {
    try {
      emit(const DebitCardsLoading());

      List<DebitCard>? debitCards =
          await debitCardsService.getDebitCards(filter: filter);

      if (debitCards is List<DebitCard>) {
        emit(DebitCardsLoaded(physicalCards: debitCards));
      }
    } catch (e) {
      emit(DebitCardsError(message: e.toString()));
    }
  }
}
