import 'onboarding_card_configuration_action.dart';
import 'onboarding_card_configuration_state.dart';

OnboardingCardConfigurationState onboardingCardConfigurationReducer(
    OnboardingCardConfigurationState currentState,
    dynamic action ){
  if(action is OnboardingCardLoadingEventAction) {
    return OnboardingCardConfigurationLoadingState();
  } else if (action is OnboardingCardConfigurationFailedEventAction) {
    return OnboardingCardConfigurationGenericErrorState();
  } else if (action is WithCardholderNameEventAction) {
    return WithCardholderNameState(cardholderName: action.cardholderName);
  }
  return currentState;
}