import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:solarisdemo/models/search/search_cities_error_type.dart';

class SearchCitiesService {
  Future<SearchCitiesServiceResponse> fetchCities({required String countryCode, String? searchTerm}) async {
    try {
      return SearchCitiesSuccessResponse(cities: []);
    } catch (error) {
      return SearchCitiesErrorResponse(errorType: SearchCitiesErrorType.unknown);
    }
  }
}

abstract class SearchCitiesServiceResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchCitiesSuccessResponse extends SearchCitiesServiceResponse {
  final List<String> cities;

  SearchCitiesSuccessResponse({required this.cities});

  @override
  List<Object> get props => [cities];
}

class SearchCitiesErrorResponse extends SearchCitiesServiceResponse {
  final SearchCitiesErrorType errorType;

  SearchCitiesErrorResponse({required this.errorType});

  @override
  List<Object> get props => [errorType];
}
