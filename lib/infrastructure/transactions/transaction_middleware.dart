import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_service.dart';
import 'package:solarisdemo/redux/transactions/transactions_action.dart';

import '../../redux/app_state.dart';

class GetTransactionsMiddleware extends MiddlewareClass<AppState> {
  final TransactionService _transactionService;

  GetTransactionsMiddleware(this._transactionService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if(action is GetTransactionsCommandAction) {
      store.dispatch(TransactionsLoadingEventAction(filter: action.filter));
      final response = await _transactionService.getTransactions(filter: action.filter, user: action.user);

      if(response is GetTransactionsSuccessResponse) {
        store.dispatch(TransactionsFetchedEventAction(transactions: response.transactions, transactionListFilter: action.filter));
      } else {
        store.dispatch(TransactionsFailedEventAction());
      }
    }
  }
}