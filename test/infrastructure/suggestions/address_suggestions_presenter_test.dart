import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/suggestions/address/address_suggestions_presenter.dart';
import 'package:solarisdemo/models/suggestions/address_suggestions_error_type.dart';
import 'package:solarisdemo/redux/suggestions/address/address_suggestions_state.dart';

void main() {
  test("When state is initial it should return initial view model", () {
    // given
    final addressSuggestionsState = AddressSuggestionsInitialState();

    // when
    final viewModel = AddressSuggestionsPresenter.present(addressSuggestionsState: addressSuggestionsState);

    // then
    expect(viewModel, isA<AddressSuggestionsInitialViewModel>());
  });

  test("When state is loading it should return loading view model", () {
    // given
    final addressSuggestionsState = AddressSuggestionsLoadingState();

    // when
    final viewModel = AddressSuggestionsPresenter.present(addressSuggestionsState: addressSuggestionsState);

    // then
    expect(viewModel, isA<AddressSuggestionsLoadingViewModel>());
  });

  test("When state is fetched it should return fetched view model", () {
    // given
    final addressSuggestionsState = AddressSuggestionsFetchedState(suggestions: const []);

    // when
    final viewModel = AddressSuggestionsPresenter.present(addressSuggestionsState: addressSuggestionsState);

    // then
    expect(viewModel, isA<AddressSuggestionsFetchedViewModel>());
  });

  test("When state is error it should return error view model", () {
    // given
    final addressSuggestionsState = AddressSuggestionsErrorState(errorType: AddressSuggestionsErrorType.unknown);

    // when
    final viewModel = AddressSuggestionsPresenter.present(addressSuggestionsState: addressSuggestionsState);

    // then
    expect(viewModel, isA<AddressSuggestionsErrorViewModel>());
  });
}
