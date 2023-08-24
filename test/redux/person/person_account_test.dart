import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/redux/person/person_account/person_account_action.dart';
import 'package:solarisdemo/redux/person/person_account/person_account_state.dart';

import '../../infrastructure/bank_card/bank_card_presenter_test.dart';
import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import 'person_mocks.dart';

void main() {
  group("Person Account Fetching", () {
    test("When fetching person account should update with loading", () async {
      // given
      final state = createTestStore(
        personService: FakePersonService(),
        initialState: createAppState(
          personAccountState: PersonAccountInitialState(),
        ),
      );
      final loadingState =
          state.onChange.firstWhere((element) => element.personAccountState is PersonAccountLoadingState);

      // when
      state.dispatch(GetPersonAccountCommandAction(user: MockUser()));

      // then
      expect((await loadingState).personAccountState, isA<PersonAccountLoadingState>());
    });

    test("When fetching person account successfully should update with person account", () async {
      // given
      final state = createTestStore(
        personService: FakePersonService(),
        initialState: createAppState(
          personAccountState: PersonAccountInitialState(),
        ),
      );
      final loadingState =
          state.onChange.firstWhere((element) => element.personAccountState is PersonAccountLoadingState);
      final appState = state.onChange.firstWhere((element) => element.personAccountState is PersonAccountFetchedState);

      // when
      state.dispatch(GetPersonAccountCommandAction(user: MockUser()));

      // then
      expect((await loadingState).personAccountState, isA<PersonAccountLoadingState>());
      expect((await appState).personAccountState, isA<PersonAccountFetchedState>());
    });

    test("When fetching person account is failing should update with error", () async {
      // given
      final state = createTestStore(
        personService: FakeFailingPersonService(),
        initialState: createAppState(
          personAccountState: PersonAccountInitialState(),
        ),
      );
      final loadingState =
          state.onChange.firstWhere((element) => element.personAccountState is PersonAccountLoadingState);
      final appState = state.onChange.firstWhere((element) => element.personAccountState is PersonAccountErrorState);

      // when
      state.dispatch(GetPersonAccountCommandAction(user: MockUser()));

      // then
      expect((await loadingState).personAccountState, isA<PersonAccountLoadingState>());
      expect((await appState).personAccountState, isA<PersonAccountErrorState>());
    });
  });
}
