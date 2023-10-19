import 'package:solarisdemo/redux/onboarding/signup/onboarding_basic_info_action.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_email_action.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_password_action.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_state.dart';

OnboardingSignupState onboardingSignupReducer(OnboardingSignupState state, dynamic action) {
  if (action is SubmitOnboardingBasicInfoCommandAction) {
    return OnboardingSignupSubmittedState(title: action.title, firstName: action.firstName, lastName: action.lastName);
  } else if (action is SubmitOnboardingEmailCommandAction) {
    return OnboardingSignupSubmittedState(email: action.email);
  } else if (action is SubmitOnboardingPasswordCommandAction) {
    return OnboardingSignupSubmittedState(password: action.password);
  }

  return state;
}
