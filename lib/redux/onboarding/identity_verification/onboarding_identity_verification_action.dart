import 'package:solarisdemo/models/onboarding/onboarding_identification_status.dart';
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

class GetSignupIdentificationInfoCommandAction {}

class SignupIdentificationInfoFetchedEventAction {
  final OnboardingIdentificationStatus identificationStatus;

  SignupIdentificationInfoFetchedEventAction({required this.identificationStatus});
}

class AuthorizeIdentificationSigningCommandAction {}

class OnboardingIdentityAuthorizationLoadingEventAction {}

class AuthorizeIdentificationSigningSuccessEventAction {}

class OnboardingIdentityVerificationErrorEventAction {
  final OnboardingIdentityVerificationErrorType errorType;

  OnboardingIdentityVerificationErrorEventAction({required this.errorType});
}

class SignWithTanCommandAction {
  final String tan;

  SignWithTanCommandAction({required this.tan});
}

class SignWithTanSuccessEventAction {}

class GetCreditLimitCommandAction {}

class CreditLimitSuccessEventAction {
  final int approvedCreditLimit;

  CreditLimitSuccessEventAction({required this.approvedCreditLimit});
}

class FinalizeIdCommandAction {}

class FinalizeIdentificationLoadingEventAction {}

class FinalizeIdentificationSuccessEventAction {}
