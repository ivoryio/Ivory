import 'package:solarisdemo/infrastructure/onboarding/card_configuration/onboarding_card_configuration_service.dart';
import 'package:solarisdemo/models/user.dart';

class FakeOnboardingCardConfigurationService extends OnboardingCardConfigurationService {
  @override
  Future<OnboardingCardConfigurationResponse> getCardholderName({required User user}) async {
    return GetCardholderNameSuccessResponse(cardholderName: "Ivory TS");
  }

  @override
  Future<OnboardingCardConfigurationResponse> onboardingCreateCard({required User user}) async {
    return OnboardingCardConfigurationSuccessResponse();
  }

  @override
  Future<OnboardingCardConfigurationResponse> onboardingGetCardInfo({required User user}) async {
    return GetCardInfoSuccessResponse(
        cardholderName: "Ivory TS",
        maskedPAN: "493441******6055",
        expiryDate: "09/26",
    );
  }
}

class FakeFailingOnboardingCardConfigurationService extends OnboardingCardConfigurationService {
  @override
  Future<OnboardingCardConfigurationResponse> getCardholderName({required User user}) async {
    return OnboardingCardConfigurationErrorResponse();
  }

  @override
  Future<OnboardingCardConfigurationResponse> onboardingCreateCard({required User user}) async {
    return OnboardingCardConfigurationErrorResponse();
  }

  @override
  Future<OnboardingCardConfigurationResponse> onboardingGetCardInfo({required User user}) async {
    return OnboardingCardConfigurationErrorResponse();
  }
}