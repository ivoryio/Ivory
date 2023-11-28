class GetCardPersonNameCommandAction {}

class OnboardingCreateCardCommandAction {}

class OnboardingCreateCardLoadingEventAction {}
class OnboardingCardConfigurationFailedEventAction {}
class OnboardingCardConfigurationGenericSuccessEventAction {}

class WithCardholderNameEventAction {
  final String cardholderName;

  WithCardholderNameEventAction({required this.cardholderName});
}