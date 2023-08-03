import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/transactions/transactions_state.dart';

import '../../models/transaction_model.dart';

class TransactionPresenter {
  static TransactionsViewModel presentTransactions({required TransactionsState transactionsState}) {
    if(transactionsState is TransactionsLoadingState) {
      return TransactionsLoadingViewModel();
    } else if(transactionsState is TransactionsErrorState) {
      return TransactionsErrorViewModel();
    } else if(transactionsState is TransactionsFetchedState) {
      return TransactionsFetchedViewModel(transactions: transactionsState.transactions);
    }

    return TransactionsInitialViewModel();
  }
}

abstract class TransactionsViewModel extends Equatable {
  final List<Transaction>? transactions;

  const TransactionsViewModel({this.transactions});

  @override
  List<Object?> get props => [transactions];
}

class TransactionsInitialViewModel extends TransactionsViewModel {}

class TransactionsLoadingViewModel extends TransactionsViewModel {}

class TransactionsErrorViewModel extends TransactionsViewModel {}

class TransactionsFetchedViewModel extends TransactionsViewModel {
  const TransactionsFetchedViewModel({required List<Transaction> transactions}) : super(transactions: transactions);
}

