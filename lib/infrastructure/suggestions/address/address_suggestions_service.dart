import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/suggestions/address_suggestion.dart';
import 'package:solarisdemo/models/suggestions/address_suggestions_error_type.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

class AddressSuggestionsService extends ApiService {
  AddressSuggestionsService({super.user});

  Future<AddressSuggestionsServiceResponse> getAddressSuggestions({required User user, required String query}) async {
    this.user = user;

    try {
      final data = await get(
        'signup/address_suggestions',
        queryParameters: {
          "queryString": query,
        },
      );

      return GetAddressSuggestionsSuccessResponse(
        suggestions: (data["suggestions"] as List)
            .map((suggestion) => AddressSuggestion(
                  address: suggestion['address'],
                  city: suggestion['city'],
                  country: suggestion['country'],
                ))
            .toList(),
      );
    } catch (error) {
      return GetAddressSuggestionsErrorResponse(errorType: AddressSuggestionsErrorType.unknown);
    }
  }
}

abstract class AddressSuggestionsServiceResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAddressSuggestionsSuccessResponse extends AddressSuggestionsServiceResponse {
  final List<AddressSuggestion> suggestions;

  GetAddressSuggestionsSuccessResponse({required this.suggestions});

  @override
  List<Object?> get props => [suggestions];
}

class GetAddressSuggestionsErrorResponse extends AddressSuggestionsServiceResponse {
  final AddressSuggestionsErrorType errorType;

  GetAddressSuggestionsErrorResponse({required this.errorType});

  @override
  List<Object?> get props => [errorType];
}
