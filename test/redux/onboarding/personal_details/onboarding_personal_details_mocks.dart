import 'package:solarisdemo/infrastructure/onboarding/onboarding_service.dart';
import 'package:solarisdemo/models/onboarding/onboarding_persona_details_address_suggestions.dart';
import 'package:solarisdemo/models/user.dart';

class FakeOnboardingService extends OnboardingService {
  @override
  Future<OnboardingServiceResponse> getAddressSuggestions({
    required String queryString,
    required User user,
  }) async {
    return OnboardingGetAddressSuggestionsSuccessResponse(
      suggestions: [
        AddressSuggestion(address: 'street address', city: 'city', country: 'country'),
      ],
    );
  }
}
