import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identity_verification_error_type.dart';

class OnboardingIdentityVerificationState extends Equatable {
  final String? urlForIntegration;
  final bool isLoading;
  final OnboardingIdentityVerificationErrorType? errorType;

  const OnboardingIdentityVerificationState({
    this.urlForIntegration,
    this.isLoading = false,
    this.errorType,
  });

  @override
  List<Object?> get props => [urlForIntegration, isLoading, errorType];
}
