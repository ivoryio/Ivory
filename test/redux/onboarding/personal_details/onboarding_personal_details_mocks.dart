import 'package:solarisdemo/infrastructure/mobile_number/mobile_number_service.dart';
import 'package:solarisdemo/infrastructure/onboarding/personal_details/onboarding_personal_details_service.dart';
import 'package:solarisdemo/models/onboarding/onboarding_personal_details_error_type.dart';
import 'package:solarisdemo/models/suggestions/address_suggestion.dart';
import 'package:solarisdemo/models/user.dart';

class FakeOnboardingPersonalDetailsService extends OnboardingPersonalDetailsService {
  @override
  Future<OnboardingPersonalDetailsServiceResponse> createPerson({
    required User user,
    required AddressSuggestion address,
    required String birthDate,
    required String birthCity,
    required String birthCountry,
    required String nationality,
    required String addressLine,
  }) async {
    return OnboardingCreatePersonSuccessResponse(personId: "personId");
  }
}

class FakeFailingOnboardingPersonalDetailsService extends OnboardingPersonalDetailsService {
  @override
  Future<OnboardingPersonalDetailsServiceResponse> createPerson({
    required User user,
    required AddressSuggestion address,
    required String birthDate,
    required String birthCity,
    required String birthCountry,
    required String nationality,
    required String addressLine,
  }) async {
    return OnboardingPersonalDetailsServiceErrorResponse(errorType: OnboardingPersonalDetailsErrorType.unknown);
  }
}

class FakeMobileNumberService extends MobileNumberService {
  @override
  Future<MobileNumberServiceResponse> createMobileNumber({
    required String mobileNumber,
    required User user,
    String deviceData = '',
  }) async {
    return CreateMobileNumberSuccessResponse();
  }

  @override
  Future<MobileNumberServiceResponse> confirmMobileNumber({
    required String mobileNumber,
    required String token,
    required User user,
    String deviceData = '',
  }) async {
    return ConfirmMobileNumberSuccessResponse();
  }
}
