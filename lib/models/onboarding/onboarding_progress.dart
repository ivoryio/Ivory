enum OnboardingStep {
  start,
  signedUp,
  phoneNumberConfirmed,
  taxIdAdded,
  unknown,
}

extension OnboardingStepExtension on OnboardingStep {
  static OnboardingStep fromString(String value) {
    switch (value) {
      case "start":
        return OnboardingStep.start;
      case "signedUp":
        return OnboardingStep.signedUp;
      case "phoneNumberConfirmed":
        return OnboardingStep.phoneNumberConfirmed;
      case "taxIdAdded":
        return OnboardingStep.taxIdAdded;
      default:
        return OnboardingStep.unknown;
    }
  }
}
