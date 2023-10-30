import 'package:solarisdemo/infrastructure/onboarding/onboarding_signup_service.dart';
import 'package:solarisdemo/models/onboarding/onboarding_signup_attributes.dart';
import 'package:solarisdemo/models/onboarding/onboarding_signup_error_type.dart';

class FakeOnboardingSignupService extends OnboardingSignupService {
  @override
  Future<OnboardingSignupServiceResponse> createPerson({
    required OnboardingSignupAttributes signupAttributes,
    required String deviceToken,
    required String tsAndCsSignedAt,
  }) async {
    return CreatePersonSuccesResponse();
  }
}

class FakeFailingOnboardingSignupService extends OnboardingSignupService {
  @override
  Future<OnboardingSignupServiceResponse> createPerson({
    required OnboardingSignupAttributes signupAttributes,
    required String deviceToken,
    required String tsAndCsSignedAt,
  }) async {
    return const CreatePersonErrorResponse();
  }
}

class FakeFailingOnboardingSignupServiceWithDuplicateEmail extends OnboardingSignupService {
  @override
  Future<OnboardingSignupServiceResponse> createPerson({
    required OnboardingSignupAttributes signupAttributes,
    required String deviceToken,
    required String tsAndCsSignedAt,
  }) async {
    return const CreatePersonErrorResponse(errorType: OnboardingSignupErrorType.emailAlreadyExists);
  }
}
