import 'package:equatable/equatable.dart';

abstract class OnboardingCardConfigurationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingCardConfigurationInitialState extends OnboardingCardConfigurationState {}
class OnboardingCardConfigurationLoadingState extends OnboardingCardConfigurationState {}
class OnboardingCardConfigurationGenericErrorState extends OnboardingCardConfigurationState {}
class WithCardholderNameState extends OnboardingCardConfigurationState {
  final String cardholderName;

  WithCardholderNameState({required this.cardholderName});

  @override
  List<Object?> get props => [cardholderName];
}