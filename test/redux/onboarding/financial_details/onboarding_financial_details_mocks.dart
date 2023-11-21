import 'package:solarisdemo/infrastructure/onboarding/financial_details/onboarding_financial_details_service.dart';
import 'package:solarisdemo/models/onboarding/onboarding_financial_details_attributes.dart';
import 'package:solarisdemo/models/onboarding/onboarding_financial_details_error_type.dart';
import 'package:solarisdemo/models/user.dart';

class FakeOnbordingFinancialDetailsService extends OnboardingFinancialDetailsService {
  @override
  Future<FinancialDetailsServiceResponse> createTaxIdentification({required User user, required String taxId}) async {
    return CreateTaxIdSuccesResponse();
  }

  @override
  Future<FinancialDetailsServiceResponse> createCreditCardApplication({
    required User user,
    required OnboardingMaritalStatus maritalStatus,
    required OnboardingLivingSituation livingSituation,
    required int numberOfDependents,
    required OnboardingOccupationalStatus occupationalStatus,
    required String dateOfEmployment,
    required num monthlyIncome,
    required num monthlyExpense,
    required num totalCurrentDebt,
    required num totalCreditLimit,
  }) async {
    return CreateCreditCardApplicationSuccesResponse();
  }
}

class FakeFailingOnbordingFinancialDetailsService extends OnboardingFinancialDetailsService {
  @override
  Future<FinancialDetailsServiceResponse> createTaxIdentification({required User user, required String taxId}) async {
    return const CreateTaxIdErrorResponse(
      errorType: FinancialDetailsErrorType.taxIdNotValid,
    );
  }

  @override
  Future<FinancialDetailsServiceResponse> createCreditCardApplication({
    required User user,
    required OnboardingMaritalStatus maritalStatus,
    required OnboardingLivingSituation livingSituation,
    required int numberOfDependents,
    required OnboardingOccupationalStatus occupationalStatus,
    required String dateOfEmployment,
    required num monthlyIncome,
    required num monthlyExpense,
    required num totalCurrentDebt,
    required num totalCreditLimit,
  }) async {
    return const CreateCreditCardApplicationErrorResponse(
      errorType: FinancialDetailsErrorType.cantCreateCreditCardApplication,
    );
  }
}

