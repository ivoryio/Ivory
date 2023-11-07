import 'package:solarisdemo/infrastructure/onboarding/personal_details/onboarding_personal_details_service.dart';
import 'package:solarisdemo/models/onboarding/onboarding_personal_details_error_type.dart';
import 'package:solarisdemo/models/user.dart';

class FakeOnboardingPersonalDetailsService extends OnboardingPersonalDetailsService {
  @override
  Future<OnboardingPersonalDetailsServiceResponse> createPerson({required User user}) async {
    return OnboardingCreatePersonSuccessResponse(personId: "personId");
  }
}

class FakeFailingOnboardingPersonalDetailsService extends OnboardingPersonalDetailsService {
  @override
  Future<OnboardingPersonalDetailsServiceResponse> createPerson({required User user}) async {
    return OnboardingPersonalDetailsServiceErrorResponse(errorType: OnboardingPersonalDetailsErrorType.unknown);
  }
}
