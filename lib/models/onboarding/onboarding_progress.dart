enum OnboardingStep {
  start,
  signUp,
}

extension OnboardingStepExtension on OnboardingStep {
  static OnboardingStep fromString(String value) {
    switch (value) {
      case "start":
        return OnboardingStep.start;
      case "signedUp":
        return OnboardingStep.signUp;
      default:
        throw Exception("Unknown onboarding step");
    }
  }
}
