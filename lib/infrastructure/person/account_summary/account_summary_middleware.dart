import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/person/account_summary/account_summary_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/person/account_summary/account_summay_action.dart';

import '../../../redux/auth/auth_state.dart';
import '../../../redux/person/account_summary/account_summay_state.dart';

class GetAccountSummaryMiddleware extends MiddlewareClass<AppState>
{
  final AccountSummaryService _accountSummaryService;

  GetAccountSummaryMiddleware(this._accountSummaryService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async{
    next(action);

    final authState = store.state.authState;
    if(authState is! AuthenticatedState) {
      return;
    }

    if(action is GetAccountSummaryCommandAction) {
      if((store.state.accountSummaryState is WithAccountSummaryState) && (action.forceAccountSummaryReload == false)) {
        return;
      }

      store.dispatch(AccountSummaryLoadingEventAction());

      final response = await _accountSummaryService.getPersonAccountSummary(user: authState.authenticatedUser.cognito);
      if(response is GetAccountSummarySuccessResponse) {
        store.dispatch(AccountSummaryFetchedEventAction(accountSummary: response.accountSummary));
      } else {
        store.dispatch(AccountSummaryFailedEventAction());
      }
    }
  }
}