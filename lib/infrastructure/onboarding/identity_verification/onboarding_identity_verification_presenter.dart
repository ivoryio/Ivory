import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identification_status.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identity_verification_error_type.dart';
import 'package:solarisdemo/redux/notification/notification_state.dart';
import 'package:solarisdemo/redux/onboarding/identity_verification/onboarding_identity_verification_state.dart';

class OnboardingIdentityVerificationPresenter {
  static OnboardingIdentityVerificationViewModel present({
    required OnboardingIdentityVerificationState identityVerificationState,
    NotificationState? notificationState,
  }) {
    return OnboardingIdentityVerificationViewModel(
      urlForIntegration: identityVerificationState.urlForIntegration,
      isLoading: identityVerificationState.isLoading,
      errorType: identityVerificationState.errorType,
      identificationStatus: identityVerificationState.status,
      isAuthorized: identityVerificationState.isAuthorized,
      isTanConfirmed: identityVerificationState.isTanConfirmed,
      creditLimit: identityVerificationState.creditLimit,
      isScoringSuccessful: getScoringSuccessState(notificationState),
    );
  }

  static bool? getScoringSuccessState(NotificationState? notificationState) {
    if (notificationState is NotificationScoringSuccessfulState) {
      return true;
    } else if (notificationState is NotificationScoringFailedState) {
      return false;
    }

    return null;
  }
}

class OnboardingIdentityVerificationViewModel extends Equatable {
  final String? urlForIntegration;
  final bool isLoading;
  final OnboardingIdentityVerificationErrorType? errorType;
  final OnboardingIdentificationStatus? identificationStatus;
  final bool? isAuthorized;
  final bool? isTanConfirmed;
  final int? creditLimit;
  final bool? isScoringSuccessful;

  const OnboardingIdentityVerificationViewModel({
    this.urlForIntegration,
    this.isLoading = false,
    this.errorType,
    this.identificationStatus,
    this.isAuthorized,
    this.isTanConfirmed,
    this.creditLimit,
    this.isScoringSuccessful,
  });

  @override
  List<Object?> get props => [
        urlForIntegration,
        isLoading,
        errorType,
        identificationStatus,
        isAuthorized,
        isTanConfirmed,
        creditLimit,
        isScoringSuccessful
      ];
}
