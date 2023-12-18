import 'package:equatable/equatable.dart';

import '../../../models/transfer/credit_card_application.dart';

abstract class OnboardingCardConfigurationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingCardConfigurationInitialState extends OnboardingCardConfigurationState {}
class OnboardingCardConfigurationGenericErrorState extends OnboardingCardConfigurationState {}
class OnboardingCardConfigurationGenericSuccessState extends OnboardingCardConfigurationState {}

class WithCardholderNameState extends OnboardingCardConfigurationState {
  final String cardholderName;
  final bool isLoading;

  WithCardholderNameState({
    required this.cardholderName,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [cardholderName, isLoading];
}

class WithCardInfoState extends OnboardingCardConfigurationState {
  final String cardholderName;
  final String maskedPAN;
  final String expiryDate;

  WithCardInfoState({
    required this.cardholderName,
    required this.maskedPAN,
    required this.expiryDate,
  });

  @override
  List<Object?> get props => [cardholderName, maskedPAN, expiryDate];
}

class WithCardApplicationState extends OnboardingCardConfigurationState {
  final CreditCardApplication cardApplication;

  WithCardApplicationState({
    required this.cardApplication,
  });

  @override
  List<Object?> get props => [cardApplication];
}
