import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/redux/search/search_cities_action.dart';
import 'package:solarisdemo/redux/search/search_cities_state.dart';

import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import 'search_cities_mocks.dart';

void main() {
  test("When asking to fetch cities, state should change to loading", () async {
    // given
    final store = createTestStore(
      searchCitiesService: FakeSearchCitiesService(),
      initialState: createAppState(
        searchCitiesState: SearchCitiesInitialState(),
      ),
    );
    final appState = store.onChange.firstWhere((element) => element.searchCitiesState is SearchCitiesLoadingState);

    // when
    store.dispatch(FetchCitiesCommandAction(countryCode: "DE"));

    // then
    expect((await appState).searchCitiesState, isA<SearchCitiesLoadingState>());
  });

  test("When cities are fetched, state should change to fetched", () async {
    // given
    final store = createTestStore(
      searchCitiesService: FakeSearchCitiesService(),
      initialState: createAppState(
        searchCitiesState: SearchCitiesInitialState(),
      ),
    );
    final loadingState = store.onChange.firstWhere((element) => element.searchCitiesState is SearchCitiesLoadingState);
    final appState = store.onChange.firstWhere((element) => element.searchCitiesState is SearchCitiesFetchedState);

    // when
    store.dispatch(FetchCitiesCommandAction(countryCode: "DE"));

    // then
    expect((await loadingState).searchCitiesState, isA<SearchCitiesLoadingState>());
    expect((await appState).searchCitiesState, isA<SearchCitiesFetchedState>());
  });

  test("When fetching for cities using a search term, the search term should be passed to the service", () async {
    // given
    final store = createTestStore(
      searchCitiesService: FakeSearchCitiesService(),
      initialState: createAppState(
        searchCitiesState: SearchCitiesInitialState(),
      ),
    );
    final loadingState = store.onChange.firstWhere((element) => element.searchCitiesState is SearchCitiesLoadingState);
    final appState = store.onChange.firstWhere((element) => element.searchCitiesState is SearchCitiesFetchedState);

    // when
    store.dispatch(FetchCitiesCommandAction(countryCode: "DE", searchTerm: "Berlin"));

    // then
    expect((await loadingState).searchCitiesState, isA<SearchCitiesLoadingState>());
    expect((await appState).searchCitiesState, isA<SearchCitiesFetchedState>());
    expect(((await appState).searchCitiesState as SearchCitiesFetchedState).searchTerm, "Berlin");
  });

  test("When failed fetching cities, the state should change to error", () async {
    // given
    final store = createTestStore(
      searchCitiesService: FakeFailingSearchCitiesService(),
      initialState: createAppState(
        searchCitiesState: SearchCitiesInitialState(),
      ),
    );
    final loadingState = store.onChange.firstWhere((element) => element.searchCitiesState is SearchCitiesLoadingState);
    final appState = store.onChange.firstWhere((element) => element.searchCitiesState is SearchCitiesErrorState);

    // when
    store.dispatch(FetchCitiesCommandAction(countryCode: "DE"));

    // then
    expect((await loadingState).searchCitiesState, isA<SearchCitiesLoadingState>());
    expect((await appState).searchCitiesState, isA<SearchCitiesErrorState>());
  });
}
