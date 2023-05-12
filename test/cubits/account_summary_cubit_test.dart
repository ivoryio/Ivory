import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:solarisdemo/cubits/account_summary_cubit/account_summary_cubit.dart';
import 'package:solarisdemo/models/person_account_summary.dart';
import 'package:solarisdemo/services/person_service.dart';

class MockPersonService extends Mock implements PersonService {}

void main() {
  group('AccountSummaryCubit', () {
    late AccountSummaryCubit cubit;
    late MockPersonService mockPersonService;

    setUp(() {
      mockPersonService = MockPersonService();
      cubit = AccountSummaryCubit(personService: mockPersonService);
    });

    test('initial state is AccountSummaryCubitInitial', () {
      expect(cubit.state, const AccountSummaryCubitInitial());
    });

    test('getAccountSummary emits AccountSummaryCubitLoaded on success',
        () async {
      final mockAccountSummary =
          PersonAccountSummary();
      when(mockPersonService.getPersonAccountSummary())
          .thenAnswer((_) async => mockAccountSummary);

      await cubit.getAccountSummary();

      expect(cubit.state, AccountSummaryCubitLoaded(mockAccountSummary));
    });

    test('getAccountSummary emits AccountSummaryCubitError on exception',
        () async {
      when(mockPersonService.getPersonAccountSummary())
          .thenThrow(Exception('Test exception'));

      await cubit.getAccountSummary();

      expect(cubit.state, const AccountSummaryCubitError());
    });

    test('getAccountSummary emits AccountSummaryCubitError on error', () async {
      when(mockPersonService.getPersonAccountSummary()).thenThrow(Error());

      await cubit.getAccountSummary();

      expect(cubit.state, const AccountSummaryCubitError());
    });
  });
}
