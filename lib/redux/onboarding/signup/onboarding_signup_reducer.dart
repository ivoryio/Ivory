import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_action.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_state.dart';

OnboardingSignupState onboardingSignupReducer(OnboardingSignupState state, dynamic action) {
  if (action is SubmitOnboardingBasicInfoCommandAction) {
    return OnboardingSignupSubmittedState(title: action.title, firstName: action.firstName, lastName: action.lastName);
  } else if (action is SubmitOnboardingEmailCommandAction && state is OnboardingSignupSubmittedState) {
    return OnboardingSignupSubmittedState(
      email: action.email,
      firstName: state.firstName,
      lastName: state.lastName,
      title: state.title,
    );
  } else if (action is SubmitOnboardingPasswordCommandAction && state is OnboardingSignupSubmittedState) {
    return OnboardingSignupSubmittedState(
      email: state.email,
      firstName: state.firstName,
      lastName: state.lastName,
      password: action.password,
      title: state.title,
    );
  }

  return state;
}
