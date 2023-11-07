import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/models/auth/auth_type.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/suggestions/address/address_suggestions_action.dart';
import 'package:solarisdemo/redux/suggestions/address/address_suggestions_state.dart';

import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import '../auth/auth_mocks.dart';
import 'suggestions_mocks.dart';

void main() {
  final user = MockUser();
  final authentionInitializedState = AuthenticationInitializedState(user, AuthType.onboarding);

  test("When fetching address suggestions, the state should change to loading", () async {
    // given
    final store = createTestStore(
      addressSuggestionsService: FakeAddressSuggestionsService(),
      initialState: createAppState(
        authState: authentionInitializedState,
        addressSuggestionsState: AddressSuggestionsInitialState(),
      ),
    );

    final appState =
        store.onChange.firstWhere((element) => element.addressSuggestionsState is AddressSuggestionsLoadingState);

    // when
    store.dispatch(const FetchAddressSuggestionsCommandAction(query: "query"));

    // then
    expect((await appState).addressSuggestionsState, isA<AddressSuggestionsLoadingState>());
  });

  test("When address suggestions are requested and arrive succesfully, state should be updated", () async {
    // given
    final store = createTestStore(
      addressSuggestionsService: FakeAddressSuggestionsService(),
      initialState: createAppState(
        authState: authentionInitializedState,
        addressSuggestionsState: AddressSuggestionsInitialState(),
      ),
    );

    final appState =
        store.onChange.firstWhere((element) => element.addressSuggestionsState is AddressSuggestionsFetchedState);
    final loadingState =
        store.onChange.firstWhere((element) => element.addressSuggestionsState is AddressSuggestionsLoadingState);

    // when
    store.dispatch(const FetchAddressSuggestionsCommandAction(query: "query"));

    // then
    expect((await loadingState).addressSuggestionsState, isA<AddressSuggestionsLoadingState>());
    expect((await appState).addressSuggestionsState, isA<AddressSuggestionsFetchedState>());
  });

  test("When address suggestions are requested and fail, state should be updated", () async {
    // given
    final store = createTestStore(
      addressSuggestionsService: FakeFailingAddressSuggestionsService(),
      initialState: createAppState(
        authState: authentionInitializedState,
        addressSuggestionsState: AddressSuggestionsInitialState(),
      ),
    );

    final appState =
        store.onChange.firstWhere((element) => element.addressSuggestionsState is AddressSuggestionsErrorState);
    final loadingState =
        store.onChange.firstWhere((element) => element.addressSuggestionsState is AddressSuggestionsLoadingState);

    // when
    store.dispatch(const FetchAddressSuggestionsCommandAction(query: "query"));

    // then
    expect((await loadingState).addressSuggestionsState, isA<AddressSuggestionsLoadingState>());
    expect((await appState).addressSuggestionsState, isA<AddressSuggestionsErrorState>());
  });
}
