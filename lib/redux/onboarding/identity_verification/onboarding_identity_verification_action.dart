import 'package:solarisdemo/models/onboarding/onboarding_identity_verification_error_type.dart';

class CreateReferenceAccountIbanCommandAction {
  final String accountName;
  final String iban;

  CreateReferenceAccountIbanCommandAction({
    required this.accountName,
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
