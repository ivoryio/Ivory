import 'package:redux/redux.dart';
import 'package:solarisdemo/redux/app_state.dart';

import '../../../redux/bank_card/bank_card_action.dart';
import 'bank_card_service.dart';

class BankCardMiddleware extends MiddlewareClass<AppState> {
  final BankCardService _bankCardService;

  BankCardMiddleware(this._bankCardService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is GetBankCardCommandAction) {
      store.dispatch(BankCardLoadingEventAction());
      final response = await _bankCardService.getBankCardById(
        user: action.user.cognito,
        cardId: action.cardId,
      );

      if (response is GetBankCardSuccessResponse) {
        store.dispatch(BankCardFetchedEventAction(
          bankCard: response.bankCard,
          user: action.user,
        ));
      } else {
        store.dispatch(BankCardFailedEventAction());
      }
    }

    if (action is BankCardChoosePinCommandAction) {
      store.dispatch(BankCardPinChoosenEventAction(
          pin: action.pin, user: action.user, bankcard: action.bankCard));
    }

    if (action is BankCardActivateCommandAction) {
      store.dispatch(BankCardLoadingEventAction());
      final response = await _bankCardService.activateBankCard(
        user: action.user.cognito,
        cardId: action.cardId,
      );

      if (response is GetBankCardSuccessResponse) {
        store.dispatch(BankCardActivatedEventAction(
          bankCard: response.bankCard,
          user: action.user,
        ));
      } else {
        store.dispatch(BankCardFailedEventAction());
      }
    }
  }
}
