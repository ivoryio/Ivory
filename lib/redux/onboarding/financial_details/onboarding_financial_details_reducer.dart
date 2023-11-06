import 'package:solarisdemo/redux/onboarding/financial_details/onboarding_financial_details_action.dart';
import 'package:solarisdemo/redux/onboarding/financial_details/onboarding_financial_details_state.dart';

OnboardingFinancialDetailsState onboardingFinancialDetailsReducer(
    OnboardingFinancialDetailsState state, dynamic action) {
  if (action is SubmitOnboardingTaxIdCommandAction) {
    return OnboardingFinancialDetailsState(taxId: action.taxId);
  }

  return state;
}
