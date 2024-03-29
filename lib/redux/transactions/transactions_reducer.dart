import 'package:solarisdemo/redux/transactions/transactions_action.dart';
import 'package:solarisdemo/redux/transactions/transactions_state.dart';

TransactionsState transactionsReducer(
    TransactionsState currentState, dynamic action) {
  if (action is TransactionsLoadingEventAction) {
    return TransactionsLoadingState(action.filter);
  } else if (action is TransactionsFailedEventAction) {
    return TransactionsErrorState();
  } else if (action is TransactionsFetchedEventAction) {
    return TransactionsFetchedState(
        action.transactions, action.transactionListFilter);
  } else if (action is UpcomingTransactionsFetchedEventAction) {
    return UpcomingTransactionsFetchedState(
        action.upcomingTransactions, action.filter);
  }

  return currentState;
}

TransactionsState homeTransactionsReducer(
    TransactionsState currentState, dynamic action) {
  if (action is HomeTransactionsLoadingEventAction) {
    return TransactionsLoadingState(null);
  } else if (action is HomeTransactionsFailedEventAction) {
    return TransactionsErrorState();
  } else if (action is HomeTransactionsFetchedEventAction) {
    return TransactionsFetchedState(action.transactions, null);
  }

  return currentState;
}
