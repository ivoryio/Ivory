import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:solarisdemo/cubits/transactions_filtering/transactions_filtering_cubit.dart';
import 'package:solarisdemo/services/transaction_service.dart';

class MockTransactionService extends Mock implements TransactionService {}

void main() {
  group('TransactionsFilteringCubit', () {
    late TransactionsFilteringCubit cubit;

    setUp(() {
      cubit = TransactionsFilteringCubit(
        transactionListFilter: const TransactionListFilter(),
      );
    });

    test('setDateRange emits TransactionsFiltered', () async {
      var startDate = DateTime(2022, 1, 1);
      var endDate = DateTime(2022, 1, 31);
      final dateRange = DateTimeRange(start: startDate, end: endDate);

      expect(cubit.state, const TransactionsFilteringInitial());

      await cubit.setDateRange(dateRange);

      expect(
        cubit.state,
        isA<TransactionsFiltered>()
            .having(
              (state) => state.transactionListFilter.bookingDateMin,
              'bookingDateMin',
              startDate,
            )
            .having(
              (state) => state.transactionListFilter.bookingDateMax,
              'bookingDateMax',
              endDate,
            ),
      );
    });

    test('resetFilters emits TransactionsFilteringInitial', () {
      cubit.resetFilters();

      expect(
        cubit.state,
        const TransactionsFilteringInitial(),
      );
    });
  });
}
