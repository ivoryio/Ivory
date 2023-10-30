import 'package:solarisdemo/models/transactions/upcoming_transaction_model.dart';

import '../../models/transactions/transaction_model.dart';

class GetTransactionsCommandAction {
  final TransactionListFilter? filter;
  final bool forceReloadTransactions;

  GetTransactionsCommandAction({required this.filter, required this.forceReloadTransactions});
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

  GetUpcomingTransactionsCommandAction(
      {required this.filter});
}

class UpcomingTransactionsFetchedEventAction {
  final List<UpcomingTransaction> upcomingTransactions;
  final TransactionListFilter? filter;

  UpcomingTransactionsFetchedEventAction({
    required this.upcomingTransactions,
    this.filter,
  });
}

class GetHomeTransactionsCommandAction {
  final TransactionListFilter? filter;
  final bool forceReloadTransactions;

  GetHomeTransactionsCommandAction({required this.filter, required this.forceReloadTransactions});
}

class HomeTransactionsLoadingEventAction {}

class HomeTransactionsFailedEventAction {}

class HomeTransactionsFetchedEventAction {
  final List<Transaction> transactions;

  HomeTransactionsFetchedEventAction({required this.transactions});
}
