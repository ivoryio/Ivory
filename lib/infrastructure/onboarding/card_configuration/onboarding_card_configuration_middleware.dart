import 'package:redux/redux.dart';

import '../../../redux/app_state.dart';
import '../../../redux/auth/auth_state.dart';
import '../../../redux/onboarding/card_configuration/onboarding_card_configuration_action.dart';
import 'onboarding_card_configuration_service.dart';

class OnboardingCardConfigurationMiddleware extends  MiddlewareClass<AppState> {
  final OnboardingCardConfigurationService _cardConfigurationService;

  OnboardingCardConfigurationMiddleware(this._cardConfigurationService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final authState = store.state.authState;
    if(authState is! AuthenticationInitializedState) {
      return;
    }
    
    if(action is GetCardPersonNameCommandAction) {
      final response = await _cardConfigurationService.getCardholderName(user: authState.cognitoUser);
      if(response is GetCardholderNameSuccessResponse) {
        store.dispatch(WithCardholderNameEventAction(cardholderName: response.cardholderName));
      } else {
        store.dispatch(OnboardingCardConfigurationFailedEventAction());
      }
    }

    if(action is OnboardingCreateCardCommandAction) {
      store.dispatch(OnboardingCreateCardLoadingEventAction());
      final response = await _cardConfigurationService.onboardingCreateCard(user: authState.cognitoUser);
      if(response is OnboardingCardConfigurationSuccessResponse) {
        store.dispatch(OnboardingCardConfigurationGenericSuccessEventAction());
      } else {
        store.dispatch(OnboardingCardConfigurationFailedEventAction());
      }
    }
  }
}