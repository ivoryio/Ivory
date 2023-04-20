part of 'transactions_filtering_cubit.dart';

abstract class TransactionsFilteringState extends Equatable {
  const TransactionsFilteringState();

  @override
  List<Object> get props => [];
}

class TransactionsFilteringInitial extends TransactionsFilteringState {}

class TransactionsSetupFilters extends TransactionsFilteringState {}
