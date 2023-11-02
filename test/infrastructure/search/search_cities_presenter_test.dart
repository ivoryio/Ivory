import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/search/search_cities_presenter.dart';
import 'package:solarisdemo/models/search/search_cities_error_type.dart';
import 'package:solarisdemo/redux/search/search_cities_state.dart';

void main() {
  test("When state is initial it should return initial view model", () {
    // given
    final state = SearchCitiesInitialState();

    // when
    final viewModel = SearchCitiesPresenter.present(searchCitiesState: state);

    // then
    expect(viewModel, isA<SearchCitiesInitialViewModel>());
  });

  test("When state is loading it should return loading view model", () {
    // given
    final state = SearchCitiesLoadingState();

    // when
    final viewModel = SearchCitiesPresenter.present(searchCitiesState: state);

    // then
    expect(viewModel, isA<SearchCitiesLoadingViewModel>());
  });

  test("When state is fetched it should return fetched view model", () {
    // given
    final state = SearchCitiesFetchedState(cities: const ["city1", "city2"]);

    // when
    final viewModel = SearchCitiesPresenter.present(searchCitiesState: state);

    // then
    expect(viewModel, isA<SearchCitiesFetchedViewModel>());
  });

  test("When state is fetched and searchTerm is not null it should return fetched view model with searchTerm", () {
    // given
    final state = SearchCitiesFetchedState(cities: const ["city1", "city2"], searchTerm: "searchTerm");

    // when
    final viewModel = SearchCitiesPresenter.present(searchCitiesState: state);

    // then
    expect(viewModel, isA<SearchCitiesFetchedViewModel>());
    expect((viewModel as SearchCitiesFetchedViewModel).searchTerm, "searchTerm");
  });

  test("when state is error it should return error view model", () {
    // given
    final state = SearchCitiesErrorState(errorType: SearchCitiesErrorType.unknown);

    // when
    final viewModel = SearchCitiesPresenter.present(searchCitiesState: state);

    // then
    expect(viewModel, isA<SearchCitiesErrorViewModel>());
  });
}
