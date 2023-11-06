import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/onboarding/financial_details/onboarding_financial_details_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/financial_details/onboarding_financial_details_action.dart';

class OnboardingFinancialDetailsMiddleware extends MiddlewareClass<AppState> {
  final OnboardingFinancialDetailsService _onboardingFinancialDetailsService;

  OnboardingFinancialDetailsMiddleware(this._onboardingFinancialDetailsService);

  @override
  Future<void> call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);

    if (action is SubmitOnboardingTaxIdCommandAction) {
      await _onboardingFinancialDetailsService.createTaxIdentification(taxId: action.taxId);

      store.dispatch(UpdateTaxIdSuccessEventAction());
    }
  }
}
