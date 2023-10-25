import 'package:solarisdemo/redux/onboarding/onboarding_progress_action.dart';

import 'onboarding_progress_state.dart';

OnboardingProgressState onboardingProgressReducer(OnboardingProgressState currentState, dynamic action) {
  if (action is GetOnboardingProgressCommandAction) {
    return OnboardingProgressInitialLoadingState();
  } else if (action is OnboardingProgressFetchedEvendAction) {
    return OnboardingProgressFetchedState(step: action.step);
  } else if (action is GetOnboardingProgressFailedEventAction) {
    return OnboardingProgressErrorState();
  }

  return currentState;
}
