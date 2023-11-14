import 'package:solarisdemo/infrastructure/onboarding/onboarding_service.dart';
import 'package:solarisdemo/models/onboarding/onboarding_progress.dart';
import 'package:solarisdemo/models/user.dart';

class FakeOnboardingService extends OnboardingService {
  @override
  Future<OnboardingServiceResponse> getOnboardingProgress({User? user}) async {
    return OnboardingProgressSuccessResponse(step: OnboardingStep.signedUp, mobileNumber: '');
  }
}

class FakeFailingOnboardingService extends OnboardingService {
  @override
  Future<OnboardingServiceResponse> getOnboardingProgress({User? user}) async {
    return OnboardingProgressErrorResponse();
  }
}

class FakeOnboardingServiceWithMobileNumber extends OnboardingService {
  @override
  Future<OnboardingServiceResponse> getOnboardingProgress({User? user}) async {
    return OnboardingProgressSuccessResponse(step: OnboardingStep.phoneNumberVerified, mobileNumber: '123456');
  }
}
