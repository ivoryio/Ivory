import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/onboarding/onboarding_progress_state.dart';
import 'package:solarisdemo/screens/onboarding/card_configuration/onboarding_order_card.dart';
import 'package:solarisdemo/screens/onboarding/financial_details/onboarding_public_status_screen.dart';
import 'package:solarisdemo/screens/onboarding/financial_details/onboarding_remember_screen.dart';
import 'package:solarisdemo/screens/onboarding/identity_verification/onboarding_credit_limit_congratulations_screen.dart';
import 'package:solarisdemo/screens/onboarding/identity_verification/onboarding_identity_verification_method_screen.dart';
import 'package:solarisdemo/screens/onboarding/identity_verification/onboarding_reference_account_iban.dart';
import 'package:solarisdemo/screens/onboarding/identity_verification/onboarding_scoring_waiting_screen.dart';
import 'package:solarisdemo/screens/onboarding/personal_details/onboarding_date_and_place_of_birth_screen.dart';
import 'package:solarisdemo/screens/onboarding/personal_details/onboarding_mobile_number_screen.dart';
import 'package:solarisdemo/screens/onboarding/personal_details/onboarding_verify_mobile_number_screen.dart';
import 'package:solarisdemo/screens/onboarding/signup/onboarding_basic_info_screen.dart';

import '../../models/onboarding/onboarding_progress.dart';

enum StepperItemType { signUp, personalDetails, financialDetails, identityVerification, cardConfiguration, unknown }

class OnboardingProgressPresenter {
  static OnboardingProgressViewModel presentOnboardingProgress({
    required OnboardingProgressState onboardingProgressState,
    AuthState? authState,
  }) {
    if (onboardingProgressState is OnboardingProgressFetchedState) {
      if (onboardingProgressState.step == OnboardingStep.scoringSuccessful) {
        return RedirectToScoringSuccessViewModel();
      } else if (onboardingProgressState.step == OnboardingStep.scoringFailed) {
        return RedirectToScoringFailedViewModel();
      }
      return OnboardingProgressFetchedViewModel(
        progress: _onboardingProgressMapper(onboardingProgressState.step),
      );
    } else if (onboardingProgressState is OnboardingFinalizedState && authState is AuthenticatedState) {
      return RedirectToHomeViewModel();
    } else if (onboardingProgressState is OnboardingProgressErrorState || authState is AuthErrorState) {
      return OnboardingProgressErrorViewModel();
    }

    return OnboardingProgressLoadingViewModel();
  }
}

abstract class OnboardingProgressViewModel extends Equatable {
  @override
  List<Object> get props => [];
}

class OnboardingProgressLoadingViewModel extends OnboardingProgressViewModel {}

class OnboardingProgressFetchedViewModel extends OnboardingProgressViewModel {
  final OnboardingProgress progress;

  OnboardingProgressFetchedViewModel({required this.progress});

  @override
  List<Object> get props => [progress];
}

class RedirectToScoringSuccessViewModel extends OnboardingProgressViewModel {}

class RedirectToScoringFailedViewModel extends OnboardingProgressViewModel {}

class RedirectToHomeViewModel extends OnboardingProgressViewModel {}

class OnboardingProgressErrorViewModel extends OnboardingProgressViewModel {}

class OnboardingProgress extends Equatable {
  final StepperItemType activeStep;
  final int progressPercentage;
  final String routeName;

  const OnboardingProgress({
    required this.activeStep,
    required this.progressPercentage,
    required this.routeName,
  });

  @override
  List<Object> get props => [activeStep, progressPercentage, routeName];
}

OnboardingProgress _onboardingProgressMapper(OnboardingStep step) {
  const unknownProgress = OnboardingProgress(
    activeStep: StepperItemType.unknown,
    progressPercentage: 0,
    routeName: OnboardingBasicInfoScreen.routeName,
  );

  final Map<OnboardingStep, OnboardingProgress> map = {
    OnboardingStep.start: const OnboardingProgress(
      activeStep: StepperItemType.signUp,
      progressPercentage: 1,
      routeName: OnboardingBasicInfoScreen.routeName,
    ),
    OnboardingStep.signedUp: const OnboardingProgress(
      activeStep: StepperItemType.personalDetails,
      progressPercentage: 20,
      routeName: OnboardingDateAndPlaceOfBirthScreen.routeName,
    ),
    OnboardingStep.personCreated: const OnboardingProgress(
      activeStep: StepperItemType.personalDetails,
      progressPercentage: 20,
      routeName: OnboardingMobileNumberScreen.routeName,
    ),
    OnboardingStep.phoneNumberVerified: const OnboardingProgress(
      activeStep: StepperItemType.personalDetails,
      progressPercentage: 20,
      routeName: OnboardingVerifyMobileNumberScreen.routeName,
    ),
    OnboardingStep.phoneNumberConfirmed: const OnboardingProgress(
      activeStep: StepperItemType.financialDetails,
      progressPercentage: 40,
      routeName: OnboardingRememberScreen.routeName,
    ),
    OnboardingStep.taxIdAdded: const OnboardingProgress(
      activeStep: StepperItemType.financialDetails,
      progressPercentage: 40,
      routeName: OnboardingPublicStatusScreen.routeName,
    ),
    OnboardingStep.creditCardApplicationCreated: const OnboardingProgress(
      activeStep: StepperItemType.identityVerification,
      progressPercentage: 60,
      routeName: OnboardingIdentityVerificationMethodScreen.routeName,
    ),
    OnboardingStep.postboxItemsConfirmed: const OnboardingProgress(
      activeStep: StepperItemType.identityVerification,
      progressPercentage: 60,
      routeName: OnboardingReferenceAccountIbanScreen.routeName,
    ),
    OnboardingStep.identificationContractsSigned: const OnboardingProgress(
      activeStep: StepperItemType.identityVerification,
      progressPercentage: 60,
      routeName: OnboardingScoringWaitingScreen.routeName,
    ),
    OnboardingStep.scoringSuccessful: const OnboardingProgress(
      activeStep: StepperItemType.identityVerification,
      progressPercentage: 60,
      routeName: OnboardingCreditLimitCongratulationsScreen.routeName,
    ),
    OnboardingStep.scoringFailed: const OnboardingProgress(
      activeStep: StepperItemType.identityVerification,
      progressPercentage: 60,
      routeName: OnboardingScoringWaitingScreen.routeName,
    ),
    OnboardingStep.identificationFinished: const OnboardingProgress(
      activeStep: StepperItemType.cardConfiguration,
      progressPercentage: 80,
      routeName: OnboardingOrderCardScreen.routeName,
    ),
  };

  return map[step] ?? unknownProgress;
}
