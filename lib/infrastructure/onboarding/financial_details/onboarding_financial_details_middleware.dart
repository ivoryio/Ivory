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

    final authState = store.state.authState;
    if (authState is! AuthenticationInitializedState) {
      return;
    }

    if (action is CreateTaxIdCommandAction) {
      store.dispatch(CreateTaxIdLoadingEventAction());

      final response = await _onboardingFinancialDetailsService.createTaxIdentification(
        user: authState.cognitoUser,
        taxId: action.taxId,
      );

      if (response is CreateTaxIdSuccesResponse) {
        store.dispatch(CreateTaxIdSuccessEventAction(taxId: action.taxId));
      } else if (response is CreateTaxIdErrorResponse) {
        store.dispatch(CreateTaxIdFailedEventAction(errorType: response.errorType));
      }
    }

    if (action is CreateCreditCardApplicationCommandAction) {
      store.dispatch(CreateCreditCardApplicationLoadingEventAction());

      final financialDetails = store.state.onboardingFinancialDetailsState.financialDetailsAttributes;

      final response = await _onboardingFinancialDetailsService.createCreditCardApplication(
        user: authState.cognitoUser,
        maritalStatus: financialDetails.maritalStatus!,
        livingSituation: financialDetails.livingSituation!,
        numberOfDependents: financialDetails.numberOfDependents!,
        occupationalStatus: financialDetails.occupationalStatus!,
        dateOfEmployment: financialDetails.dateOfEmployment,
        monthlyIncome: action.monthlyIncome,
        monthlyExpense: action.monthlyExpense,
        totalCurrentDebt: action.totalCurrentDebt,
        totalCreditLimit: action.totalCreditLimit,
      );

      if (response is CreateCreditCardApplicationSuccesResponse) {
        store.dispatch(CreateCreditCardApplicationSuccessEventAction());
      } else if (response is CreateCreditCardApplicationErrorResponse) {
        store.dispatch(CreateCreditCardApplicationFailedEventAction(errorType: response.errorType));
      }
    }
  }
}
