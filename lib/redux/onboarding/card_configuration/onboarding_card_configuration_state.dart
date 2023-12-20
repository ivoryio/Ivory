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
  final bool isLoading;

  WithCardInfoState({
    required this.cardholderName,
    required this.maskedPAN,
    required this.expiryDate,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [cardholderName, maskedPAN, expiryDate, isLoading];
}

class OnboardingGetCreditCardApplicationLoadingState extends OnboardingCardConfigurationState {}

class OnboardingCreditCardApplicationFetchedState extends OnboardingCardConfigurationState {
  final CreditCardApplication cardApplication;
  final bool isLoading;

  OnboardingCreditCardApplicationFetchedState({
    required this.cardApplication,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [cardApplication, isLoading];
}

class OnboardingUpdateCreditCardApplicationLoadingState extends OnboardingCardConfigurationState {}

class OnboardingCreditCardApplicationUpdatedState extends OnboardingCardConfigurationState {
  final CreditCardApplication cardApplication;

  OnboardingCreditCardApplicationUpdatedState({
    required this.cardApplication,
  });

  @override
  List<Object?> get props => [cardApplication];
}
