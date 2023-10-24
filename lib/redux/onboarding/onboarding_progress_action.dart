class GetOnboardingProgressCommandAction {}

class OnboardingProgressFetchedEvendAction {
  final String currentStep;

  OnboardingProgressFetchedEvendAction({required this.currentStep});
}

class GetOnboardingProgressFailedEventAction {}
