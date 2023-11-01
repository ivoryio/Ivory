import 'package:mockito/mockito.dart';
import 'package:solarisdemo/infrastructure/onboarding/onboarding_service.dart';
import 'package:solarisdemo/models/onboarding/onboarding_persona_details_address_suggestions.dart';
import 'package:solarisdemo/models/user.dart';

class MockAuthenticatedUser extends Mock implements AuthenticatedUser {}

List<AddressSuggestion> mockSuggestions = [
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

AddressSuggestion mockSelectedSuggestion = AddressSuggestion(
  address: "address",
  city: "city",
  country: "country",
);

class FakeOnboardingService extends OnboardingService {
  @override
  Future<OnboardingServiceResponse> getAddressSuggestions({
    required String queryString,
    required User user,
  }) async {
    return OnboardingGetAddressSuggestionsSuccessResponse(
      suggestions: mockSuggestions
    );
  }
}
