part of 'transaction_list_cubit.dart';

abstract class TransactionListState extends Equatable {
  final bool loading;
  final List<Transaction> transactions;

  const TransactionListState(
      {this.loading = false, this.transactions = const []});

  @override
  List<Object> get props => [loading];
}

class TransactionListInitial extends TransactionListState {
  const TransactionListInitial() : super(loading: true, transactions: const []);
}

class TransactionListLoading extends TransactionListState {
  const TransactionListLoading() : super(loading: true, transactions: const []);
}

class TransactionListLoaded extends TransactionListState {
  const TransactionListLoaded(List<Transaction> transactions)
      : super(loading: false, transactions: transactions);
}

class TransactionListError extends TransactionListState {
  const TransactionListError() : super(loading: false, transactions: const []);
}
