import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/suggestions/city_suggestions_presenter.dart';
import 'package:solarisdemo/models/suggestions/city_suggestions_error_type.dart';
import 'package:solarisdemo/redux/suggestions/city_suggestions_state.dart';

void main() {
  test("When state is initial it should return initial view model", () {
    // given
    final state = CitySuggestionsInitialState();

    // when
    final viewModel = CitySuggestionsPresenter.present(citySuggestionsState: state);

    // then
    expect(viewModel, isA<CitySuggestionsInitialViewModel>());
  });

  test("When state is loading it should return loading view model", () {
    // given
    final state = CitySuggestionsLoadingState();

    // when
    final viewModel = CitySuggestionsPresenter.present(citySuggestionsState: state);

    // then
    expect(viewModel, isA<CitySuggestionsLoadingViewModel>());
  });

  test("When state is fetched it should return fetched view model", () {
    // given
    final state = CitySuggestionsFetchedState(cities: const ["city1", "city2"]);

    // when
    final viewModel = CitySuggestionsPresenter.present(citySuggestionsState: state);

    // then
    expect(viewModel, isA<CitySuggestionsFetchedViewModel>());
  });

  test("When state is fetched and searchTerm is not null it should return fetched view model with searchTerm", () {
    // given
    final state = CitySuggestionsFetchedState(cities: const ["city1", "city2"], searchTerm: "searchTerm");

    // when
    final viewModel = CitySuggestionsPresenter.present(citySuggestionsState: state);

    // then
    expect(viewModel, isA<CitySuggestionsFetchedViewModel>());
    expect((viewModel as CitySuggestionsFetchedViewModel).searchTerm, "searchTerm");
  });

  test("when state is error it should return error view model", () {
    // given
    final state = CitySuggestionsErrorState(errorType: CitySuggestionsErrorType.unknown);

    // when
    final viewModel = CitySuggestionsPresenter.present(citySuggestionsState: state);

    // then
    expect(viewModel, isA<CitySuggestionsErrorViewModel>());
  });
}
