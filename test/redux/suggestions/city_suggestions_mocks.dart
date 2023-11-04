import 'package:solarisdemo/infrastructure/suggestions/city/city_suggestions_service.dart';
import 'package:solarisdemo/models/suggestions/city_suggestions_error_type.dart';

class FakeCitySuggestionsService extends CitySuggestionsService {
  @override
  Future<CitySuggestionsServiceResponse> fetchCities({required String countryCode, String? searchTerm}) async {
    return FetchCitySuggestionsSuccessResponse(cities: const ['city1', 'city2']);
  }
}

class FakeFailingCitySuggestionsService extends CitySuggestionsService {
  @override
  Future<CitySuggestionsServiceResponse> fetchCities({required String countryCode, String? searchTerm}) async {
    return FetchCitySuggestionsErrorResponse(errorType: CitySuggestionsErrorType.unknown);
  }
}
