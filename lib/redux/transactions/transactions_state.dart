import 'package:equatable/equatable.dart';

import '../../models/transactions/upcoming_transaction_model.dart';
import '../../models/transactions/transaction_model.dart';

abstract class TransactionsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransactionsInitialState extends TransactionsState {}

class TransactionsLoadingState extends TransactionsState {
  final TransactionListFilter? transactionListFilter;

  TransactionsLoadingState(this.transactionListFilter);
}

class TransactionsErrorState extends TransactionsState {}

class TransactionsFetchedState extends TransactionsState {
  final List<Transaction> transactions;
  final TransactionListFilter? transactionListFilter;

  TransactionsFetchedState(this.transactions, this.transactionListFilter);

  @override
  List<Object?> get props => [transactions, transactionListFilter];
}

class UpcomingTransactionsFetchedState extends TransactionsState {
  final List<UpcomingTransaction> upcomingTransactions;
  final TransactionListFilter? transactionListFilter;

  UpcomingTransactionsFetchedState(
      this.upcomingTransactions, this.transactionListFilter);

  @override
  List<Object?> get props => [upcomingTransactions, transactionListFilter];
}
