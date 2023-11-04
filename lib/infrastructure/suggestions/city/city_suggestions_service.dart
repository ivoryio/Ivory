import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/models/suggestions/city_suggestions_error_type.dart';

class CitySuggestionsService {
  Future<CitySuggestionsServiceResponse> fetchCities({required String countryCode, String? searchTerm}) async {
    try {
      final response = await http.get(CitySuggestionsService.url('/searchJSON', queryParameters: {
        'country': countryCode,
        'cities': 'cities15000',
        if (searchTerm != null) 'name_startsWith': searchTerm,
      }));

      if (response.statusCode != 200) {
        throw Exception("GET request response code: ${response.statusCode}");
      }

      final responseData = jsonDecode(response.body.isNotEmpty ? response.body : "{}");

      return FetchCitySuggestionsSuccessResponse(
        cities: (responseData['geonames'] as List)
            .map<String>(
              (city) => city['toponymName'],
            )
            .toList(),
      );
    } catch (error) {
      return FetchCitySuggestionsErrorResponse(errorType: CitySuggestionsErrorType.unknown);
    }
  }

  static url(String path, {Map<String, String> queryParameters = const {}}) {
    return Uri.http(
      "api.geonames.org",
      path,
      {'username': Config.geonamesUsername}..addAll(queryParameters),
    );
  }
}

abstract class CitySuggestionsServiceResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCitySuggestionsSuccessResponse extends CitySuggestionsServiceResponse {
  final List<String> cities;

  FetchCitySuggestionsSuccessResponse({required this.cities});

  @override
  List<Object> get props => [cities];
}

class FetchCitySuggestionsErrorResponse extends CitySuggestionsServiceResponse {
  final CitySuggestionsErrorType errorType;

  FetchCitySuggestionsErrorResponse({required this.errorType});

  @override
  List<Object> get props => [errorType];
}
