import 'package:solarisdemo/infrastructure/suggestions/address/address_suggestions_service.dart';
import 'package:solarisdemo/infrastructure/suggestions/city/city_suggestions_service.dart';
import 'package:solarisdemo/models/suggestions/address_suggestion.dart';
import 'package:solarisdemo/models/suggestions/address_suggestions_error_type.dart';
import 'package:solarisdemo/models/suggestions/city_suggestions_error_type.dart';
import 'package:solarisdemo/models/user.dart';

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

List<AddressSuggestion> mockSuggestions = const [
  AddressSuggestion(
    address: "address",
    city: "city",
    country: "country",
  ),
  AddressSuggestion(
    address: "address2",
    city: "city2",
    country: "country2",
  ),
];

class FakeAddressSuggestionsService extends AddressSuggestionsService {
  @override
  Future<AddressSuggestionsServiceResponse> getAddressSuggestions({required User user, required String query}) async {
    return GetAddressSuggestionsSuccessResponse(suggestions: mockSuggestions);
  }
}

class FakeFailingAddressSuggestionsService extends AddressSuggestionsService {
  @override
  Future<AddressSuggestionsServiceResponse> getAddressSuggestions({required User user, required String query}) async {
    return GetAddressSuggestionsErrorResponse(errorType: AddressSuggestionsErrorType.unknown);
  }
}
