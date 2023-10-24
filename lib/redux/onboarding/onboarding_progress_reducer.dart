import 'package:solarisdemo/redux/onboarding/onboarding_progress_action.dart';

import 'onboarding_progress_state.dart';

OnboardingProgressState onboardingProgressReducer(OnboardingProgressState currentState, dynamic action) {
  if (action is OnboardingProgressFetchedEvendAction) {
    return OnboardingProgressFetchedState(currentStep: action.currentStep);
  } else if (action is GetOnboardingProgressFailedEventAction) {
    return OnboardingProgressErrorState();
  }

  return currentState;
}
