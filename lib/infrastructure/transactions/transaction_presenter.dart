import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/transactions/transactions_state.dart';

import '../../models/transactions/transaction_model.dart';

class TransactionPresenter {
  static TransactionsViewModel presentTransactions({required TransactionsState transactionsState}) {
    if(transactionsState is TransactionsLoadingState) {
      return TransactionsLoadingViewModel(transactionListFilter: transactionsState.transactionListFilter);
    } else if(transactionsState is TransactionsErrorState) {
      return TransactionsErrorViewModel();
    } else if(transactionsState is TransactionsFetchedState) {
      return TransactionsFetchedViewModel(
          transactions: transactionsState.transactions,
          transactionListFilter: transactionsState.transactionListFilter,
      );
    }

    return TransactionsInitialViewModel();
  }
}

abstract class TransactionsViewModel extends Equatable {
  final List<Transaction>? transactions;
  final TransactionListFilter? transactionListFilter;

  const TransactionsViewModel({this.transactions, this.transactionListFilter});

  @override
  List<Object?> get props => [transactions,transactionListFilter];
}

class TransactionsInitialViewModel extends TransactionsViewModel {}

class TransactionsLoadingViewModel extends TransactionsViewModel {
  const TransactionsLoadingViewModel ({TransactionListFilter? transactionListFilter})
      : super(transactionListFilter: transactionListFilter);
}

class TransactionsErrorViewModel extends TransactionsViewModel {}

class TransactionsFetchedViewModel extends TransactionsViewModel {
  const TransactionsFetchedViewModel({
    required List<Transaction> transactions,
    TransactionListFilter? transactionListFilter,
  }) : super(
      transactions: transactions,
      transactionListFilter: transactionListFilter,
  );
}

