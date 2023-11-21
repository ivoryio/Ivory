import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identity_verification_error_type.dart';
import 'package:solarisdemo/redux/onboarding/identity_verification/onboarding_identity_verification_state.dart';

class OnboardingIdentityVerificationPresenter {
  static OnboardingIdentityVerificationViewModel present(
      {required OnboardingIdentityVerificationState identityVerificationState}) {
    return OnboardingIdentityVerificationViewModel(
      urlForIntegration: identityVerificationState.urlForIntegration,
      isLoading: identityVerificationState.isLoading,
      errorType: identityVerificationState.errorType,
    );
  }
}

class OnboardingIdentityVerificationViewModel extends Equatable {
  final String? urlForIntegration;
  final bool isLoading;
  final OnboardingIdentityVerificationErrorType? errorType;

  const OnboardingIdentityVerificationViewModel({this.urlForIntegration, required this.isLoading, this.errorType});

  @override
  List<Object?> get props => [urlForIntegration, isLoading, errorType];
}
