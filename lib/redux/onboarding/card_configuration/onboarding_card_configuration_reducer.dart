import 'onboarding_card_configuration_action.dart';
import 'onboarding_card_configuration_state.dart';

OnboardingCardConfigurationState onboardingCardConfigurationReducer(
    OnboardingCardConfigurationState currentState,
    dynamic action ) {
  if(action is OnboardingCreateCardLoadingEventAction && currentState is WithCardholderNameState) {
    return WithCardholderNameState(
      cardholderName: currentState.cardholderName,
      isLoading: true,
    );
  } else if (action is OnboardingCardConfigurationFailedEventAction) {
    return OnboardingCardConfigurationGenericErrorState();
  } else if (action is OnboardingCardConfigurationGenericSuccessEventAction) {
    return OnboardingCardConfigurationGenericSuccessState();
  } else if (action is WithCardholderNameEventAction) {
    return WithCardholderNameState(
      cardholderName: action.cardholderName,
    );
  } else if (action is WithCardInfoEventAction) {
    return WithCardInfoState(
        cardholderName: action.cardholderName,
        maskedPAN: action.maskedPAN,
        expiryDate: action.expiryDate,
    );
  } else if (action is OnboardingGetCreditCardApplicationSuccessEventAction) {
    return OnboardingCreditCardApplicationFetchedState(
      cardApplication: action.creditCardApplication,
    );
  } else if (action is OnboardingGetCreditCardApplicationLoadingEventAction && currentState is WithCardInfoState) {
    return WithCardInfoState(
      cardholderName: currentState.cardholderName,
      maskedPAN: currentState.maskedPAN,
      expiryDate: currentState.expiryDate,
      isLoading: true,
    );
  } else if (action is OnboardingUpdateCreditCardApplicationLoadingEventAction && currentState is OnboardingCreditCardApplicationFetchedState) {
    return OnboardingCreditCardApplicationFetchedState(
      cardApplication: currentState.cardApplication,
      isLoading: true,
    );
  } else if (action is OnboardingUpdateCreditCardApplicationSuccessEventAction) {
    return OnboardingCreditCardApplicationUpdatedState(
      cardApplication: action.creditCardApplication,
    );
  }
  return currentState;
}