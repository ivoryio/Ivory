import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_action.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_state.dart';

OnboardingPersonalDetailsState onboardingPersonDetailsReducer(OnboardingPersonalDetailsState state, dynamic action) {
  if (action is OnboardingPersonalDetailsLoadingEventAction) {
    return OnboardingPersonalDetailsLoadingState();
  } else if (action is OnboardingPersonalDetailsAddressSuggestionsFetchedEventAction) {
    return OnboardingPersonalDetailsSuggestionsFetchedState(action.suggestions);
  } else if (action is OnboardingPersonalDetailFetchingAddressSuggestionsFailedEventAction) {
    return OnboardingPersonalDetailsErrorState();
  } else if (action is OnboardingPersonalDetailsAddressSuggestionSelectedEventAction) {
    return OnboardingPersonalDetailsAddressSuggestionSelectedState(action.selectedSuggestion);
  }
  return state;
}
