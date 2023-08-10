import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/credit_line/credit_line_service.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_action.dart';

import '../../redux/app_state.dart';

class GetCreditLineMiddleware extends MiddlewareClass<AppState> {
  final CreditLineService _creditLineService;

  GetCreditLineMiddleware(this._creditLineService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is GetCreditLineCommandAction) {
      store.dispatch(CreditLineLoadingEventAction());
      final response = await _creditLineService.getCreditLine(user: action.user);

      if (response is GetCreditLineSuccessResponse) {
        store.dispatch(CreditLineFetchedEventAction(creditLine: response.creditLine));
      } else {
        store.dispatch(CreditLineFailedEventAction());
      }
    }
  }
}
