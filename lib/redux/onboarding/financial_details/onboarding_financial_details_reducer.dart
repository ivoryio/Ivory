import 'package:solarisdemo/redux/onboarding/financial_details/onboarding_financial_details_action.dart';
import 'package:solarisdemo/redux/onboarding/financial_details/onboarding_financial_details_state.dart';

OnboardingFinancialDetailsState onboardingFinancialDetailsReducer(
    OnboardingFinancialDetailsState state, dynamic action) {
  if (action is CreateTaxIdLoadingEventAction || action is CreateCreditCardApplicationLoadingEventAction) {
    return OnboardingFinancialDetailsState(
      isLoading: true,
      isCreditCardApplicationCreated: state.isCreditCardApplicationCreated,
      financialDetailsAttributes: state.financialDetailsAttributes,
    );
  } else if (action is CreatePublicStatusCommandAction) {
    return OnboardingFinancialDetailsState(
      isLoading: false,
      financialDetailsAttributes: state.financialDetailsAttributes.copyWith(
        maritalStatus: action.maritalAttributes,
        livingSituation: action.livingAttributes,
        numberOfDependents: action.numberOfDependents,
      ),
    );
  } else if (action is CreateEmployedOccupationalStatusCommandAction) {
    return OnboardingFinancialDetailsState(
      isLoading: false,
      financialDetailsAttributes: state.financialDetailsAttributes.copyWith(
        occupationalStatus: action.occupationalStatus,
        dateOfEmployment: action.dateOfEmployment,
      ),
    );
  } else if (action is CreateOthersOccupationalStatusCommandAction) {
    return OnboardingFinancialDetailsState(
      isLoading: false,
      financialDetailsAttributes: state.financialDetailsAttributes.copyWith(
        occupationalStatus: action.occupationalStatus,
        dateOfEmployment: '',
      ),
    );
  } else if (action is CreateTaxIdSuccessEventAction) {
    return OnboardingFinancialDetailsState(
      isLoading: false,
      financialDetailsAttributes: state.financialDetailsAttributes.copyWith(
        taxId: action.taxId,
      ),
    );
  } else if (action is CreateTaxIdFailedEventAction) {
    return OnboardingFinancialDetailsState(
      isLoading: false,
      errorType: action.errorType,
    );
  } else if (action is CreateCreditCardApplicationSuccessEventAction) {
    return const OnboardingFinancialDetailsState(
      isLoading: false,
      isCreditCardApplicationCreated: true,
    );
  } else if (action is CreateCreditCardApplicationFailedEventAction) {
    return OnboardingFinancialDetailsState(
      isLoading: false,
      errorType: action.errorType,
    );
  }

  return state;
}
