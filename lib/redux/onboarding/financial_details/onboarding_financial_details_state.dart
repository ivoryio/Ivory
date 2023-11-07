import 'package:equatable/equatable.dart';

class OnboardingFinancialDetailsState extends Equatable {
  final String taxId;
  final String? errorMessage;

  OnboardingFinancialDetailsState({
    this.taxId = '',
    this.errorMessage,
  });

  @override
  List<Object?> get props => [taxId];
}
