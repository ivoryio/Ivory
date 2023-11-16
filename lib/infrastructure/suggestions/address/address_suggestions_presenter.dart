import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/suggestions/address_suggestion.dart';
import 'package:solarisdemo/models/suggestions/address_suggestions_error_type.dart';
import 'package:solarisdemo/redux/suggestions/address/address_suggestions_state.dart';

class AddressSuggestionsPresenter {
  static AddressSuggestionsViewModel present({required AddressSuggestionsState addressSuggestionsState}) {
    if (addressSuggestionsState is AddressSuggestionsFetchedState) {
      return AddressSuggestionsFetchedViewModel(suggestions: addressSuggestionsState.suggestions);
    } else if (addressSuggestionsState is AddressSuggestionsLoadingState) {
      return AddressSuggestionsLoadingViewModel();
    } else if (addressSuggestionsState is AddressSuggestionsErrorState) {
      return AddressSuggestionsErrorViewModel(errorType: addressSuggestionsState.errorType);
    }

    return AddressSuggestionsInitialViewModel();
  }
}

abstract class AddressSuggestionsViewModel extends Equatable {
  @override
  List<Object> get props => [];
}

class AddressSuggestionsInitialViewModel extends AddressSuggestionsViewModel {}

class AddressSuggestionsLoadingViewModel extends AddressSuggestionsViewModel {}

class AddressSuggestionsFetchedViewModel extends AddressSuggestionsViewModel {
  final List<AddressSuggestion> suggestions;

  AddressSuggestionsFetchedViewModel({required this.suggestions});

  @override
  List<Object> get props => [suggestions];
}

class AddressSuggestionsErrorViewModel extends AddressSuggestionsViewModel {
  final AddressSuggestionsErrorType errorType;

  AddressSuggestionsErrorViewModel({required this.errorType});

  @override
  List<Object> get props => [errorType];
}
