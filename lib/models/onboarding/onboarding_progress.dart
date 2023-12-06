enum OnboardingStep {
  start,
  signedUp,
  personCreated,
  phoneNumberVerified,
  phoneNumberConfirmed,
  taxIdAdded,
  creditCardApplicationCreated,
  postboxItemsConfirmed,
  scoringSuccessful,
  identificationFinished,
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
      case "creditCardApplicationCreated":
        return OnboardingStep.creditCardApplicationCreated;
      case "postboxItemsConfirmed":
        return OnboardingStep.postboxItemsConfirmed;
      case "scoringSuccessful":
        return OnboardingStep.scoringSuccessful;
      case "identificationFinished":
        return OnboardingStep.identificationFinished;
      default:
        return OnboardingStep.unknown;
    }
  }
}
