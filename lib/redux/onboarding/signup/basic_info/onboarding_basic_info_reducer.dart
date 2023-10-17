import 'package:solarisdemo/redux/onboarding/signup/basic_info/onboarding_basic_info_action.dart';
import 'package:solarisdemo/redux/onboarding/signup/basic_info/onboarding_basic_info_state.dart';

OnboardingBasicInfoState onboardingBasicInfoReducer(OnboardingBasicInfoState state, dynamic action) {
  if (action is SubmitOnboardingBasicInfoCommandAction) {
    return OnboardingBasicInfoSubmittedState(
      title: action.title,
      firstName: action.firstName,
      lastName: action.lastName,
    );
  }

  return state;
}
