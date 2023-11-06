import 'package:solarisdemo/redux/suggestions/address/address_suggestions_action.dart';
import 'package:solarisdemo/redux/suggestions/address/address_suggestions_state.dart';

AddressSuggestionsState addressSuggestionsReducer(AddressSuggestionsState state, dynamic action) {
  if (action is AddressSuggestionsLoadingEventAction) {
    return AddressSuggestionsLoadingState();
  } else if (action is AddressSuggestionsFetchedEventAction) {
    return AddressSuggestionsFetchedState(suggestions: action.suggestions);
  } else if (action is FetchAddressSuggestionsFailedEventAction) {
    return AddressSuggestionsErrorState(errorType: action.errorType);
  }

  return state;
}
