import 'package:solarisdemo/models/onboarding/onboarding_personal_details_error_type.dart';
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
  } else if (action is ResetOnboardingSelectedAddressCommandAction) {
    return OnboardingPersonalDetailsState(
      attributes: state.attributes.copyWith(useNull: true, selectedAddress: null),
    );
  } else if (action is OnboardingPersonalDetailsLoadingEventAction) {
    return OnboardingPersonalDetailsState(
      attributes: state.attributes,
      isLoading: true,
    );
  } else if (action is CreatePersonAccountSuccessEventAction) {
    return OnboardingPersonalDetailsState(
      attributes: state.attributes,
      isAddressSaved: true,
      isLoading: false,
    );
  } else if (action is CreatePersonAccountFailedEventAction) {
    return OnboardingPersonalDetailsState(
      attributes: state.attributes,
      isAddressSaved: false,
      isLoading: false,
      errorType: action.errorType,
    );
  } else if (action is MobileNumberCreatedEventAction) {
    return OnboardingPersonalDetailsState(
      attributes: state.attributes.copyWith(mobileNumber: action.mobileNumber),
      isLoading: false,
      tanRequestedAt: DateTime.now(),
    );
  } else if (action is MobileNumberConfirmedEventAction) {
    return OnboardingPersonalDetailsState(
      attributes: state.attributes,
      isLoading: false,
      isMobileConfirmed: true,
    );
  } else if (action is MobileNumberConfirmationFailedEventAction) {
    return OnboardingPersonalDetailsState(
      attributes: state.attributes,
      isLoading: false,
      isMobileConfirmed: false,
      errorType: OnboardingPersonalDetailsErrorType.invalidTan,
    );
  } else if (action is VerifyMobileNumberCommandAction) {
    return OnboardingPersonalDetailsState(
      attributes: state.attributes,
      isLoading: false,
    );
  }

  return state;
}
