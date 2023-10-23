import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_action.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_state.dart';

OnboardingSignupState onboardingSignupReducer(OnboardingSignupState state, dynamic action) {
  if (state is OnboardingSignupSubmittedState) {
    if (action is SubmitOnboardingBasicInfoCommandAction) {
      return OnboardingSignupSubmittedState(
        title: action.title,
        firstName: action.firstName,
        lastName: action.lastName,
        notificationsAllowed: state.notificationsAllowed,
      );
    } else if (action is SubmitOnboardingEmailCommandAction) {
      return OnboardingSignupSubmittedState(
        email: action.email,
        firstName: state.firstName,
        lastName: state.lastName,
        title: state.title,
        notificationsAllowed: state.notificationsAllowed,
      );
    } else if (action is SubmitOnboardingPasswordCommandAction) {
      return OnboardingSignupSubmittedState(
        email: state.email,
        firstName: state.firstName,
        lastName: state.lastName,
        password: action.password,
        title: state.title,
        notificationsAllowed: state.notificationsAllowed,
      );
    } else if (action is UpdatedPushNotificationsPermissionEventAction) {
      return OnboardingSignupSubmittedState(
        email: state.email,
        firstName: state.firstName,
        lastName: state.lastName,
        password: state.password,
        title: state.title,
        notificationsAllowed: action.allowed,
      );
    }
  }

  return state;
}
