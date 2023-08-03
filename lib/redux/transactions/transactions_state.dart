import 'package:equatable/equatable.dart';

import '../../models/transaction_model.dart';

abstract class TransactionsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransactionsInitialState extends TransactionsState {}
class TransactionsLoadingState extends TransactionsState {}
class TransactionsErrorState extends TransactionsState {}

class TransactionsFetchedState extends TransactionsState {
  final List<Transaction> transactions;

  TransactionsFetchedState(this.transactions);

  @override
  List<Object?> get props => [transactions];
}
