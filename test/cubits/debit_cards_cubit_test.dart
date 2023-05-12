import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:solarisdemo/cubits/debit_cards_cubit/debit_cards_cubit.dart';
import 'package:solarisdemo/models/debit_card.dart';
import 'package:solarisdemo/services/debit_card_service.dart';

class MockDebitCardsService extends Mock implements DebitCardsService {
  @override
  Future<List<DebitCard>?> getDebitCards({DebitCardsListFilter? filter}) {
    return super.noSuchMethod(
      Invocation.method(#getDebitCards, [], {#filter: filter}),
      returnValue: Future.value([MockDebitCard()]),
      returnValueForMissingStub: Future.value([]),
    );
  }
}

class MockDebitCard extends Mock implements DebitCard {}

void main() {
  group('DebitCardsCubit', () {
    late DebitCardsCubit cubit;
    late MockDebitCardsService mockDebitCardsService;

    setUp(() {
      mockDebitCardsService = MockDebitCardsService();
      cubit = DebitCardsCubit(debitCardsService: mockDebitCardsService);
    });

    test('initial state is DebitCardsInitial', () {
      expect(cubit.state, const DebitCardsInitial());
    });

    test('getDebitCards emits DebitCardsLoaded on success', () async {
      final debitCard = MockDebitCard();
      final debitCards = [debitCard];
      when(mockDebitCardsService.getDebitCards())
          .thenAnswer((_) async => debitCards);

      final expected = [
        const DebitCardsLoading(),
        DebitCardsLoaded(physicalCards: debitCards),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));

      cubit.getDebitCards();
    });

    test('getDebitCards emits DebitCardsError on exception', () async {
      when(mockDebitCardsService.getDebitCards()).thenThrow(Exception());

      final expected = [
        const DebitCardsLoading(),
        const DebitCardsError(message: 'Error getting debit cards'),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));

      cubit.getDebitCards();
    });

    test('getDebitCards emits DebitCardsError on Error', () async {
      when(mockDebitCardsService.getDebitCards()).thenThrow(Error());

      final expected = [
        const DebitCardsLoading(),
        const DebitCardsError(message: 'Error getting debit cards'),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));

      cubit.getDebitCards();
    });
  });
}
