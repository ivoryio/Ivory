import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identification_status.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identity_verification_error_type.dart';
import 'package:solarisdemo/redux/onboarding/identity_verification/onboarding_identity_verification_state.dart';

class OnboardingIdentityVerificationPresenter {
  static OnboardingIdentityVerificationViewModel present({
    required OnboardingIdentityVerificationState identityVerificationState,
  }) {
    return OnboardingIdentityVerificationViewModel(
      urlForIntegration: identityVerificationState.urlForIntegration,
      isLoading: identityVerificationState.isLoading,
      errorType: identityVerificationState.errorType,
      identificationStatus: identityVerificationState.status,
      isAuthorized: identityVerificationState.isAuthorized,
    );
  }
}

class OnboardingIdentityVerificationViewModel extends Equatable {
  final String? urlForIntegration;
  final bool isLoading;
  final OnboardingIdentityVerificationErrorType? errorType;
  final OnboardingIdentificationStatus? identificationStatus;
  final bool? isAuthorized;

  const OnboardingIdentityVerificationViewModel({
    this.urlForIntegration,
    this.isLoading = false,
    this.errorType,
    this.identificationStatus,
    this.isAuthorized,
  });

  @override
  List<Object?> get props => [urlForIntegration, isLoading, errorType, identificationStatus, isAuthorized];
}
