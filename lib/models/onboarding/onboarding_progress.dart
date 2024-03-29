enum OnboardingStep {
  start,
  signedUp,
  personCreated,
  phoneNumberVerified,
  phoneNumberConfirmed,
  taxIdAdded,
  creditCardApplicationCreated,
  postboxItemsConfirmed,
  identificationContractsSigned,
  scoringSuccessful,
  scoringFailed,
  identificationFinished,
  repaymentConfigured,
  unknown,
}

extension OnboardingStepExtension on OnboardingStep {
  static OnboardingStep fromString(String value) {
    final Map<String, OnboardingStep> map = {
      "start": OnboardingStep.start,
      "signedUp": OnboardingStep.signedUp,
      "personCreated": OnboardingStep.personCreated,
      "phoneNumberVerified": OnboardingStep.phoneNumberVerified,
      "phoneNumberConfirmed": OnboardingStep.phoneNumberConfirmed,
      "taxIdAdded": OnboardingStep.taxIdAdded,
      "creditCardApplicationCreated": OnboardingStep.creditCardApplicationCreated,
      "postboxItemsConfirmed": OnboardingStep.postboxItemsConfirmed,
      "identificationContractsSigned": OnboardingStep.identificationContractsSigned,
      "scoringSuccessful": OnboardingStep.scoringSuccessful,
      "scoringFailed": OnboardingStep.scoringFailed,
      "identificationFinished": OnboardingStep.identificationFinished,
      "repaymentConfigured": OnboardingStep.repaymentConfigured,
    };

    return map[value] ?? OnboardingStep.unknown;
  }
}
