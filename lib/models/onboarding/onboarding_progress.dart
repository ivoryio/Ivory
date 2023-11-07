enum OnboardingStep {
  start,
  signedUp,
  unknown,
}

extension OnboardingStepExtension on OnboardingStep {
  static OnboardingStep fromString(String value) {
    switch (value) {
      case "start":
        return OnboardingStep.start;
      case "signedUp":
        return OnboardingStep.signedUp;
      default:
        throw OnboardingStep.unknown;
    }
  }
}
