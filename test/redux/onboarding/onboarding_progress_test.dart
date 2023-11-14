import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/models/auth/auth_type.dart';
import 'package:solarisdemo/models/onboarding/onboarding_personal_details_attributes.dart';
import 'package:solarisdemo/models/onboarding/onboarding_progress.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/onboarding/onboarding_progress_action.dart';
import 'package:solarisdemo/redux/onboarding/onboarding_progress_state.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_state.dart';

import '../../infrastructure/repayments/more_credit/more_credit_presenter_test.dart';
import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import 'onboarding_progress_mocks.dart';

void main() {
  final user = MockUser();
  final authentionInitializedState = AuthenticationInitializedState(user, AuthType.withTan);

  test("When fetching onboarding progress and authState is initial, step will be <start>", () async {
    // given
    final store = createTestStore(
      onboardingService: FakeOnboardingService(),
      initialState: createAppState(
        authState: AuthInitialState(),
        onboardingProgressState: OnboardingProgressInitialLoadingState(),
      ),
    );

    final appState =
        store.onChange.firstWhere((element) => element.onboardingProgressState is OnboardingProgressFetchedState);

    // when
    store.dispatch(GetOnboardingProgressCommandAction());

    // then
    expect((await appState).onboardingProgressState, isA<OnboardingProgressFetchedState>());
    final onboardingProgressState = (await appState).onboardingProgressState as OnboardingProgressFetchedState;

    expect(onboardingProgressState.step, OnboardingStep.start);
  });

  test("When onboarding progress is fetched successfully, the state should be loaded", () async {
    // given
    final store = createTestStore(
      onboardingService: FakeOnboardingService(),
      initialState: createAppState(
        authState: authentionInitializedState,
        onboardingProgressState: OnboardingProgressInitialLoadingState(),
      ),
    );

    final appState =
        store.onChange.firstWhere((element) => element.onboardingProgressState is OnboardingProgressFetchedState);

    // when
    store.dispatch(GetOnboardingProgressCommandAction());

    // then
    expect((await appState).onboardingProgressState, isA<OnboardingProgressFetchedState>());
  });

  test("When fetching the progress, the state should change to loading", () async {
    // given
    final store = createTestStore(
      onboardingService: FakeOnboardingService(),
      initialState: createAppState(
        authState: authentionInitializedState,
        onboardingProgressState: OnboardingProgressFetchedState(step: OnboardingStep.start),
      ),
    );

    final appState = store.onChange
        .firstWhere((element) => element.onboardingProgressState is OnboardingProgressInitialLoadingState);

    // when
    store.dispatch(GetOnboardingProgressCommandAction());

    // then
    expect((await appState).onboardingProgressState, isA<OnboardingProgressInitialLoadingState>());
  });

  test("When onboarding progress has failed fetching the state should change to error", () async {
    // given
    final store = createTestStore(
      onboardingService: FakeFailingOnboardingService(),
      initialState: createAppState(
        authState: authentionInitializedState,
        onboardingProgressState: OnboardingProgressInitialLoadingState(),
      ),
    );

    final appState =
        store.onChange.firstWhere((element) => element.onboardingProgressState is OnboardingProgressErrorState);

    // when
    store.dispatch(GetOnboardingProgressCommandAction());

    // then
    expect((await appState).onboardingProgressState, isA<OnboardingProgressErrorState>());
  });

  test(
      "When onboarding progress contains a not empty mobileNumber, OnboardingPersonalDetailsState should update with that mobileNumber.",
      () async {
    // given
    final store = createTestStore(
      onboardingService: FakeOnboardingServiceWithMobileNumber(),
      initialState: createAppState(
        authState: authentionInitializedState,
        onboardingProgressState: OnboardingProgressFetchedState(step: OnboardingStep.phoneNumberVerified),
        onboardingPersonalDetailsState: const OnboardingPersonalDetailsState(
          attributes: OnboardingPersonalDetailsAttributes(mobileNumber: ''),
        ),
      ),
    );

    final appState = store.onChange
        .firstWhere((element) => element.onboardingPersonalDetailsState.attributes.mobileNumber!.isNotEmpty);

    // when
    store.dispatch(GetOnboardingProgressCommandAction());

    // then
    expect((await appState).onboardingPersonalDetailsState.attributes.mobileNumber, '123456');
  });
}
