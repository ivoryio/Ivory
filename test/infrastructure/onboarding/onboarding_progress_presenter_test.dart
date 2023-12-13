import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/onboarding/onboarding_progress_presenter.dart';
import 'package:solarisdemo/models/auth/auth_error_type.dart';
import 'package:solarisdemo/models/onboarding/onboarding_progress.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/onboarding/onboarding_progress_state.dart';
import 'package:solarisdemo/screens/onboarding/identity_verification/onboarding_scoring_waiting_screen.dart';
import 'package:solarisdemo/screens/onboarding/personal_details/onboarding_date_and_place_of_birth_screen.dart';
import 'package:solarisdemo/screens/onboarding/signup/onboarding_basic_info_screen.dart';

import '../../setup/authentication_helper.dart';

void main() {
  test("When fetching is in initial loading it should return loading", () {
    //given
    final onboardingProgressState = OnboardingProgressInitialLoadingState();

    //when
    final viewModel = OnboardingProgressPresenter.presentOnboardingProgress(
      onboardingProgressState: onboardingProgressState,
    );

    //then
    expect(viewModel, OnboardingProgressLoadingViewModel());
  });

  test("When progress is not fetched it should return error", () {
    // given
    final onboardingProgressState = OnboardingProgressErrorState();

    // when
    final viewModel = OnboardingProgressPresenter.presentOnboardingProgress(
      onboardingProgressState: onboardingProgressState,
    );

    // then
    expect(viewModel, OnboardingProgressErrorViewModel());
  });

  test("When onboarding step is unknown it should return the correct OnboardingProgress", () {
    // given
    final onboardingProgressState = OnboardingProgressFetchedState(step: OnboardingStep.unknown);

    // when
    final viewModel = OnboardingProgressPresenter.presentOnboardingProgress(
      onboardingProgressState: onboardingProgressState,
    );

    // then
    const progress = OnboardingProgress(
      activeStep: StepperItemType.unknown,
      progressPercentage: 0,
      routeName: OnboardingBasicInfoScreen.routeName,
    );

    expect(
      viewModel,
      OnboardingProgressFetchedViewModel(progress: progress),
    );
  });

  group("Onboarding steps", () {
    test("When onboarding step is <start> it should return the correct OnboardingProgress", () {
      // given
      final onboardingProgressState = OnboardingProgressFetchedState(step: OnboardingStep.start);

      // when
      final viewModel = OnboardingProgressPresenter.presentOnboardingProgress(
        onboardingProgressState: onboardingProgressState,
      );

      // then
      expect(
        viewModel,
        OnboardingProgressFetchedViewModel(
          progress: const OnboardingProgress(
            activeStep: StepperItemType.signUp,
            progressPercentage: 1,
            routeName: OnboardingBasicInfoScreen.routeName,
          ),
        ),
      );
    });

    test("When onboarding step is <signedUp> it should return the correct OnboardingProgress", () {
      // given
      final onboardingProgressState = OnboardingProgressFetchedState(step: OnboardingStep.signedUp);

      // when
      final viewModel = OnboardingProgressPresenter.presentOnboardingProgress(
        onboardingProgressState: onboardingProgressState,
      );

      // then
      expect(
        viewModel,
        OnboardingProgressFetchedViewModel(
          progress: const OnboardingProgress(
            activeStep: StepperItemType.personalDetails,
            progressPercentage: 20,
            routeName: OnboardingDateAndPlaceOfBirthScreen.routeName,
          ),
        ),
      );
    });

    test("When onboarding step is <scoringSuccessful> it should return the redirect view model", () {
      // given
      final onboardingProgressState = OnboardingProgressFetchedState(step: OnboardingStep.scoringSuccessful);

      // when
      final viewModel = OnboardingProgressPresenter.presentOnboardingProgress(
        onboardingProgressState: onboardingProgressState,
      );

      // then
      expect(viewModel, RedirectToScoringSuccessViewModel());
    });

    test("When onboarding step is <scoringFailed> it should return the redirect view model", () {
      // given
      final onboardingProgressState = OnboardingProgressFetchedState(step: OnboardingStep.scoringFailed);

      // when
      final viewModel = OnboardingProgressPresenter.presentOnboardingProgress(
        onboardingProgressState: onboardingProgressState,
      );

      // then
      expect(viewModel, RedirectToScoringFailedViewModel());
    });

    test("When onboarding step is <identificationContractsSigned> it should return the correct onboarding progress",
        () {
      // given
      final onboardingProgressState =
          OnboardingProgressFetchedState(step: OnboardingStep.identificationContractsSigned);

      // when
      final viewModel = OnboardingProgressPresenter.presentOnboardingProgress(
        onboardingProgressState: onboardingProgressState,
      );

      // then
      expect(
        viewModel,
        OnboardingProgressFetchedViewModel(
          progress: const OnboardingProgress(
            activeStep: StepperItemType.identityVerification,
            progressPercentage: 60,
            routeName: OnboardingScoringWaitingScreen.routeName,
          ),
        ),
      );
    });
  });

  group("Onboarding finalize", () {
    test("When onboarding finalize is in progress it should return loading", () {
      // given
      final onboardingProgressState = OnboardingProgressInitialLoadingState();
      final authState = AuthStatePlaceholder.inOnboardingState();

      // when
      final viewModel = OnboardingProgressPresenter.presentOnboardingProgress(
        onboardingProgressState: onboardingProgressState,
        authState: authState,
      );

      // then
      expect(viewModel, OnboardingProgressLoadingViewModel());
    });

    test("When onboarding is finalized it should return redirect to home", () {
      // given
      final onboardingProgressState = OnboardingFinalizedState();
      final authState = AuthStatePlaceholder.loggedInState();

      // when
      final viewModel = OnboardingProgressPresenter.presentOnboardingProgress(
        onboardingProgressState: onboardingProgressState,
        authState: authState,
      );

      // then
      expect(viewModel, RedirectToHomeViewModel());
    });

    test("When onboarding finalize has failed it should return error", () {
      // given
      final onboardingProgressState = OnboardingProgressErrorState();
      final authState = AuthStatePlaceholder.loggedInState();

      // when
      final viewModel = OnboardingProgressPresenter.presentOnboardingProgress(
        onboardingProgressState: onboardingProgressState,
        authState: authState,
      );

      // then
      expect(viewModel, OnboardingProgressErrorViewModel());
    });

    test("When the auth state has an error it should return error", () {
      // given
      final onboardingProgressState = OnboardingProgressInitialLoadingState();
      final authState = AuthErrorState(AuthErrorType.unknown);

      // when
      final viewModel = OnboardingProgressPresenter.presentOnboardingProgress(
        onboardingProgressState: onboardingProgressState,
        authState: authState,
      );

      // then
      expect(viewModel, OnboardingProgressErrorViewModel());
    });
  });
}
