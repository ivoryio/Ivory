import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/suggestions/city_suggestions_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/suggestions/city_suggestions_action.dart';

class CitySuggestionsMiddleware extends MiddlewareClass<AppState> {
  final CitySuggestionsService _citySuggestionsService;

  CitySuggestionsMiddleware(this._citySuggestionsService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is FetchCitySuggestionsCommandAction) {
      store.dispatch(CitySuggestionsLoadingEventAction());

      final response = await _citySuggestionsService.fetchCities(
        countryCode: action.countryCode,
        searchTerm: action.searchTerm,
      );

      if (response is FetchCitySuggestionsSuccessResponse) {
        store.dispatch(CitySuggestionsFetchedEventAction(cities: response.cities, searchTerm: action.searchTerm));
      } else if (response is FetchCitySuggestionsErrorResponse) {
        store.dispatch(FetchCitySuggestionsFailedEventAction(errorType: response.errorType));
      }
    }
  }
}
