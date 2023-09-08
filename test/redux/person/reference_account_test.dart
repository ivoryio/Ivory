import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/redux/person/reference_account/reference_account_action.dart';
import 'package:solarisdemo/redux/person/reference_account/reference_account_state.dart';

import '../../infrastructure/bank_card/bank_card_presenter_test.dart';
import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import 'person_mocks.dart';

void main() {
  group("Reference Account Fetching", () {
    test("When fetching reference account should update with loading", () async {
      // given
      final store = createTestStore(
        personService: FakePersonService(),
        initialState: createAppState(
          referenceAccountState: ReferenceAccountInitialState(),
        ),
      );
      final loadingState =
          store.onChange.firstWhere((element) => element.referenceAccountState is ReferenceAccountLoadingState);

      // when
      store.dispatch(GetReferenceAccountCommandAction(user: MockUser()));

      // then
      expect((await loadingState).referenceAccountState, isA<ReferenceAccountLoadingState>());
    });

    test("When fetching reference account successfully should update with reference account", () async {
      // given
      final store = createTestStore(
        personService: FakePersonService(),
        initialState: createAppState(
          referenceAccountState: ReferenceAccountInitialState(),
        ),
      );
      final loadingState =
          store.onChange.firstWhere((element) => element.referenceAccountState is ReferenceAccountLoadingState);
      final appState =
          store.onChange.firstWhere((element) => element.referenceAccountState is ReferenceAccountFetchedState);

      // when
      store.dispatch(GetReferenceAccountCommandAction(user: MockUser()));

      // then
      expect((await loadingState).referenceAccountState, isA<ReferenceAccountLoadingState>());
      expect((await appState).referenceAccountState, isA<ReferenceAccountFetchedState>());
    });

    test("When fetching reference account is failing should update with error", () async {
      // given
      final store = createTestStore(
        personService: FakeFailingPersonService(),
        initialState: createAppState(
          referenceAccountState: ReferenceAccountInitialState(),
        ),
      );
      final loadingState =
          store.onChange.firstWhere((element) => element.referenceAccountState is ReferenceAccountLoadingState);
      final appState =
          store.onChange.firstWhere((element) => element.referenceAccountState is ReferenceAccountErrorState);

      // when
      store.dispatch(GetReferenceAccountCommandAction(user: MockUser()));

      // then
      expect((await loadingState).referenceAccountState, isA<ReferenceAccountLoadingState>());
      expect((await appState).referenceAccountState, isA<ReferenceAccountErrorState>());
    });
  });
}
