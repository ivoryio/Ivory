import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_action.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_state.dart';

OnboardingPersonalDetailsState onboardingPersonDetailsReducer(OnboardingPersonalDetailsState state, dynamic action) {
  if (action is SubmitOnboardingBirthInfoCommandAction) {
    return OnboardingPersonalDetailsState(
      attributes: state.attributes.copyWith(
        birthDate: action.birthDate,
        country: action.country,
        city: action.city,
        nationality: action.nationality,
      ),
    );
  } else if (action is SelectOnboardingAddressSuggestionCommandAction) {
    return OnboardingPersonalDetailsState(
      attributes: state.attributes.copyWith(selectedAddress: action.suggestion),
    );
  } else if (action is OnboardingPersonalDetailsLoadingEventAction) {
    return OnboardingPersonalDetailsState(
      attributes: state.attributes,
      isLoading: true,
    );
  } else if (action is CreatePersonSuccessEventAction) {
    return OnboardingPersonalDetailsState(
      attributes: state.attributes,
      isAddressSaved: true,
      isLoading: false,
    );
  } else if (action is CreatePersonFailedEventAction) {
    return OnboardingPersonalDetailsState(
      attributes: state.attributes,
      isAddressSaved: false,
      isLoading: false,
      errorType: action.errorType,
    );
  }

  return state;
}
