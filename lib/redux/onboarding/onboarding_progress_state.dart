import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_progress.dart';
import 'package:solarisdemo/models/onboarding/onboarding_service_error_type.dart';

abstract class OnboardingProgressState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingProgressInitialLoadingState extends OnboardingProgressState {}

class OnboardingProgressFetchedState extends OnboardingProgressState {
  final OnboardingStep step;

  OnboardingProgressFetchedState({required this.step});

  @override
  List<Object?> get props => [step];
}

class OnboardingProgressErrorState extends OnboardingProgressState {
  final OnboardingServiceErrorType errorType;

  OnboardingProgressErrorState({this.errorType = OnboardingServiceErrorType.unknown});

  @override
  List<Object?> get props => [errorType];
}
