import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/debit_card.dart';

part 'debit_cards_state.dart';

class DebitCardsCubit extends Cubit<DebitCardsState> {
  DebitCardsCubit() : super(const DebitCardsInitial());

  void getDebitCards() async {
    emit(const DebitCardsLoading());

    try {
      await Future.delayed(const Duration(seconds: 1));

      List<DebitCard> physicalCards = [
        DebitCard(
          representation: DebitCardRepresentation(
            line1: "John Wick",
            formattedExpirationDate: "08/27",
            maskedPan: "${"*" * 12}1234",
          ),
        ),
      ];

      emit(DebitCardsLoaded(physicalCards: physicalCards));
    } catch (e) {
      emit(DebitCardsError(message: e.toString()));
    }
  }
}
