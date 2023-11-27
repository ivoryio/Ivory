import 'package:solarisdemo/models/onboarding/onboarding_identity_verification_error_type.dart';

class CreateIdentificationCommandAction {
  final String accountName;
  final String iban;

  CreateIdentificationCommandAction({
    required this.accountName,
    required this.iban,
  });
}

class OnboardingIdentityVerificationLoadingEventAction {}

class CreateIdentificationSuccessEventAction {
  final String urlForIntegration;

  CreateIdentificationSuccessEventAction({required this.urlForIntegration});
}

class CreateIdentificationFailedEventAction {
  final OnboardingIdentityVerificationErrorType errorType;

  CreateIdentificationFailedEventAction({required this.errorType});
}

class AuthorizeIdentificationSigningCommandAction {}

class SignWithTanCommandAction {
  final String tan;

  SignWithTanCommandAction({required this.tan});
}

class SignWithTanSuccessEventAction {}
