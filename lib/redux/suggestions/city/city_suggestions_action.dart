import 'package:solarisdemo/models/suggestions/city_suggestions_error_type.dart';

class FetchCitySuggestionsCommandAction {
  final String countryCode;
  final String? searchTerm;

  FetchCitySuggestionsCommandAction({required this.countryCode, this.searchTerm});
}

class CitySuggestionsFetchedEventAction {
  final List<String> cities;
  final String? searchTerm;

  CitySuggestionsFetchedEventAction({required this.cities, this.searchTerm});
}

class CitySuggestionsLoadingEventAction {}

class FetchCitySuggestionsFailedEventAction {
  final CitySuggestionsErrorType errorType;
  final String? searchTerm;

  FetchCitySuggestionsFailedEventAction({required this.errorType, this.searchTerm});
}
