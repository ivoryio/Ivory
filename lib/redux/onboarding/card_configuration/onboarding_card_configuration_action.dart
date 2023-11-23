class GetCardPersonNameCommandAction {}

class OnboardingCreateCardCommandAction {}

class OnboardingCardLoadingEventAction {}
class OnboardingCardConfigurationFailedEventAction {}
class WithCardholderNameEventAction {
  final String cardholderName;

  WithCardholderNameEventAction({required this.cardholderName});
}