import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:solarisdemo/cubits/cards_cubit/cards_cubit.dart';
import 'package:solarisdemo/models/bank_card.dart';
import 'package:solarisdemo/services/card_service.dart';

class MockBankCardsService extends Mock implements BankCardsService {
  @override
  Future<List<BankCard>?> getCards({BankCardsListFilter? filter}) {
    return super.noSuchMethod(
      Invocation.method(#getCards, [], {#filter: filter}),
      returnValue: Future.value([MockBankCard()]),
      returnValueForMissingStub: Future.value([]),
    );
  }
}

class MockBankCard extends Mock implements BankCard {}

void main() {
  group('BankCardsCubit', () {
    late BankCardsCubit cubit;
    late MockBankCardsService mockCardsService;

    setUp(() {
      mockCardsService = MockBankCardsService();
      cubit = BankCardsCubit(cardsService: mockCardsService);
    });

    test('initial state is BankCardsInitial', () {
      expect(cubit.state, const BankCardsInitial());
    });

    test('getCards emits BankCardsLoaded on success', () async {
      final card = MockBankCard();
      final cards = [card];
      when(mockCardsService.getCards()).thenAnswer((_) async => cards);

      final expected = [
        const BankCardsLoading(),
        BankCardsLoaded(physicalCards: cards),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));

      cubit.getCards();
    });

    test('getCards emits BankCardsError on exception', () async {
      when(mockCardsService.getCards()).thenThrow(Exception());

      final expected = [
        const BankCardsLoading(),
        const BankCardsError(message: 'Error getting cards'),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));

      cubit.getCards();
    });

    test('getCards emits BankCardsError on Error', () async {
      when(mockCardsService.getCards()).thenThrow(Error());

      final expected = [
        const BankCardsLoading(),
        const BankCardsError(message: 'Error getting cards'),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));

      cubit.getCards();
    });
  });
}
