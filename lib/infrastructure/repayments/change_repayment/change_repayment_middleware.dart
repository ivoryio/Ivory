import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/repayments/change_repayment/change_repayment_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/repayments/change_repayment/change_repayment_action.dart';

import '../../../redux/auth/auth_state.dart';

class CardApplicationMiddleware extends MiddlewareClass<AppState> {
  final CardApplicationService _cardApplicationService;

  CardApplicationMiddleware(this._cardApplicationService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final authState = store.state.authState;
    if(authState is! AuthenticatedState) {
      return;
    }

    if (action is UpdateCardApplicationCommandAction) {
      store.dispatch(CardApplicationLoadingEventAction());

      final response = await _cardApplicationService.updateChangeRepayment(
        user: authState.authenticatedUser.cognito,
        fixedRate: action.fixedRate,
        percentageRate: action.percentageRate,
        id: action.id,
      );

      if (response is UpdateCardApplicationSuccessResponse) {
        store.dispatch(UpdateCardApplicationEventAction(creditCardApplication: response.creditCardApplication));
      } else {
        store.dispatch(CardApplicationFailedEventAction());
      }
    }

    if (action is GetCardApplicationCommandAction) {
      final response = await _cardApplicationService.getCardApplication(
        user: authState.authenticatedUser.cognito,
      );

      if (response is GetCardApplicationSuccessResponse) {
        store.dispatch(CardApplicationFetchedEventAction(creditCardApplication: response.creditCardApplication));
      } else {
        store.dispatch(CardApplicationFailedEventAction());
      }
    }
  }
}
