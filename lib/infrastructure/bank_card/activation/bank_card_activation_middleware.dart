import 'package:redux/redux.dart';
import 'package:solarisdemo/redux/app_state.dart';

import '../../../redux/bank_card/activation/bank_card_activation_action.dart';
import 'bank_card_activation_service.dart';

class BankCardActivationMiddleware extends MiddlewareClass<AppState> {
  final BankCardActivationService _bankCardActivationService;

  BankCardActivationMiddleware(this._bankCardActivationService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is GetBankCardActivationCommandAction) {
      store.dispatch(BankCardActivationLoadingEventAction());
      final response = await _bankCardActivationService.getBankCardById(
        user: action.user.cognito,
        cardId: action.cardId,
      );

      if (response is GetBankCardActivationSuccessResponse) {
        store.dispatch(BankCardActivationFetchedEventAction(
          bankCard: response.bankCard,
          user: action.user,
        ));
      } else {
        store.dispatch(BankCardActivationFailedEventAction());
      }
    }

    if (action is BankCardActivationChoosePinCommandAction) {
      store.dispatch(BankCardActivationPinChoosenEventAction(pin: action.pin));
    }
  }
}
