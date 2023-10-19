import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_action.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_state.dart';

import '../../../setup/create_app_state.dart';
import '../../../setup/create_store.dart';

void main() {
  test("When the user submits the basic info, the state should be updated", () async {
    //given
    final store = createTestStore(
      initialState: createAppState(
        onboardingSignupState: OnboardingSignupInitialState(),
      ),
    );
    final appState =
        store.onChange.firstWhere((state) => state.onboardingSignupState is OnboardingSignupSubmittedState);

    //when
    store.dispatch(const SubmitOnboardingBasicInfoCommandAction(
      title: "title",
      firstName: "firstName",
      lastName: "lastName",
    ));

    //then
    expect((await appState).onboardingSignupState, isA<OnboardingSignupSubmittedState>());
  });

  test('when the user submit email address, the state should be updated', () async {
    //given
    final store = createTestStore(
      initialState: createAppState(
        onboardingSignupState: OnboardingSignupSubmittedState(
          title: "title",
          firstName: "firstName",
          lastName: "lastName",
        ),
      ),
    );
    final appState =
        store.onChange.firstWhere((state) => state.onboardingSignupState is OnboardingSignupSubmittedState);

    //when
    store.dispatch(SubmitOnboardingEmailCommandAction(email: "email"));

    //then
    expect((await appState).onboardingSignupState, isA<OnboardingSignupSubmittedState>());
  });

  test("when the user submit email address and the state is not OnboardingSignupSubmittedState", () async {
    //given
    final store = createTestStore(
      initialState: createAppState(
        onboardingSignupState: OnboardingSignupInitialState(),
      ),
    );
    final appState = store.onChange.firstWhere((state) => state.onboardingSignupState is OnboardingSignupInitialState);

    //when
    store.dispatch(SubmitOnboardingEmailCommandAction(email: "email"));

    //then
    expect((await appState).onboardingSignupState, isA<OnboardingSignupInitialState>());
  });

  test('when the user submit password, the state should be updated', () async {
    //given
    final store = createTestStore(
      initialState: createAppState(
        onboardingSignupState: OnboardingSignupSubmittedState(
          title: "title",
          firstName: "firstName",
          lastName: "lastName",
          email: "email@example.com",
        ),
      ),
    );
    final appState =
        store.onChange.firstWhere((state) => state.onboardingSignupState is OnboardingSignupSubmittedState);

    //when
    store.dispatch(SubmitOnboardingPasswordCommandAction(password: "password"));

    //then
    expect((await appState).onboardingSignupState, isA<OnboardingSignupSubmittedState>());
  });

  test("when the user submit password and the state is not OnboardingSignupSubmittedState", () async {
    //given
    final store = createTestStore(
      initialState: createAppState(
        onboardingSignupState: OnboardingSignupInitialState(),
      ),
    );
    final appState = store.onChange.firstWhere((state) => state.onboardingSignupState is OnboardingSignupInitialState);

    //when
    store.dispatch(SubmitOnboardingPasswordCommandAction(password: "password"));

    //then
    expect((await appState).onboardingSignupState, isA<OnboardingSignupInitialState>());
  });
}
