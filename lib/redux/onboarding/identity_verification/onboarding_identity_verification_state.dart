import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identity_verification_error_type.dart';

class OnboardingIdentityVerificationState extends Equatable {
  final String? urlForIntegration;
  final bool isLoading;
  final OnboardingIdentityVerificationErrorType? errorType;
  final bool? isTanSent;

  const OnboardingIdentityVerificationState({
    this.urlForIntegration,
    this.isLoading = false,
    this.errorType,
    this.isTanSent,
  });

  @override
  List<Object?> get props => [urlForIntegration, isLoading, errorType, isTanSent];
}

// abstract class OnboardingSignWithTanState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class OnboardingSignWithTanInitialState extends OnboardingSignWithTanState {}

// class OnboardingSignWithTanLoadingState extends OnboardingSignWithTanState {}

// class OnboardingSignWithTanErrorState extends OnboardingSignWithTanState {}

// class OnboardingSignWithTanFetchedState extends OnboardingSignWithTanState {}
