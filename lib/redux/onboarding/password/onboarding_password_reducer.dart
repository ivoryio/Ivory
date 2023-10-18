import 'package:solarisdemo/redux/onboarding/password/onboarding_password_action.dart';
import 'package:solarisdemo/redux/onboarding/password/onboarding_password_state.dart';

OnboardingPasswordState onboardingPasswordReducer(
  OnboardingPasswordState state,
  dynamic action,
) {
  if (action is OnboardingSubmitPasswordCommandAction) {
    return OnboardingPasswordSubmittedState(
      password: action.password,
    );
  }

  return state;
}
