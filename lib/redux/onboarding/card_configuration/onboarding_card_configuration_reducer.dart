import 'onboarding_card_configuration_action.dart';
import 'onboarding_card_configuration_state.dart';

OnboardingCardConfigurationState onboardingCardConfigurationReducer(
    OnboardingCardConfigurationState currentState,
    dynamic action ) {
  if(action is OnboardingCreateCardLoadingEventAction && currentState is WithCardholderNameState) {
    return WithCardholderNameState(cardholderName: currentState.cardholderName, isLoading: true);
  } else if (action is OnboardingCardConfigurationFailedEventAction) {
    return OnboardingCardConfigurationGenericErrorState();
  } else if (action is OnboardingCardConfigurationGenericSuccessEventAction) {
    return OnboardingCardConfigurationGenericSuccessState();
  } else if (action is WithCardholderNameEventAction) {
    return WithCardholderNameState(cardholderName: action.cardholderName);
  }
  return currentState;
}