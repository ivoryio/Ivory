import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/services/card_service.dart';
import 'package:solarisdemo/widgets/text_currency_value.dart';

import '../../models/bank_card.dart';
import 'card_details_state.dart';

class BankCardDetailsCubit extends Cubit<BankCardDetailsState> {
  BankCardsService cardsService;
  BankCardDetailsCubit({required this.cardsService})
      : super(const BankCardDetailsInitialState());

  Future<void> loadCard(String cardId) async {
    try {
      BankCard? card = await cardsService.getBankCardById(cardId);

      if (card is BankCard) {
        emit(BankCardDetailsLoadedState(card: card));
      } else {
        throw Exception('Card not found');
      }
    } catch (e) {
      emit(BankCardDetailsErrorState(e.toString()));
    }
  }

  Future<void> freezeCard(String cardId) async {
    emit(const BankCardDetailsLoadingState());
    try {
      BankCard blockedCard = await cardsService.freezeBankCard(cardId);
      emit(BankCardDetailsLoadedState(card: blockedCard));
      return;
    } catch (e) {
      emit(BankCardDetailsErrorState(e.toString()));
    }
  }

  Future<void> unfreezeCard(String cardId) async {
    emit(const BankCardDetailsLoadingState());
    try {
      BankCard unBlockedCard = await cardsService.unfreezeCard(cardId);
      emit(BankCardDetailsLoadedState(card: unBlockedCard));
      return;
    } catch (e) {
      emit(BankCardDetailsErrorState(e.toString()));
    }
  }

  Future<void> initializeActivation(BankCard card) async {
    emit(BankCardDetailsInfoState(card: card));
  }

  Future<void> choosePin(BankCard card) async {
    emit(BankCardDetailsChoosePinState(card: card));
  }

  Future<void> confirmPIN(BankCard card) async {
    emit(BankCardDetailsConfirmPinState(card: card));
  }

  Future<void> addToAppleWallet(BankCard card) async {
    emit(BankCardDetailsAppleWalletState(card: card));
  }

  Future<void> successActivation(BankCard card) async {
    emit(BankCardDetailsActivationSuccessState(card: card));
  }

  Future<void> goToActivatedScreen() async {
    emit(const BankCardActivatedState());
  }
}
