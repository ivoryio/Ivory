import 'package:solarisdemo/redux/onboarding/signup/email/onboarding_email_action.dart';
import 'package:solarisdemo/redux/onboarding/signup/email/onboarding_email_state.dart';

OnboardingEmailState onboardingEmailReducer(OnboardingEmailState state, dynamic action) {
  if (action is OnboardingSubmitEmailCommandAction) {
    return OnboardingEmailSubmittedState(
      email: action.email,
    );
  }

  return state;
}
