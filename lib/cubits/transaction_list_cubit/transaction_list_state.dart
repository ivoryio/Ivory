part of 'transaction_list_cubit.dart';

abstract class TransactionListState extends Equatable {
  final bool loading;
  final List<Transaction> transactions;
  final List<Transaction> filteredTransactions;

  const TransactionListState({
    this.loading = false,
    this.transactions = const [],
    this.filteredTransactions = const [],
  });

  @override
  List<Object> get props => [loading, transactions];
}

class TransactionListInitial extends TransactionListState {
  const TransactionListInitial() : super(loading: true, transactions: const []);
}

class TransactionListLoading extends TransactionListState {
  const TransactionListLoading(
      {super.transactions = const [], super.loading = true});
}

class TransactionListLoaded extends TransactionListState {
  const TransactionListLoaded(List<Transaction> transactions)
      : super(loading: false, transactions: transactions);
}

class TransactionListSearched extends TransactionListState {
  const TransactionListSearched(
      {super.loading = false, super.transactions, super.filteredTransactions});

  @override
  List<Object> get props => [transactions];
}

class TransactionListSearchedLoad extends TransactionListState {
  const TransactionListSearchedLoad({super.loading = true, super.transactions});

  @override
  List<Object> get props => [transactions];
}

class TransactionListError extends TransactionListState {
  const TransactionListError() : super(loading: false, transactions: const []);
}
