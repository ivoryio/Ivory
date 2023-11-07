import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/onboarding/financial_details/onboarding_financial_details_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/onboarding/financial_details/onboarding_financial_details_action.dart';

class OnboardingFinancialDetailsMiddleware extends MiddlewareClass<AppState> {
  final OnboardingFinancialDetailsService _onboardingFinancialDetailsService;

  OnboardingFinancialDetailsMiddleware(this._onboardingFinancialDetailsService);

  @override
  call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);

    if (action is SubmitOnboardingTaxIdCommandAction) {
      // final user = (store.state.authState as AuthenticationInitializedState).cognitoUser;

      // await _onboardingFinancialDetailsService.createTaxIdentification(taxId: action.taxId, user: user);

      store.dispatch(UpdateTaxIdSuccessEventAction());
    } else {
      store.dispatch(UpdateTaxIdFailedEventAction());
    }
  }
}
