import 'package:solarisdemo/models/onboarding/onboarding_identity_verification_error_type.dart';

class CreateUrlForIntegrationCommandAction {
  final String accountName;
  final String iban;

  CreateUrlForIntegrationCommandAction({
    required this.accountName,
    required this.iban,
  });
}

class OnboardingIdentityVerificationLoadingEventAction {}

class CreateUrlForIntegrationSuccessEventAction {
  final String urlForIntegration;

  CreateUrlForIntegrationSuccessEventAction({required this.urlForIntegration});
}

class CreateUrlForIntegrationFailedEventAction {
  final OnboardingIdentityVerificationErrorType errorType;

  CreateUrlForIntegrationFailedEventAction({required this.errorType});
}
