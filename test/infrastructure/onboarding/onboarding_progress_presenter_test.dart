import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/onboarding/onboarding_progress_presenter.dart';
import 'package:solarisdemo/models/onboarding/onboarding_progress.dart';
import 'package:solarisdemo/redux/onboarding/onboarding_progress_state.dart';
import 'package:solarisdemo/screens/onboarding/signup/onboarding_basic_info_screen.dart';

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

  test("When onboarding step is <start> it should return the correct OnboardingProgress", () {
    // given
    final onboardingProgressState = OnboardingProgressFetchedState(step: OnboardingStep.start);

    // when
    final viewModel = OnboardingProgressPresenter.presentOnboardingProgress(
      onboardingProgressState: onboardingProgressState,
    );

    // then
    const progress = OnboardingProgress(
      activeStep: StepperItemType.signUp,
      progressPercentage: 1,
      routeName: OnboardingBasicInfoScreen.routeName,
    );

    expect(
      viewModel,
      OnboardingProgressFetchedViewModel(progress: progress),
    );
  });
}
