import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/models/onboarding/onboarding_signup_attributes.dart';
import 'package:solarisdemo/models/onboarding/onboarding_signup_error_type.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_action.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_state.dart';

import '../../../setup/create_app_state.dart';
import '../../../setup/create_store.dart';
import '../../auth/auth_mocks.dart';
import '../../notification/notification_mocks.dart';
import 'onboarding_singup_mocks.dart';

void main() {
  group("Basic info steps", () {
    test("When the user submits the basic info, the state should be updated", () async {
      //given
      final store = createTestStore(
        initialState: createAppState(
          onboardingSignupState: const OnboardingSignupState(),
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
          onboardingSignupState: const OnboardingSignupState(
            signupAttributes: OnboardingSignupAttributes(
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
          onboardingSignupState: const OnboardingSignupState(
            signupAttributes: OnboardingSignupAttributes(
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
          onboardingSignupState: const OnboardingSignupState(
            signupAttributes: OnboardingSignupAttributes(
              title: "title",
              firstName: "firstName",
              lastName: "lastName",
              email: "email",
              password: "password",
            ),
          ),
        ),
      );
      final appState = store.onChange
          .firstWhere((state) => state.onboardingSignupState.signupAttributes.notificationsAllowed != null);

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
          onboardingSignupState: const OnboardingSignupState(
            signupAttributes: OnboardingSignupAttributes(
              title: "title",
              firstName: "firstName",
              lastName: "lastName",
              email: "email",
              password: "password",
            ),
          ),
        ),
      );
      final appState = store.onChange
          .firstWhere((state) => state.onboardingSignupState.signupAttributes.notificationsAllowed != null);

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
          onboardingSignupState: const OnboardingSignupState(
            signupAttributes: OnboardingSignupAttributes(
              title: "title",
              firstName: "firstName",
              lastName: "lastName",
              email: "email",
              password: "password",
            ),
          ),
        ),
      );
      final appState = store.onChange
          .firstWhere((state) => state.onboardingSignupState.signupAttributes.notificationsAllowed != null);

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
  });

  group("Account creation", () {
    const signupAttributes = OnboardingSignupAttributes(
      title: "title",
      firstName: "firstName",
      lastName: "lastName",
      email: "email",
      password: "password",
      notificationsAllowed: true,
    );

    test("When the user account creation is successfull, loading and success properties should be changed", () async {
      // given
      final store = createTestStore(
        authService: FakeAuthService(),
        deviceService: FakeDeviceServiceWithNoDeviceId(),
        deviceFingerprintService: FakeDeviceFingerprintService(),
        onboardingSignupService: FakeOnboardingSignupService(),
        pushNotificationService: FakeNotificationService(),
        initialState: createAppState(
          onboardingSignupState: const OnboardingSignupState(
            signupAttributes: signupAttributes,
          ),
        ),
      );
      final appState = store.onChange.firstWhere((state) => state.onboardingSignupState.isSuccessful != null);
      final loadingState = store.onChange.firstWhere((state) => state.onboardingSignupState.isLoading == true);

      // when
      store.dispatch(CreateAccountCommandAction());

      // then
      final onboardingSignupState = (await appState).onboardingSignupState;

      expect((await loadingState).onboardingSignupState.isLoading, true);
      expect(onboardingSignupState.signupAttributes, signupAttributes);
      expect(onboardingSignupState.isSuccessful, true);
    });

    test("When the user account creation fails, loading and success properties should be changed", () async {
      // given
      final store = createTestStore(
        onboardingSignupService: FakeFailingOnboardingSignupService(),
        pushNotificationService: FakeNotificationService(),
        initialState: createAppState(
          onboardingSignupState: const OnboardingSignupState(
            signupAttributes: signupAttributes,
          ),
        ),
      );
      final appState = store.onChange.firstWhere((state) => state.onboardingSignupState.isSuccessful != null);
      final loadingState = store.onChange.firstWhere((state) => state.onboardingSignupState.isLoading == true);

      // when
      store.dispatch(CreateAccountCommandAction());

      // then
      final onboardingSignupState = (await appState).onboardingSignupState;

      expect((await loadingState).onboardingSignupState.isLoading, true);
      expect(onboardingSignupState.signupAttributes, signupAttributes);
      expect(onboardingSignupState.isSuccessful, false);
      expect(onboardingSignupState.errorType, OnboardingSignupErrorType.unknown);
    });

    test("When the user account creation fails because email is already taken, the error type should be changed",
        () async {
      // given
      final store = createTestStore(
        onboardingSignupService: FakeFailingOnboardingSignupServiceWithDuplicateEmail(),
        pushNotificationService: FakeNotificationService(),
        initialState: createAppState(
          onboardingSignupState: const OnboardingSignupState(signupAttributes: signupAttributes),
        ),
      );
      final appState = store.onChange.firstWhere((state) => state.onboardingSignupState.isSuccessful != null);
      final loadingState = store.onChange.firstWhere((state) => state.onboardingSignupState.isLoading == true);

      // when
      store.dispatch(CreateAccountCommandAction());

      // then
      final onboardingSignupState = (await appState).onboardingSignupState;

      expect((await loadingState).onboardingSignupState.isLoading, true);
      expect(onboardingSignupState.signupAttributes, signupAttributes);
      expect(onboardingSignupState.isSuccessful, false);
      expect(onboardingSignupState.errorType, OnboardingSignupErrorType.emailAlreadyExists);
    });
  });

  test("When the user goes back from the stepper, the onboarding signup should be reseted", () async {
    // given
    const initialOnboardingAttributes = OnboardingSignupAttributes();

    final store = createTestStore(
      initialState: createAppState(
        onboardingSignupState: const OnboardingSignupState(
          signupAttributes: OnboardingSignupAttributes(
            title: "title",
            firstName: "firstName",
            lastName: "lastName",
            email: "email",
            password: "password",
            notificationsAllowed: true,
          ),
        ),
      ),
    );
    final appState = store.onChange
        .firstWhere((state) => state.onboardingSignupState.signupAttributes == initialOnboardingAttributes);

    // when
    store.dispatch(ResetOnboardingSignupCommandAction());

    // then
    final onboardingSignupState = (await appState).onboardingSignupState;
    expect(onboardingSignupState.signupAttributes, initialOnboardingAttributes);
  });
}
