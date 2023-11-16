import 'package:solarisdemo/models/onboarding/onboarding_financial_details_attributes.dart';
import 'package:solarisdemo/redux/onboarding/financial_details/onboarding_financial_details_action.dart';
import 'package:solarisdemo/redux/onboarding/financial_details/onboarding_financial_details_state.dart';

OnboardingFinancialDetailsState onboardingFinancialDetailsReducer(
    OnboardingFinancialDetailsState state, dynamic action) {
  if (action is CreateTaxIdLoadingEventAction) {
    return const OnboardingFinancialDetailsState(isLoading: true);
  } else if (action is CreatePublicStatusCommandAction) {
    return OnboardingFinancialDetailsState(
        isLoading: false,
        financialDetailsAttributes: OnboardingFinancialDetailsAttributes(
            maritalStatus: action.maritalAttributes,
            livingSituation: action.livingAttributes,
            numberOfDependents: action.numberOfDependents));
  } else if (action is CreateEmployedOccupationalStatusCommandAction) {
    return OnboardingFinancialDetailsState(
        isLoading: false,
        financialDetailsAttributes: OnboardingFinancialDetailsAttributes(
            occupationalStatus: action.occupationalStatus, dateOfEmployment: action.dateOfEmployment));
  } else if (action is CreateOthersOccupationalStatusCommandAction) {
    return OnboardingFinancialDetailsState(
        isLoading: false,
        financialDetailsAttributes:
            OnboardingFinancialDetailsAttributes(occupationalStatus: action.occupationalStatus, dateOfEmployment: ''));
  } else if (action is CreateTaxIdSuccessEventAction) {
    return OnboardingFinancialDetailsState(
        isLoading: false, financialDetailsAttributes: OnboardingFinancialDetailsAttributes(taxId: action.taxId));
  } else if (action is CreateTaxIdFailedEventAction) {
    return OnboardingFinancialDetailsState(isLoading: false, errorType: action.errorType);
  }

  return state;
}
