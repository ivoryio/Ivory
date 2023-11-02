import 'package:solarisdemo/infrastructure/search/search_cities_service.dart';
import 'package:solarisdemo/models/search/search_cities_error_type.dart';

class FakeSearchCitiesService extends SearchCitiesService {
  @override
  Future<SearchCitiesServiceResponse> fetchCities({required String countryCode, String? searchTerm}) async {
    return SearchCitiesSuccessResponse(cities: const ['city1', 'city2']);
  }
}

class FakeFailingSearchCitiesService extends SearchCitiesService {
  @override
  Future<SearchCitiesServiceResponse> fetchCities({required String countryCode, String? searchTerm}) async {
    return SearchCitiesErrorResponse(errorType: SearchCitiesErrorType.unknown);
  }
}
