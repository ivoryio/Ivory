import 'package:solarisdemo/redux/search/search_cities_action.dart';
import 'package:solarisdemo/redux/search/search_cities_state.dart';

SearchCitiesState searchCitiesReducer(SearchCitiesState state, dynamic action) {
  if (action is CitiesLoadingEventAction) {
    return SearchCitiesLoadingState();
  } else if (action is CitiesFetchedEventAction) {
    return SearchCitiesFetchedState(cities: action.cities, searchTerm: action.searchTerm);
  } else if (action is CitiesErrorEventAction) {
    return SearchCitiesErrorState(errorType: action.errorType);
  }

  return state;
}
