import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_action.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_state.dart';

OnboardingSignupSubmittedState onboardingSignupReducer(OnboardingSignupSubmittedState state, dynamic action) {
  if (action is SubmitOnboardingBasicInfoCommandAction) {
    return OnboardingSignupSubmittedState(
      title: action.title,
      firstName: action.firstName,
      lastName: action.lastName,
      email: state.email,
      password: state.password,
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
  } else if (action is OnboardingSignupSuccessEventAction) {
    return OnboardingSignupSubmittedState(
      title: state.title,
      email: state.email,
      firstName: state.firstName,
      lastName: state.lastName,
      password: state.password,
      notificationsAllowed: state.notificationsAllowed,
    );
  } else if (action is OnboardingSignupFailedEventAction) {
    return OnboardingSignupSubmittedState(
      title: state.title,
      firstName: state.firstName,
      lastName: state.lastName,
      email: state.email,
      password: state.password,
      notificationsAllowed: state.notificationsAllowed,
    );
  }

  return state;
}
