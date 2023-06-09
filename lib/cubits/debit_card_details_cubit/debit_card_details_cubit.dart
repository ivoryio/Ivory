import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/services/debit_card_service.dart';

import '../../models/debit_card.dart';
import 'debit_card_details_state.dart';

class DebitCardDetailsCubit extends Cubit<DebitCardDetailsState> {
  DebitCardsService debitCardsService;
  DebitCardDetailsCubit({required this.debitCardsService})
      : super(const DebitCardDetailsInitialState());

  // Future<void> loadDebitCardDetails(String cardId) async {
  //   emit(const DebitCardDetailsLoadingState());
  //   try {
  //     final debitCard = await debitCardsService.getDebitCardById(cardId);

  //     if (debitCard.isUndefined) {
  //       throw Exception('Debit card not found');
  //     }
  //     emit(DebitCardDetailsLoadedState(debitCard: debitCard));
  //     return;
  //   } catch (e) {
  //     emit(DebitCardDetailsErrorState(e.toString()));
  //   }
  // }

  void initDebitCardDetails(DebitCard debitCard) {
    emit(DebitCardDetailsLoadedState(debitCard: debitCard));
  }

  Future<void> freezeDebitCard(String cardId) async {
    emit(const DebitCardDetailsLoadingState());
    try {
      DebitCard blockedDebitCard =
          await debitCardsService.freezeDebitCard(cardId);
      emit(DebitCardDetailsLoadedState(debitCard: blockedDebitCard));
      return;
    } catch (e) {
      emit(DebitCardDetailsErrorState(e.toString()));
    }
  }

  Future<void> unfreezeDebitCard(String cardId) async {
    emit(const DebitCardDetailsLoadingState());
    try {
      DebitCard unBlockedDebitCard =
          await debitCardsService.unfreezeDebitCard(cardId);
      emit(DebitCardDetailsLoadedState(debitCard: unBlockedDebitCard));
      return;
    } catch (e) {
      emit(DebitCardDetailsErrorState(e.toString()));
    }
  }
}
