import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:solarisdemo/models/onboarding/onboarding_financial_details_attributes.dart';
import 'package:solarisdemo/models/onboarding/onboarding_financial_details_error_type.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

class OnboardingFinancialDetailsService extends ApiService {
  OnboardingFinancialDetailsService({super.user});

  Future<FinancialDetailsServiceResponse> createTaxIdentification({
    required User user,
    required String taxId,
  }) async {
    this.user = user;

    const path = '/person/tax_identification';
    Map<String, dynamic> body = {
      'number': taxId,
      'country': 'DE',
      'primary': true,
    };

    try {
      await post(path, body: body);

      return CreateTaxIdSuccesResponse();
    } catch (e) {
      return const CreateTaxIdErrorResponse(errorType: FinancialDetailsErrorType.taxIdNotValid);
    }
  }

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
    this.user = user;

    try {
      final formattedDateOfEmployment = dateOfEmployment.isNotEmpty
          ? DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(dateOfEmployment))
          : '';

      await post(
        '/person/credit_card_application',
        body: {
          'maritalStatus': getOnboardingMaritalStatusValue(maritalStatus),
          'livingSituation': getOnboardingLivingSituationValue(livingSituation),
          'numberOfDependents': numberOfDependents,
          'employmentStatus': getOnboardingOccupationalStatusValue(occupationalStatus),
          'currentEmploymentStartDate': formattedDateOfEmployment,
          'monthlyIncome': monthlyIncome,
          'monthlyExpenses': monthlyExpense,
          'totalCurrentDebt': totalCurrentDebt,
          'totalCreditLimit': totalCreditLimit,
        },
      );

      return CreateCreditCardApplicationSuccesResponse();
    } catch (e) {
      return const CreateCreditCardApplicationErrorResponse(
        errorType: FinancialDetailsErrorType.cantCreateCreditCardApplication,
      );
    }
  }
}

abstract class FinancialDetailsServiceResponse extends Equatable {
  const FinancialDetailsServiceResponse();

  @override
  List<Object?> get props => [];
}

class CreateTaxIdSuccesResponse extends FinancialDetailsServiceResponse {}

class CreateTaxIdErrorResponse extends FinancialDetailsServiceResponse {
  final FinancialDetailsErrorType errorType;

  const CreateTaxIdErrorResponse({this.errorType = FinancialDetailsErrorType.taxIdNotValid});

  @override
  List<Object?> get props => [errorType];
}

class CreateCreditCardApplicationSuccesResponse extends FinancialDetailsServiceResponse {}

class CreateCreditCardApplicationErrorResponse extends FinancialDetailsServiceResponse {
  final FinancialDetailsErrorType errorType;

  const CreateCreditCardApplicationErrorResponse(
      {this.errorType = FinancialDetailsErrorType.cantCreateCreditCardApplication});

  @override
  List<Object?> get props => [errorType];
}
