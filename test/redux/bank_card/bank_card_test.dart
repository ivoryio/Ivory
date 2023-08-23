import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_action.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_state.dart';

import '../../infrastructure/bank_card/bank_card_presenter_test.dart';
import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import 'bank_card_mocks.dart';

void main() {
  group("Fetching bank card", () {
    test("When fetching bank card successfully should update with bank card", () async {
      // given
      final store = createTestStore(
        bankCardService: FakeBankCardService(),
        initialState: createAppState(
          bankCardState: BankCardInitialState(),
        ),
      );

      final loadingState = store.onChange.firstWhere((element) => element.bankCardState is BankCardLoadingState);
      final appState = store.onChange.firstWhere((element) => element.bankCardState is BankCardFetchedState);

      // when
      store.dispatch(
        GetBankCardCommandAction(
          cardId: "inactive-card-id",
          user: AuthenticatedUser(
            person: MockPerson(),
            cognito: MockUser(),
            personAccount: MockPersonAccount(),
          ),
        ),
      );

      // then
      expect((await loadingState).bankCardState, isA<BankCardLoadingState>());
      expect((await appState).bankCardState, isA<BankCardFetchedState>());
    });

    test("When fetching bank card is failing should update with error", () async {
      // given
      final store = createTestStore(
        bankCardService: FakeFailingBankCardService(),
        initialState: createAppState(
          bankCardState: BankCardInitialState(),
        ),
      );
      final loadingState = store.onChange.firstWhere((element) => element.bankCardState is BankCardLoadingState);
      final appState = store.onChange.firstWhere((element) => element.bankCardState is BankCardErrorState);

      // when
      store.dispatch(
        GetBankCardCommandAction(
          cardId: "",
          user: AuthenticatedUser(
            person: MockPerson(),
            cognito: MockUser(),
            personAccount: MockPersonAccount(),
          ),
        ),
      );

      // then
      expect((await loadingState).bankCardState, isA<BankCardLoadingState>());
      expect((await appState).bankCardState, isA<BankCardErrorState>());
    });
  });
  group("Activate bank card", () {
    test("When activating bank card successfully should update with bank card", () async {
      // given
      final store = createTestStore(
        bankCardService: FakeBankCardService(),
        initialState: createAppState(
          bankCardState: BankCardInitialState(),
        ),
      );

      final loadingState = store.onChange.firstWhere((element) => element.bankCardState is BankCardLoadingState);
      final appState = store.onChange.firstWhere((element) => element.bankCardState is BankCardActivatedState);

      // when
      store.dispatch(
        BankCardActivateCommandAction(
          cardId: "inactive-card-id",
          user: AuthenticatedUser(
            person: MockPerson(),
            cognito: MockUser(),
            personAccount: MockPersonAccount(),
          ),
        ),
      );

      // then
      expect((await loadingState).bankCardState, isA<BankCardLoadingState>());
      expect((await appState).bankCardState, isA<BankCardActivatedState>());
    });

    test("When activating bank card is failing should update with error", () async {
      // given
      final store = createTestStore(
        bankCardService: FakeFailingBankCardService(),
        initialState: createAppState(
          bankCardState: BankCardInitialState(),
        ),
      );
      final loadingState = store.onChange.firstWhere((element) => element.bankCardState is BankCardLoadingState);
      final appState = store.onChange.firstWhere((element) => element.bankCardState is BankCardErrorState);

      // when
      store.dispatch(
        BankCardActivateCommandAction(
          cardId: "",
          user: AuthenticatedUser(
            person: MockPerson(),
            cognito: MockUser(),
            personAccount: MockPersonAccount(),
          ),
        ),
      );

      // then
      expect((await loadingState).bankCardState, isA<BankCardLoadingState>());
      expect((await appState).bankCardState, isA<BankCardErrorState>());
    });
  });
}
