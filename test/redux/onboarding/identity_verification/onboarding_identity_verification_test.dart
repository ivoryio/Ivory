import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/models/auth/auth_type.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identity_verification_error_type.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/onboarding/identity_verification/onboarding_identity_verification_action.dart';
import 'package:solarisdemo/redux/onboarding/identity_verification/onboarding_identity_verification_state.dart';

import '../../../setup/create_app_state.dart';
import '../../../setup/create_store.dart';
import '../../auth/auth_mocks.dart';
import 'onboarding_identity_verification_mocks.dart';

void main() {
  final mockUser = MockUser();
  final authInitializedState = AuthenticationInitializedState(mockUser, AuthType.onboarding);

  const accountName = 'accountName';
  const iban = 'iban';
  const urlForIntegration = 'https://url.com';

  test('when creating urlForIntegration it should display loading state', () async {
    //given
    final store = createTestStore(
      onboardingIdentityVerificationService: FakeOnbordingIdentityVerificationService(),
      initialState: createAppState(
          authState: authInitializedState,
          onboardingIdentityVerificationState: const OnboardingIdentityVerificationState(
            urlForIntegration: null,
            isLoading: false,
          )),
    );

    final appState = store.onChange.firstWhere((state) => state.onboardingIdentityVerificationState.isLoading == true);
    //when
    store.dispatch(CreateIdentificationCommandAction(accountName: accountName, iban: iban));
    //then
    final identityVerificationState = (await appState).onboardingIdentityVerificationState;

    expect(identityVerificationState.isLoading, true);
  });

  test('when created urlForIntegration successful should update with success', () async {
    //given
    final store = createTestStore(
      onboardingIdentityVerificationService: FakeOnbordingIdentityVerificationService(),
      initialState: createAppState(
          authState: authInitializedState,
          onboardingIdentityVerificationState: const OnboardingIdentityVerificationState(
            urlForIntegration: null,
            isLoading: false,
          )),
    );

    final appState = store.onChange
        .firstWhere((state) => state.onboardingIdentityVerificationState.urlForIntegration == urlForIntegration);
    //when
    store.dispatch(CreateIdentificationCommandAction(accountName: accountName, iban: iban));
    //then
    final identityVerificationState = (await appState).onboardingIdentityVerificationState;

    expect(identityVerificationState.isLoading, false);
    expect(identityVerificationState.errorType, null);
    expect(identityVerificationState.urlForIntegration, urlForIntegration);
  });

  test('when created urlForIntegration unsuccessful should update with error', () async {
    //given
    final store = createTestStore(
      onboardingIdentityVerificationService: FakeFailingOnbordingIdentityVerificationService(),
      initialState: createAppState(
          authState: authInitializedState,
          onboardingIdentityVerificationState: const OnboardingIdentityVerificationState(
            urlForIntegration: null,
            isLoading: false,
          )),
    );

    final appState = store.onChange.firstWhere((state) => state.onboardingIdentityVerificationState.errorType != null);
    //when
    store.dispatch(CreateIdentificationCommandAction(accountName: accountName, iban: iban));
    //then
    final identityVerificationState = (await appState).onboardingIdentityVerificationState;

    expect(identityVerificationState.isLoading, false);
    expect(identityVerificationState.errorType, OnboardingIdentityVerificationErrorType.unknown);
    expect(identityVerificationState.urlForIntegration, null);
  });

  group('sign with tan', () {
    test('when tan was sent it should display loading state', () async {
      //given
      final store = createTestStore(
        onboardingIdentityVerificationService: FakeOnbordingSignWithTanService(),
        initialState: createAppState(
          authState: authInitializedState,
          onboardingIdentityVerificationState: const OnboardingIdentityVerificationState(
            isLoading: false,
            isTanSent: true,
          ),
        ),
      );

      final appState =
          store.onChange.firstWhere((state) => state.onboardingIdentityVerificationState.isLoading == true);
      //when
      store.dispatch(SignWithTanCommandAction(tan: '212212'));
      //then
      final signWithTanState = (await appState).onboardingIdentityVerificationState;

      expect(signWithTanState.isLoading, true);
      expect(signWithTanState.errorType, null);
      expect(signWithTanState.isTanSent, null);
    });

    test('when tan successful sent it should update with success', () async {
      //given
      final store = createTestStore(
        onboardingIdentityVerificationService: FakeOnbordingSignWithTanService(),
        initialState: createAppState(
          authState: authInitializedState,
          onboardingIdentityVerificationState: const OnboardingIdentityVerificationState(
            isLoading: false,
            isTanSent: true,
          ),
        ),
      );

      final appState = store.onChange.firstWhere((state) =>
          state.onboardingIdentityVerificationState.isTanSent == true &&
          state.onboardingIdentityVerificationState.isLoading == false);
      //when
      store.dispatch(SignWithTanCommandAction(tan: '212212'));
      //then
      final signWithTanState = (await appState).onboardingIdentityVerificationState;

      expect(signWithTanState.isLoading, false);
      expect(signWithTanState.errorType, null);
      expect(signWithTanState.isTanSent, true);
    });

    test('when tan unsuccessful sent it should update with error', () async {
      //given
      final store = createTestStore(
        onboardingIdentityVerificationService: FakeFailingOnbordingSignWithTanService(),
        initialState: createAppState(
          authState: authInitializedState,
          onboardingIdentityVerificationState: const OnboardingIdentityVerificationState(
            isLoading: false,
            errorType: OnboardingIdentityVerificationErrorType.unknown,
            isTanSent: true,
          ),
        ),
      );

      final appState =
          store.onChange.firstWhere((state) => state.onboardingIdentityVerificationState.errorType != null);
      //when
      store.dispatch(SignWithTanCommandAction(tan: '212212'));
      //then
      final signWithTanState = (await appState).onboardingIdentityVerificationState;

      expect(signWithTanState.isLoading, false);
      expect(signWithTanState.errorType, OnboardingIdentityVerificationErrorType.unknown);
      expect(signWithTanState.isTanSent, true);
    });
  });
}
