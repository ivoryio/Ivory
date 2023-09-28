import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/person/account_summary/account_summary_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/person/account_summary/account_summay_action.dart';

class GetAccountSummaryMiddleware extends MiddlewareClass<AppState>
{
  final AccountSummaryService _accountSummaryService;

  GetAccountSummaryMiddleware(this._accountSummaryService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async{
    next(action);

    if(action is GetAccountSummaryCommandAction) {
      store.dispatch(AccountSummaryLoadingEventAction());

      final response = await _accountSummaryService.getPersonAccountSummary(user: action.user);
      if(response is GetAccountSummarySuccessResponse) {
        store.dispatch(AccountSummaryFetchedEventAction(accountSummary: response.accountSummary));
      } else {
        store.dispatch(AccountSummaryFailedEventAction());
      }
    }
  }
}