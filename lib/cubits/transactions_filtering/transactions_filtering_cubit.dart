import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../services/transaction_service.dart';

part 'transactions_filtering_state.dart';

class TransactionsFilteringCubit extends Cubit<TransactionsFilteringState> {
  TransactionListFilter transactionListFilter;

  TransactionsFilteringCubit({
    required this.transactionListFilter,
  }) : super(TransactionsFilteringInitial(
          transactionListFilter: transactionListFilter,
        ));

  void setDateRange(DateTimeRange dateRange) {
    TransactionListFilter updatedFilter = TransactionListFilter(
      bookingDateMin: dateRange.start,
      bookingDateMax: dateRange.end,
    );

    emit(TransactionsFiltered(transactionListFilter: updatedFilter));
  }

  void resetFilters() {
    emit(const TransactionsFilteringInitial());
  }
}
