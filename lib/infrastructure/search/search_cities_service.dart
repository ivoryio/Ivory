import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/models/search/search_cities_error_type.dart';

class SearchCitiesService {
  Future<SearchCitiesServiceResponse> fetchCities({required String countryCode, String? searchTerm}) async {
    try {
      final response = await http.get(SearchCitiesService.url('/searchJSON', queryParameters: {
        'country': countryCode,
        'cities': 'cities15000',
        if (searchTerm != null) 'name_startsWith': searchTerm,
      }));

      if (response.statusCode != 200) {
        throw Exception("GET request response code: ${response.statusCode}");
      }

      final responseData = jsonDecode(response.body.isNotEmpty ? response.body : "{}");

      return SearchCitiesSuccessResponse(
        cities: (responseData['geonames'] as List)
            .map<String>(
              (city) => city['toponymName'],
            )
            .toList(),
      );
    } catch (error) {
      return SearchCitiesErrorResponse(errorType: SearchCitiesErrorType.unknown);
    }
  }

  static url(String path, {Map<String, String> queryParameters = const {}}) {
    return Uri.http(
      Config.geonamesApiUrl,
      path,
      {'username': Config.geonamesUsername}..addAll(queryParameters),
    );
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
