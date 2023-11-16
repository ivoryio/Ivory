import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_service.dart';
import 'package:solarisdemo/redux/transactions/transactions_action.dart';
import 'package:solarisdemo/redux/transactions/transactions_state.dart';

import '../../redux/app_state.dart';
import '../../redux/auth/auth_state.dart';

class GetTransactionsMiddleware extends MiddlewareClass<AppState> {
  final TransactionService _transactionService;

  GetTransactionsMiddleware(this._transactionService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final authState = store.state.authState;
    if(authState is! AuthenticatedState) {
      return;
    }

    if (action is GetTransactionsCommandAction) {
      if((store.state.transactionsState is TransactionsFetchedState) && (action.forceReloadTransactions == false)) {
        return;
      }

      store.dispatch(TransactionsLoadingEventAction(filter: action.filter));
      final response = await _transactionService.getTransactions(
          filter: action.filter, user: authState.authenticatedUser.cognito);

      if (response is GetTransactionsSuccessResponse) {
        store.dispatch(TransactionsFetchedEventAction(
            transactions: response.transactions,
            transactionListFilter: action.filter));
      } else {
        store.dispatch(TransactionsFailedEventAction());
      }
    }

    if (action is GetUpcomingTransactionsCommandAction) {
      store.dispatch(TransactionsLoadingEventAction(filter: action.filter));

      final response =
          await _transactionService.getUpcomingTransactions(user: authState.authenticatedUser.cognito);

      if (response is GetUpcomingTransactionsSuccessResponse) {
        store.dispatch(UpcomingTransactionsFetchedEventAction(
            upcomingTransactions: response.upcomingTransactions));
      } else {
        store.dispatch(TransactionsFailedEventAction());
      }
    }

    if (action is GetHomeTransactionsCommandAction) {
      if((store.state.homePageTransactionsState is TransactionsFetchedState)  && (action.forceReloadTransactions == false)) {
        return;
      }
      store.dispatch(HomeTransactionsLoadingEventAction());
      final response = await _transactionService.getTransactions(
          filter: action.filter, user: authState.authenticatedUser.cognito);

      if (response is GetTransactionsSuccessResponse) {
        store.dispatch(HomeTransactionsFetchedEventAction(transactions: response.transactions));
      } else {
        store.dispatch(HomeTransactionsFailedEventAction());
      }
    }
  }
}
