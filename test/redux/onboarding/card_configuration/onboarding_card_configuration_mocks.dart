import 'package:solarisdemo/infrastructure/onboarding/card_configuration/onboarding_card_configuration_service.dart';
import 'package:solarisdemo/models/user.dart';

class FakeOnbordingCardConfigurationService extends OnboardingCardConfigurationService {
  @override
  Future<OnboardingCardConfigurationResponse> getCardholderName({required User user}) async {
    return GetCardholderNameSuccessResponse(cardholderName: "Ivory TS");
  }
}

class FakeFailingOnboardingCardConfigurationService extends OnboardingCardConfigurationService {
  @override
  Future<OnboardingCardConfigurationResponse> getCardholderName({required User user}) async {
    return OnboardingCardConfigurationErrorResponse();
  }
}