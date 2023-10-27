import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/models/onboarding/onboarding_signup_attributes.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_action.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_state.dart';

import '../../../setup/create_app_state.dart';
import '../../../setup/create_store.dart';
import 'onboarding_singup_mocks.dart';

void main() {
  test("When the user submits the basic info, the state should be updated", () async {
    //given
    final store = createTestStore(
      initialState: createAppState(
        onboardingSignupState: OnboardingSignupState(),
      ),
    );
    final appState = store.onChange.firstWhere((state) => state.onboardingSignupState.signupAttributes.hasBasicInfo);

    //when
    store.dispatch(const SubmitOnboardingBasicInfoCommandAction(
      title: "title",
      firstName: "firstName",
      lastName: "lastName",
    ));

    //then
    final onboardingSignupSubmittedState = (await appState).onboardingSignupState;

    expect(
      onboardingSignupSubmittedState.signupAttributes,
      const OnboardingSignupAttributes(
        title: "title",
        firstName: "firstName",
        lastName: "lastName",
      ),
    );
  });

  test('when the user submit email address, the state should be updated', () async {
    //given
    final store = createTestStore(
      initialState: createAppState(
        onboardingSignupState: OnboardingSignupState(
          signupAttributes: const OnboardingSignupAttributes(
            title: "title",
            firstName: "firstName",
            lastName: "lastName",
          ),
        ),
      ),
    );
    final appState = store.onChange.firstWhere((state) => state.onboardingSignupState.signupAttributes.email != null);

    //when
    store.dispatch(const SubmitOnboardingEmailCommandAction(email: "email"));

    //then
    final onboardingSignupSubmittedState = (await appState).onboardingSignupState;

    expect(
      onboardingSignupSubmittedState.signupAttributes,
      const OnboardingSignupAttributes(
        title: "title",
        firstName: "firstName",
        lastName: "lastName",
        email: "email",
      ),
    );
  });

  test('when the user submit the password, the state should be updated', () async {
    //given
    final store = createTestStore(
      initialState: createAppState(
        onboardingSignupState: OnboardingSignupState(
          signupAttributes: const OnboardingSignupAttributes(
            title: "title",
            firstName: "firstName",
            lastName: "lastName",
            email: "email",
          ),
        ),
      ),
    );
    final appState = store.onChange.firstWhere((state) => state.onboardingSignupState.signupAttributes.email != null);

    //when
    store.dispatch(const SubmitOnboardingPasswordCommandAction(password: "password"));

    //then
    final onboardingSignupSubmittedState = (await appState).onboardingSignupState;

    expect(
      onboardingSignupSubmittedState.signupAttributes,
      const OnboardingSignupAttributes(
        title: "title",
        firstName: "firstName",
        lastName: "lastName",
        email: "email",
        password: "password",
      ),
    );
  });

  test('when the user approves the notification permission, the state should be updated', () async {
    //given
    final store = createTestStore(
      pushNotificationService: FakeNotificationService(),
      initialState: createAppState(
        onboardingSignupState: OnboardingSignupState(
          signupAttributes: const OnboardingSignupAttributes(
            title: "title",
            firstName: "firstName",
            lastName: "lastName",
            email: "email",
            password: "password",
          ),
        ),
      ),
    );
    final appState =
        store.onChange.firstWhere((state) => state.onboardingSignupState.signupAttributes.notificationsAllowed != null);

    //when
    store.dispatch(RequestPushNotificationsPermissionCommandAction());

    //then
    final onboardingSignupSubmittedState = (await appState).onboardingSignupState;

    expect(
      onboardingSignupSubmittedState.signupAttributes,
      const OnboardingSignupAttributes(
        title: "title",
        firstName: "firstName",
        lastName: "lastName",
        email: "email",
        password: "password",
        notificationsAllowed: true,
      ),
    );
  });

  test('when the user denies the notification permission, the state should be updated', () async {
    //given
    final store = createTestStore(
      pushNotificationService: FakeNotificationServiceWithNoPermission(),
      initialState: createAppState(
        onboardingSignupState: OnboardingSignupState(
          signupAttributes: const OnboardingSignupAttributes(
            title: "title",
            firstName: "firstName",
            lastName: "lastName",
            email: "email",
            password: "password",
          ),
        ),
      ),
    );
    final appState =
        store.onChange.firstWhere((state) => state.onboardingSignupState.signupAttributes.notificationsAllowed != null);

    //when
    store.dispatch(RequestPushNotificationsPermissionCommandAction());

    //then
    final onboardingSignupSubmittedState = (await appState).onboardingSignupState;

    expect(
      onboardingSignupSubmittedState.signupAttributes,
      const OnboardingSignupAttributes(
        title: "title",
        firstName: "firstName",
        lastName: "lastName",
        email: "email",
        password: "password",
        notificationsAllowed: false,
      ),
    );
  });

  test('when the user changes the notification permission from app settings, the state should be updated', () async {
    //given
    final store = createTestStore(
      pushNotificationService: FakeNotificationService(),
      initialState: createAppState(
        onboardingSignupState: OnboardingSignupState(
          signupAttributes: const OnboardingSignupAttributes(
            title: "title",
            firstName: "firstName",
            lastName: "lastName",
            email: "email",
            password: "password",
          ),
        ),
      ),
    );
    final appState =
        store.onChange.firstWhere((state) => state.onboardingSignupState.signupAttributes.notificationsAllowed != null);

    //when
    store.dispatch(CheckPushNotificationPermissionCommandAction());

    //then
    final onboardingSignupSubmittedState = (await appState).onboardingSignupState;

    expect(
      onboardingSignupSubmittedState.signupAttributes,
      const OnboardingSignupAttributes(
        title: "title",
        firstName: "firstName",
        lastName: "lastName",
        email: "email",
        password: "password",
        notificationsAllowed: true,
      ),
    );
  });
}
