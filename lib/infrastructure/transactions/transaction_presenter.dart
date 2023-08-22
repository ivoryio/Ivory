import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/transactions/transactions_state.dart';

// import '../../models/transaction_model.dart';
import '../../models/upcoming_transactions.dart';
import '../../models/transactions/transaction_model.dart';

class TransactionPresenter {
  static TransactionsViewModel presentTransactions(
      {required TransactionsState transactionsState}) {
    if (transactionsState is TransactionsLoadingState) {
      return TransactionsLoadingViewModel(
          transactionListFilter: transactionsState.transactionListFilter);
    } else if (transactionsState is TransactionsErrorState) {
      return TransactionsErrorViewModel();
    } else if (transactionsState is TransactionsFetchedState) {
      return TransactionsFetchedViewModel(
        transactions: transactionsState.transactions,
        transactionListFilter: transactionsState.transactionListFilter,
      );
    } else if (transactionsState is UpcomingTransactionsFetchedState) {
      return UpcomingTransactionsFetchedViewModel(
        upcomingTransactions: transactionsState.upcomingTransactions,
        transactionListFilter: transactionsState.transactionListFilter,
      );
    }

    return TransactionsInitialViewModel();
  }
}

abstract class TransactionsViewModel extends Equatable {
  final List<Transaction>? transactions;
  final List<UpcomingTransaction>? upcomingTransactions;
  final TransactionListFilter? transactionListFilter;

  const TransactionsViewModel(
      {this.transactions,
      this.transactionListFilter,
      this.upcomingTransactions});

  @override
  List<Object?> get props => [transactions, transactionListFilter];
}

class TransactionsInitialViewModel extends TransactionsViewModel {}

class TransactionsLoadingViewModel extends TransactionsViewModel {
  const TransactionsLoadingViewModel(
      {TransactionListFilter? transactionListFilter})
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

class UpcomingTransactionsFetchedViewModel extends TransactionsViewModel {
  const UpcomingTransactionsFetchedViewModel({
    required List<UpcomingTransaction> upcomingTransactions,
    TransactionListFilter? transactionListFilter,
  }) : super(
          upcomingTransactions: upcomingTransactions,
          transactionListFilter: transactionListFilter,
        );
}
