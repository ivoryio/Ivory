import 'package:solarisdemo/redux/onboarding/identity_verification/onboarding_identity_verification_action.dart';
import 'package:solarisdemo/redux/onboarding/identity_verification/onboarding_identity_verification_state.dart';

OnboardingIdentityVerificationState identityVerificationReducer(
    OnboardingIdentityVerificationState state, dynamic action) {
  if (action is OnboardingIdentityVerificationLoadingEventAction) {
    return const OnboardingIdentityVerificationState(
      isLoading: true,
    );
  } else if (action is OnboardingIdentityAuthorizationLoadingEventAction) {
    return OnboardingIdentityVerificationState(
      isLoading: true,
      status: state.status,
    );
  } else if (action is CreateIdentificationSuccessEventAction) {
    return OnboardingIdentityVerificationState(
      isLoading: false,
      urlForIntegration: action.urlForIntegration,
    );
  } else if (action is SignupIdentificationInfoFetchedEventAction) {
    return OnboardingIdentityVerificationState(
      isLoading: false,
      status: action.identificationStatus,
    );
  } else if (action is AuthorizeIdentificationSigningSuccessEventAction) {
    return OnboardingIdentityVerificationState(
      isLoading: false,
      isAuthorized: true,
      status: state.status,
    );
  } else if (action is OnboardingIdentityVerificationErrorEventAction) {
    return OnboardingIdentityVerificationState(
      isLoading: false,
      errorType: action.errorType,
    );
  } else if (action is SignWithTanSuccessEventAction) {
    return const OnboardingIdentityVerificationState(
      isLoading: false,
      isTanConfirmed: true,
    );
  } else if (action is CreditLimitSuccessEventAction) {
    return OnboardingIdentityVerificationState(
      isLoading: false,
      creditLimit: action.approvedCreditLimit,
    );
  } else if (action is FinalizeIdentificationLoadingEventAction) {
    return OnboardingIdentityVerificationState(
      isLoading: true,
      creditLimit: state.creditLimit,
    );
  }

  return state;
}
