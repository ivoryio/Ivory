import 'package:solarisdemo/redux/transactions/transactions_action.dart';
import 'package:solarisdemo/redux/transactions/transactions_state.dart';

TransactionsState transactionsReducer(TransactionsState currentState, dynamic action) {
  if(action is TransactionsLoadingEventAction) {
    return TransactionsLoadingState();
  } else if(action is TransactionsFailedEventAction) {
    return TransactionsErrorState();
  } else if (action is TransactionsFetchedEventAction) {
    return TransactionsFetchedState(action.transactions, action.transactionListFilter);
  }

  return currentState;
}