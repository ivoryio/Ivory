import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../services/transaction_service.dart';

part 'transactions_filtering_state.dart';

class TransactionsFilteringCubit extends Cubit<TransactionsFilteringState> {
  TransactionsFilteringCubit() : super(TransactionsFilteringInitial());

  void setDateRange(DateTimeRange dateRange) {
    TransactionListFilter transactionListFilter = TransactionListFilter(
      bookingDateMin: dateRange.start,
      bookingDateMax: dateRange.end,
    );

    emit(TransactionsFiltered(transactionListFilter: transactionListFilter));
  }

  void resetFilters() {
    emit(TransactionsFilteringInitial());
  }
}
