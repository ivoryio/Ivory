import 'package:solarisdemo/models/search/search_cities_error_type.dart';

class FetchCitiesCommandAction {
  final String countryCode;
  final String? searchTerm;

  FetchCitiesCommandAction({required this.countryCode, this.searchTerm});
}

class CitiesFetchedEventAction {
  final List<String> cities;
  final String? searchTerm;

  CitiesFetchedEventAction({required this.cities, this.searchTerm});
}

class CitiesLoadingEventAction {}

class CitiesErrorEventAction {
  final SearchCitiesErrorType errorType;

  CitiesErrorEventAction({required this.errorType});
}
