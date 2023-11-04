import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/redux/suggestions/city/city_suggestions_action.dart';
import 'package:solarisdemo/redux/suggestions/city/city_suggestions_state.dart';

import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import 'suggestions_mocks.dart';

void main() {
  test("When asking to fetch cities, state should change to loading", () async {
    // given
    final store = createTestStore(
      citySuggestionsService: FakeCitySuggestionsService(),
      initialState: createAppState(
        citySuggestionsState: CitySuggestionsInitialState(),
      ),
    );
    final appState =
        store.onChange.firstWhere((element) => element.citySuggestionsState is CitySuggestionsLoadingState);

    // when
    store.dispatch(FetchCitySuggestionsCommandAction(countryCode: "DE"));

    // then
    expect((await appState).citySuggestionsState, isA<CitySuggestionsLoadingState>());
  });

  test("When cities are fetched, state should change to fetched", () async {
    // given
    final store = createTestStore(
      citySuggestionsService: FakeCitySuggestionsService(),
      initialState: createAppState(
        citySuggestionsState: CitySuggestionsInitialState(),
      ),
    );
    final loadingState =
        store.onChange.firstWhere((element) => element.citySuggestionsState is CitySuggestionsLoadingState);
    final appState =
        store.onChange.firstWhere((element) => element.citySuggestionsState is CitySuggestionsFetchedState);

    // when
    store.dispatch(FetchCitySuggestionsCommandAction(countryCode: "DE"));

    // then
    expect((await loadingState).citySuggestionsState, isA<CitySuggestionsLoadingState>());
    expect((await appState).citySuggestionsState, isA<CitySuggestionsFetchedState>());
  });

  test("When fetching for cities using a search term, the search term should be passed to the service", () async {
    // given
    final store = createTestStore(
      citySuggestionsService: FakeCitySuggestionsService(),
      initialState: createAppState(
        citySuggestionsState: CitySuggestionsInitialState(),
      ),
    );
    final loadingState =
        store.onChange.firstWhere((element) => element.citySuggestionsState is CitySuggestionsLoadingState);
    final appState =
        store.onChange.firstWhere((element) => element.citySuggestionsState is CitySuggestionsFetchedState);

    // when
    store.dispatch(FetchCitySuggestionsCommandAction(countryCode: "DE", searchTerm: "Berlin"));

    // then
    expect((await loadingState).citySuggestionsState, isA<CitySuggestionsLoadingState>());
    expect((await appState).citySuggestionsState, isA<CitySuggestionsFetchedState>());
    expect(((await appState).citySuggestionsState as CitySuggestionsFetchedState).searchTerm, "Berlin");
  });

  test("When failed fetching cities, the state should change to error", () async {
    // given
    final store = createTestStore(
      citySuggestionsService: FakeFailingCitySuggestionsService(),
      initialState: createAppState(
        citySuggestionsState: CitySuggestionsInitialState(),
      ),
    );
    final loadingState =
        store.onChange.firstWhere((element) => element.citySuggestionsState is CitySuggestionsLoadingState);
    final appState = store.onChange.firstWhere((element) => element.citySuggestionsState is CitySuggestionsErrorState);

    // when
    store.dispatch(FetchCitySuggestionsCommandAction(countryCode: "DE"));

    // then
    expect((await loadingState).citySuggestionsState, isA<CitySuggestionsLoadingState>());
    expect((await appState).citySuggestionsState, isA<CitySuggestionsErrorState>());
  });
}
