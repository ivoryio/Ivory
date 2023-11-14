enum OnboardingStep {
  start,
  signedUp,
  personCreated,
  phoneNumberVerified,
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
      case "personCreated":
        return OnboardingStep.personCreated;
      case "phoneNumberVerified":
        return OnboardingStep.phoneNumberVerified;
      case "phoneNumberConfirmed":
        return OnboardingStep.phoneNumberConfirmed;
      case "taxIdAdded":
        return OnboardingStep.taxIdAdded;
      default:
        return OnboardingStep.unknown;
    }
  }
}
