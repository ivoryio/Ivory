import 'package:solarisdemo/redux/onboarding/onboarding_progress_action.dart';

import 'onboarding_progress_state.dart';

OnboardingProgressState onboardingProgressReducer(OnboardingProgressState currentState, dynamic action) {
  if (action is OnboardingProgressLoadingEventAction) {
    return OnboardingProgressInitialLoadingState();
  } else if (action is OnboardingProgressFetchedEvendAction) {
    return OnboardingProgressFetchedState(step: action.step);
  } else if (action is OnboardingProgressFailedEventAction) {
    return OnboardingProgressErrorState();
  } else if (action is OnboardingFinalizedEventAction) {
    return OnboardingFinalizedState();
  }

  return currentState;
}
