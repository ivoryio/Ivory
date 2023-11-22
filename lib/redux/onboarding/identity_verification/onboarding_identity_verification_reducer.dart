import 'package:solarisdemo/redux/onboarding/identity_verification/onboarding_identity_verification_action.dart';
import 'package:solarisdemo/redux/onboarding/identity_verification/onboarding_identity_verification_state.dart';

OnboardingIdentityVerificationState identityVerificationReducer(
    OnboardingIdentityVerificationState state, dynamic action) {
  if (action is OnboardingIdentityVerificationLoadingEventAction) {
    return const OnboardingIdentityVerificationState(
      isLoading: true,
    );
  } else if (action is CreateIdentificationSuccessEventAction) {
    return OnboardingIdentityVerificationState(
      isLoading: false,
      urlForIntegration: action.urlForIntegration,
    );
  } else if (action is CreateIdentificationFailedEventAction) {
    return OnboardingIdentityVerificationState(
      isLoading: false,
      errorType: action.errorType,
    );
  }

  return state;
}
