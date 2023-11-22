import 'package:solarisdemo/models/onboarding/onboarding_identity_verification_error_type.dart';

class CreateReferenceAccountIbanCommandAction {
  final String referenceAccount;
  final String iban;

  CreateReferenceAccountIbanCommandAction({
    required this.referenceAccount,
    required this.iban,
  });
}

class OnboardingIdentityVerificationLoadingEventAction {}

class CreateReferenceAccountIbanSuccessEventAction {
  final String urlForIntegration;

  CreateReferenceAccountIbanSuccessEventAction({required this.urlForIntegration});
}

class CreateReferenceAccountIbanFailedEventAction {
  final OnboardingIdentityVerificationErrorType errorType;

  CreateReferenceAccountIbanFailedEventAction({required this.errorType});
}
