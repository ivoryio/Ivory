import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_financial_details_attributes.dart';
import 'package:solarisdemo/models/onboarding/onboarding_financial_details_error_type.dart';

class OnboardingFinancialDetailsState extends Equatable {
  final OnboardingFinancialDetailsAttributes financialDetailsAttributes;
  final bool isLoading;
  final FinancialDetailsErrorType? errorType;
  final bool isCreditCardApplicationCreated;

  const OnboardingFinancialDetailsState({
    this.financialDetailsAttributes = const OnboardingFinancialDetailsAttributes(),
    this.isLoading = false,
    this.errorType,
    this.isCreditCardApplicationCreated = false,
  });

  @override
  List<Object?> get props => [financialDetailsAttributes, isLoading, errorType, isCreditCardApplicationCreated];
}
