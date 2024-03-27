


import 'package:solarisdemo/redux/top_up/add_card_action.dart';
import 'package:solarisdemo/redux/top_up/add_card_state.dart';

AddCardInfoState addCardInfoState(AddCardInfoState state, dynamic action) {
  if (action is SubmitCardInformationCommandAction) {
    return AddCardInfoState(
      cardHolder: action.cardHolder,
      cardNumber: action.cardNumber,
      month: action.month,
      year: action.year,
      cvv: action.cvv,
    );
  }
  return state;
}