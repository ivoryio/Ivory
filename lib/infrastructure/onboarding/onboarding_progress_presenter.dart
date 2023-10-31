import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/onboarding/onboarding_progress_state.dart';
import 'package:solarisdemo/screens/onboarding/personal_details/onboarding_date_and_place_of_birth_screen.dart';
import 'package:solarisdemo/screens/onboarding/signup/onboarding_basic_info_screen.dart';

import '../../models/onboarding/onboarding_progress.dart';

enum StepperItemType { signUp, personalDetails, financialDetails, identityVerification, cardConfiguration }

class OnboardingProgressPresenter {
  static OnboardingProgressViewModel presentOnboardingProgress({
    required OnboardingProgressState onboardingProgressState,
  }) {
    if (onboardingProgressState is OnboardingProgressFetchedState) {
      return OnboardingProgressFetchedViewModel(
        progress: _onboardingProgressMapper(onboardingProgressState.step),
      );
    } else if (onboardingProgressState is OnboardingProgressErrorState) {
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
  switch (step) {
    case OnboardingStep.start:
      return const OnboardingProgress(
        activeStep: StepperItemType.signUp,
        progressPercentage: 1,
        routeName: OnboardingBasicInfoScreen.routeName,
      );
    case OnboardingStep.signUp:
      return const OnboardingProgress(
        activeStep: StepperItemType.personalDetails,
        progressPercentage: 20,
        routeName: OnboardingDateAndPlaceOfBirthScreen.routeName,
      );
    default:
      return const OnboardingProgress(
        activeStep: StepperItemType.signUp,
        progressPercentage: 1,
        routeName: OnboardingBasicInfoScreen.routeName,
      );
  }
}
