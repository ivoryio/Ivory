import 'package:equatable/equatable.dart';

class OnboardingFinancialDetailsState extends Equatable {
  final String taxId;

  OnboardingFinancialDetailsState({
    this.taxId = '',
  });

  @override
  List<Object?> get props => [taxId];
}
