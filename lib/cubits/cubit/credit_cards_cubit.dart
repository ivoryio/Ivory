import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/credit_card.dart';

part 'credit_cards_state.dart';

class CreditCardsCubit extends Cubit<CreditCardsState> {
  CreditCardsCubit() : super(const CreditCardsInitial());

  void getCreditsCards() async {
    emit(const CreditCardsLoading());

    try {
      await Future.delayed(const Duration(seconds: 1));

      List<CreditCard> physicalCards = [
        CreditCard(
          representation: CreditCardRepresentation(
            line1: "John Wick",
            formattedExpirationDate: "08/27",
            maskedPan: "${"*" * 12}1234",
          ),
        ),
      ];

      emit(CreditCardsLoaded(physicalCards: physicalCards));
    } catch (e) {
      emit(CreditCardsError(message: e.toString()));
    }
  }
}
