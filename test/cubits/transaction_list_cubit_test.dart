import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:solarisdemo/cubits/transaction_list_cubit/transaction_list_cubit.dart';
import 'package:solarisdemo/services/transaction_service.dart';
import 'package:solarisdemo/models/transaction_model.dart';

class MockTransactionService extends Mock implements TransactionService {
  @override
  Future<List<Transaction>?> getTransactions({TransactionListFilter? filter}) {
    return super.noSuchMethod(
      Invocation.method(#getTransactions, [], {#filter: filter}),
      returnValue:
          Future.value(List<Transaction>.filled(1, Transaction(id: '1'))),
      returnValueForMissingStub: Future.value(),
    );
  }
}

void main() {
  group('TransactionListCubit', () {
    late TransactionListCubit cubit;
    late MockTransactionService mockTransactionService;

    setUp(() {
      mockTransactionService = MockTransactionService();
      cubit = TransactionListCubit(transactionService: mockTransactionService);
    });

    test('getTransactions emits TransactionListLoaded on success', () async {
      // Create a list of mock transactions
      final transactions = [Transaction(id: '1'), Transaction(id: '2')];

      // Mock the getTransactions method to return the list of transactions
      when(mockTransactionService.getTransactions(filter: anyNamed('filter')))
          .thenAnswer((_) async => transactions);

      cubit.getTransactions();

      expect(cubit.state, const TransactionListLoading());

      await expectLater(
        cubit.stream,
        emits(
          TransactionListLoaded(transactions),
        ),
      );
    });

    test('getTransactions emits TransactionListInitial if no transactions',
        () async {
      // Mock the getTransactions method to return null
      when(mockTransactionService.getTransactions(filter: anyNamed('filter')))
          .thenAnswer((_) async => null);

      cubit.getTransactions();

      expect(cubit.state, const TransactionListLoading());

      await expectLater(
        cubit.stream,
        emits(
          const TransactionListInitial(),
        ),
      );
    });

    test('getTransactions emits TransactionListError on error', () async {
      // Mock the getTransactions method to throw an exception
      when(mockTransactionService.getTransactions(filter: anyNamed('filter')))
          .thenThrow(Error());

      expect(cubit.state, const TransactionListInitial());

      await cubit.getTransactions();

      expect(
        cubit.state,
        const TransactionListError(),
      );
    });
  });
}
