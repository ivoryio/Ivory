import 'package:equatable/equatable.dart';

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