import '../../../models/transfer/credit_card_application.dart';

class GetCardPersonNameCommandAction {}

class OnboardingCreateCardCommandAction {}

class GetOnboardingCardInfoCommandAction {}

class OnboardingCreateCardLoadingEventAction {}

class OnboardingCardConfigurationFailedEventAction {}

class OnboardingCardConfigurationGenericSuccessEventAction {}

class WithCardholderNameEventAction {
  final String cardholderName;

  WithCardholderNameEventAction({required this.cardholderName});
}

class WithCardInfoEventAction {
  final String cardholderName;
  final String maskedPAN;
  final String expiryDate;

  WithCardInfoEventAction({
    required this.cardholderName,
    required this.maskedPAN,
    required this.expiryDate,
  });
}

class OnboardingGetCreditCardApplicationCommandAction {}

class OnboardingGetCreditCardApplicationFailedEventAction {}

class OnboardingGetCreditCardApplicationSuccessEventAction {
  final CreditCardApplication creditCardApplication;

  OnboardingGetCreditCardApplicationSuccessEventAction({required this.creditCardApplication});
}

class OnboardingUpdateCreditCardApplicationCommandAction {}

class OnboardingUpdateCreditCardApplicationFailedEventAction {}

class OnboardingUpdateCreditCardApplicationSuccessEventAction {
  final CreditCardApplication creditCardApplication;

  OnboardingUpdateCreditCardApplicationSuccessEventAction({required this.creditCardApplication});
}
