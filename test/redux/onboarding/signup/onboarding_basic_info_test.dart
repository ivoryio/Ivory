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
        onboardingSignupState: OnboardingSignupSubmittedState(),
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
    final onboardingSignupSubmittedState = (await appState).onboardingSignupState;

    expect(onboardingSignupSubmittedState, isA<OnboardingSignupSubmittedState>());
    expect((onboardingSignupSubmittedState as OnboardingSignupSubmittedState).title, "title");
    expect(onboardingSignupSubmittedState.firstName, "firstName");
    expect(onboardingSignupSubmittedState.lastName, "lastName");
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
    final onboardingSignupSubmittedState = (await appState).onboardingSignupState;

    expect(onboardingSignupSubmittedState, isA<OnboardingSignupSubmittedState>());
    expect((onboardingSignupSubmittedState as OnboardingSignupSubmittedState).email, "email");
  });

  test("when the user submit email address and the state is not OnboardingSignupSubmittedState", () async {
    //given
    final store = createTestStore(
      initialState: createAppState(
        onboardingSignupState: OnboardingSignupSubmittedState(),
      ),
    );
    final appState =
        store.onChange.firstWhere((state) => state.onboardingSignupState is OnboardingSignupSubmittedState);

    //when
    store.dispatch(SubmitOnboardingEmailCommandAction(email: "email"));

    //then
    expect((await appState).onboardingSignupState, isA<OnboardingSignupSubmittedState>());
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
    final onboardingSignupSubmittedState = (await appState).onboardingSignupState;

    expect(onboardingSignupSubmittedState, isA<OnboardingSignupSubmittedState>());
    expect((onboardingSignupSubmittedState as OnboardingSignupSubmittedState).password, "password");
  });

  test("when the user submit password and the state is not OnboardingSignupSubmittedState", () async {
    //given
    final store = createTestStore(
      initialState: createAppState(
        onboardingSignupState: OnboardingSignupSubmittedState(),
      ),
    );
    final appState =
        store.onChange.firstWhere((state) => state.onboardingSignupState is OnboardingSignupSubmittedState);

    //when
    store.dispatch(SubmitOnboardingPasswordCommandAction(password: "password"));

    //then
    expect((await appState).onboardingSignupState, isA<OnboardingSignupSubmittedState>());
  });
}
