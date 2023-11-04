import 'package:solarisdemo/redux/suggestions/city_suggestions_action.dart';
import 'package:solarisdemo/redux/suggestions/city_suggestions_state.dart';

CitySuggestionsState citySuggestionsReducer(CitySuggestionsState state, dynamic action) {
  if (action is CitySuggestionsLoadingEventAction) {
    return CitySuggestionsLoadingState();
  } else if (action is CitySuggestionsFetchedEventAction) {
    return CitySuggestionsFetchedState(cities: action.cities, searchTerm: action.searchTerm);
  } else if (action is FetchCitySuggestionsFailedEventAction) {
    return CitySuggestionsErrorState(errorType: action.errorType);
  }

  return state;
}
