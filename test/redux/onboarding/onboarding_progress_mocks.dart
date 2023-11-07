import 'package:solarisdemo/infrastructure/onboarding/onboarding_service.dart';
import 'package:solarisdemo/models/onboarding/onboarding_progress.dart';
import 'package:solarisdemo/models/user.dart';

class FakeOnboardingService extends OnboardingService {
  @override
  Future<OnboardingServiceResponse> getOnboardingProgress({User? user}) async {
    return OnboardingProgressSuccessResponse(step: OnboardingStep.signedUp);
  }
}

class FakeFailingOnboardingService extends OnboardingService {
  @override
  Future<OnboardingServiceResponse> getOnboardingProgress({User? user}) async {
    return OnboardingProgressErrorResponse();
  }
}
