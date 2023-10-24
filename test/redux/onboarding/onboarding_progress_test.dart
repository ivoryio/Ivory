import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/models/auth/auth_type.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/onboarding/onboarding_progress_action.dart';
import 'package:solarisdemo/redux/onboarding/onboarding_progress_state.dart';

import '../../infrastructure/repayments/more_credit/more_credit_presenter_test.dart';
import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import 'onboarding_progress_mocks.dart';

void main() {
  final user = MockUser();
  final authentionInitializedState = AuthenticationInitializedState(user, AuthType.withTan);

  test("When fetching onboarding progress, the state should be initial loading", () async {
    // given
    final store = createTestStore(
      initialState: createAppState(
        onboardingProgressState: OnboardingProgressInitialLoadingState(),
      ),
    );

    final appState = store.onChange
        .firstWhere((element) => element.onboardingProgressState is OnboardingProgressInitialLoadingState);

    // when
    store.dispatch(GetOnboardingProgressCommandAction());

    // then
    expect((await appState).onboardingProgressState, isA<OnboardingProgressInitialLoadingState>());
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
}
