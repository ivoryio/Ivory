import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_action.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_state.dart';

OnboardingSignupSubmittedState onboardingSignupReducer(OnboardingSignupSubmittedState state, dynamic action) {
  if (action is SubmitOnboardingSignupCommandAction) {
    return OnboardingSignupSubmittedState(
      title: action.signupAttributes.title,
      firstName: action.signupAttributes.firstName,
      lastName: action.signupAttributes.lastName,
      email: action.signupAttributes.email,
      password: action.signupAttributes.password,
      notificationsAllowed: action.signupAttributes.pushNotificationsAllowed,
      tsAndCsSignedAt: action.signupAttributes.tsAndCsSignedAt,
    );
  } else if (action is UpdatedPushNotificationsPermissionEventAction) {
    return OnboardingSignupSubmittedState(
      email: state.email,
      firstName: state.firstName,
      lastName: state.lastName,
      password: state.password,
      title: state.title,
      notificationsAllowed: action.allowed,
      tsAndCsSignedAt: state.tsAndCsSignedAt,
    );
  } else if (action is OnboardingSignupSuccessEventAction) {
    return OnboardingSignupSubmittedState(
      title: state.title,
      email: state.email,
      firstName: state.firstName,
      lastName: state.lastName,
      password: state.password,
      notificationsAllowed: state.notificationsAllowed,
      tsAndCsSignedAt: state.tsAndCsSignedAt,
    );
  } else if (action is OnboardingSignupFailedEventAction) {
    return OnboardingSignupSubmittedState(
      title: state.title,
      firstName: state.firstName,
      lastName: state.lastName,
      email: state.email,
      password: state.password,
      notificationsAllowed: state.notificationsAllowed,
      tsAndCsSignedAt: state.tsAndCsSignedAt,
    );
  }

  return state;
}
