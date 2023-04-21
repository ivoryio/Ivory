part of 'transactions_filtering_cubit.dart';

abstract class TransactionsFilteringState extends Equatable {
  final TransactionListFilter transactionListFilter;

  const TransactionsFilteringState({
    this.transactionListFilter = const TransactionListFilter(),
  });

  @override
  List<Object> get props => [transactionListFilter];
}

class TransactionsFilteringInitial extends TransactionsFilteringState {
  const TransactionsFilteringInitial({super.transactionListFilter});

  @override
  List<Object> get props => [transactionListFilter];
}

class TransactionsFiltered extends TransactionsFilteringState {
  const TransactionsFiltered({super.transactionListFilter});

  @override
  List<Object> get props => [transactionListFilter];
}
