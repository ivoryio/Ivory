import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_financial_details_attributes.dart';
import 'package:solarisdemo/models/onboarding/onboarding_financial_details_error_type.dart';
import 'package:solarisdemo/redux/onboarding/financial_details/onboarding_financial_details_state.dart';

class OnboardingFinancialDetailsPresenter {
  static OnboardingFinancialDetailsViewModel present({required OnboardingFinancialDetailsState financialState}) {
    return OnboardingFinancialDetailsViewModel(
      financialDetailsAttributes: financialState.financialDetailsAttributes,
      isLoading: financialState.isLoading,
      errorType: financialState.errorType,
      isMaritalStatusSelected: financialState.isMaritalStatusSelected,
      isOccupationalStatusSelected: financialState.isOccupationalStatusSelected,
      isCreditCardApplicationCreated: financialState.isCreditCardApplicationCreated,
    );
  }
}

class OnboardingFinancialDetailsViewModel extends Equatable {
  final OnboardingFinancialDetailsAttributes financialDetailsAttributes;
  final bool isLoading;
  final FinancialDetailsErrorType? errorType;
  final bool isMaritalStatusSelected;
  final bool isOccupationalStatusSelected;
  final bool isCreditCardApplicationCreated;

  const OnboardingFinancialDetailsViewModel(
    {
    required this.financialDetailsAttributes,
    required this.isLoading,
    this.errorType,
    this.isMaritalStatusSelected = false,
    this.isOccupationalStatusSelected = false,
    this.isCreditCardApplicationCreated = false,
  });

  @override
  List<Object?> get props => [
        financialDetailsAttributes,
        isLoading,
        errorType,
        isMaritalStatusSelected,
        isOccupationalStatusSelected,
        isCreditCardApplicationCreated
      ];
}
