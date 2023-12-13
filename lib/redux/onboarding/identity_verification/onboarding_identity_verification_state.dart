import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identification_status.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identity_verification_error_type.dart';

class OnboardingIdentityVerificationState extends Equatable {
  final String? urlForIntegration;
  final bool isLoading;
  final OnboardingIdentificationStatus? status;
  final OnboardingIdentityVerificationErrorType? errorType;
  final bool? isTanConfirmed;
  final bool? isAuthorized;
  final int? creditLimit;
  final bool? isIdentificationSuccessful;

  const OnboardingIdentityVerificationState({
    this.urlForIntegration,
    this.isLoading = false,
    this.status,
    this.isAuthorized,
    this.errorType,
    this.isTanConfirmed,
    this.creditLimit,
    this.isIdentificationSuccessful,
  });

  @override
  List<Object?> get props => [
        urlForIntegration,
        isLoading,
        errorType,
        status,
        isAuthorized,
        isTanConfirmed,
        creditLimit,
        isIdentificationSuccessful,
      ];
}
