import 'package:solarisdemo/models/transactions/upcoming_transaction_model.dart';

import '../../models/transactions/transaction_model.dart';
import '../../models/user.dart';

class GetTransactionsCommandAction {
  final TransactionListFilter? filter;
  final User user;

  GetTransactionsCommandAction({required this.filter, required this.user});
}

class TransactionsLoadingEventAction {
  final TransactionListFilter? filter;

  TransactionsLoadingEventAction({required this.filter});
}

class TransactionsFailedEventAction {}

class TransactionsFetchedEventAction {
  final List<Transaction> transactions;
  final TransactionListFilter? transactionListFilter;

  TransactionsFetchedEventAction(
      {required this.transactions, this.transactionListFilter});
}

class GetUpcomingTransactionsCommandAction {
  final TransactionListFilter? filter;
  final User user;

  GetUpcomingTransactionsCommandAction(
      {required this.filter, required this.user});
}

class UpcomingTransactionsFetchedEventAction {
  final List<UpcomingTransaction> upcomingTransactions;
  final TransactionListFilter? filter;

  UpcomingTransactionsFetchedEventAction({
    required this.upcomingTransactions,
    this.filter,
  });
}
