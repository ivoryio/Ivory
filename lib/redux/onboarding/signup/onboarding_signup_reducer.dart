import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_action.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_state.dart';

OnboardingSignupState onboardingSignupReducer(OnboardingSignupState state, dynamic action) {
  if (action is SubmitOnboardingBasicInfoCommandAction) {
    return OnboardingSignupState(
      signupAttributes: state.signupAttributes.copyWith(
        title: action.title,
        firstName: action.firstName,
        lastName: action.lastName,
      ),
    );
  } else if (action is SubmitOnboardingEmailCommandAction) {
    return OnboardingSignupState(
      signupAttributes: state.signupAttributes.copyWith(
        email: action.email,
      ),
    );
  } else if (action is SubmitOnboardingPasswordCommandAction) {
    return OnboardingSignupState(
      signupAttributes: state.signupAttributes.copyWith(
        password: action.password,
      ),
    );
  } else if (action is UpdatedPushNotificationsPermissionEventAction) {
    return OnboardingSignupState(
      signupAttributes: state.signupAttributes.copyWith(
        notificationsAllowed: action.allowed,
      ),
    );
  } else if (action is OnboardingSignupLoadingEventAction) {
    return OnboardingSignupState(
      signupAttributes: state.signupAttributes,
      isLoading: true,
    );
  } else if (action is OnboardingSignupSuccessEventAction) {
    return OnboardingSignupState(
      signupAttributes: state.signupAttributes,
      isLoading: false,
      isSuccessful: true,
    );
  } else if (action is OnboardingSignupFailedEventAction) {
    return OnboardingSignupState(
      signupAttributes: state.signupAttributes,
      isLoading: false,
      isSuccessful: false,
      errorType: action.errorType,
    );
  }

  return state;
}
