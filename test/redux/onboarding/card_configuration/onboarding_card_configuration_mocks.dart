import 'package:solarisdemo/infrastructure/onboarding/card_configuration/onboarding_card_configuration_service.dart';
import 'package:solarisdemo/models/transfer/credit_card_application.dart';
import 'package:solarisdemo/models/user.dart';

final mockCardApplication = CreditCardApplication(
  id: 'ff46c26e244f482a955ec0bb9a0170d4ccla',
  externalCustomerId: '',
  customerId: '73650ddb23b1187eeddd89698e378c5dcper',
  accountId: '153873e90e47a9de593b8c1e5ff9fbc0cacc',
  accountIban: 'DE03110101014701986781',
  referenceAccountId: 'fb561717c3d740fa84455b69960d32baracc',
  status: 'FINALIZED',
  productType: 'CONSUMER_CREDIT_CARD',
  billingStartDate: DateTime.parse('2023-09-16'),
  billingEndDate: DateTime.parse('2023-10-15'),
  repaymentOptions: RepaymentOptions(
    minimumAmount: ApprovedLimit(
      value: 10000,
      currency: Currency.EUR,
      unit: Unit.CENTS,
    ),
    upcomingType: '',
    currentType: '',
    upcomingBillingCycle: '',
    currentBillingCycle: '',
    gracePeriodInDays: 15,
    minimumAmountLowerThreshold: ApprovedLimit(
      value: 100,
      currency: Currency.EUR,
      unit: Unit.CENTS,
    ),
    minimumAmountUpperThreshold: ApprovedLimit(
      value: 100000,
      currency: Currency.EUR,
      unit: Unit.CENTS,
    ),
    minimumPercentage: 0,
    minimumPercentageLowerThreshold: 0,
    minimumPercentageUpperThreshold: 0,
  ),
);

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
