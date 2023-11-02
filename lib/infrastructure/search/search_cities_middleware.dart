import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/search/search_cities_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/search/search_cities_action.dart';

class SearchCitiesMiddleware extends MiddlewareClass<AppState> {
  final SearchCitiesService _searchCitiesService;

  SearchCitiesMiddleware(this._searchCitiesService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is FetchCitiesCommandAction) {
      store.dispatch(CitiesLoadingEventAction());

      final response = await _searchCitiesService.fetchCities(
        countryCode: action.countryCode,
        searchTerm: action.searchTerm,
      );

      if (response is SearchCitiesSuccessResponse) {
        store.dispatch(CitiesFetchedEventAction(cities: response.cities, searchTerm: action.searchTerm));
      } else if (response is SearchCitiesErrorResponse) {
        store.dispatch(CitiesErrorEventAction(errorType: response.errorType));
      }
    }
  }
}
