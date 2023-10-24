import 'package:solarisdemo/infrastructure/onboarding/onboarding_service.dart';
import 'package:solarisdemo/models/user.dart';

class FakeOnboardingService extends OnboardingService {
  @override
  Future<OnboardingServiceResponse> getOnboardingProgress({User? user}) async {
    return OnboardingProgressSuccessResponse(currentStep: 'signup');
  }
}

class FakeFailingOnboardingService extends OnboardingService {
  @override
  Future<OnboardingServiceResponse> getOnboardingProgress({User? user}) async {
    return OnboardingProgressErrorResponse();
  }
}
