import 'package:redux/redux.dart';

import '../../../redux/app_state.dart';
import '../../../redux/auth/auth_state.dart';
import '../../../redux/onboarding/card_configuration/onboarding_card_configuration_action.dart';
import '../../repayments/change_repayment/change_repayment_service.dart';
import 'onboarding_card_configuration_service.dart';

class OnboardingCardConfigurationMiddleware extends  MiddlewareClass<AppState> {
  final OnboardingCardConfigurationService _cardConfigurationService;
  final CardApplicationService _cardApplicationService;

  OnboardingCardConfigurationMiddleware(
    this._cardConfigurationService,
    this._cardApplicationService,
  );

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final authState = store.state.authState;
    if(authState is! AuthenticationInitializedState) {
      return;
    }

    final user = authState.cognitoUser;
    
    if(action is GetCardPersonNameCommandAction) {
      final response = await _cardConfigurationService.getCardholderName(user: user);
      if(response is GetCardholderNameSuccessResponse) {
        store.dispatch(WithCardholderNameEventAction(cardholderName: response.cardholderName));
      } else {
        store.dispatch(OnboardingCardConfigurationFailedEventAction());
      }
    }

    if(action is OnboardingCreateCardCommandAction) {
      store.dispatch(OnboardingCreateCardLoadingEventAction());
      final response = await _cardConfigurationService.onboardingCreateCard(user: user);
      if(response is OnboardingCardConfigurationSuccessResponse) {
        store.dispatch(OnboardingCardConfigurationGenericSuccessEventAction());
      } else {
        store.dispatch(OnboardingCardConfigurationFailedEventAction());
      }
    }

    if(action is GetOnboardingCardInfoCommandAction) {
      final response = await _cardConfigurationService.onboardingGetCardInfo(user: user);
      if(response is GetCardInfoSuccessResponse) {
        store.dispatch(
            WithCardInfoEventAction(
              cardholderName: response.cardholderName,
              maskedPAN: response.maskedPAN,
              expiryDate: response.expiryDate,
            )
        );
      } else {
        store.dispatch(OnboardingCardConfigurationFailedEventAction());
      }
    }

    if (action is OnboardingGetCreditCardApplicationCommandAction) {
      final response = await _cardApplicationService.getCardApplication(user: user);
      if (response is GetCardApplicationSuccessResponse) {
        store.dispatch(OnboardingGetCreditCardApplicationSuccessEventAction(
          creditCardApplication: response.creditCardApplication,
        ));
      } else {
        store.dispatch(OnboardingGetCreditCardApplicationFailedEventAction());
      }
    }
  }
}
