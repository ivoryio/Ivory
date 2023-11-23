import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/models/auth/auth_type.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identification_status.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identity_verification_error_type.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/documents/documents_state.dart';
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

  group("Bank identification", () {
    test("When fetching the bank identification, the state should change to loading", () async {
      // given
      final store = createTestStore(
        onboardingIdentityVerificationService: FakeOnbordingIdentityVerificationService(),
        initialState: createAppState(
          authState: authInitializedState,
          onboardingIdentityVerificationState: const OnboardingIdentityVerificationState(
            urlForIntegration: "https://example.com",
            isLoading: false,
          ),
        ),
      );

      final appState =
          store.onChange.firstWhere((state) => state.onboardingIdentityVerificationState.isLoading == true);

      // when
      store.dispatch(GetSignupIdentificationInfoCommandAction());

      // then
      final identityVerificationState = (await appState).onboardingIdentityVerificationState;

      expect(identityVerificationState.isLoading, true);
    });

    test(
        "When fetching the bank identification is successful, the identification status and documents state should change",
        () async {
      // given
      final store = createTestStore(
        onboardingIdentityVerificationService: FakeOnbordingIdentityVerificationService(),
        initialState: createAppState(
          authState: authInitializedState,
          documentsState: DocumentsFetchedState(documents: const []),
          onboardingIdentityVerificationState: const OnboardingIdentityVerificationState(
            urlForIntegration: "https://example.com",
            isLoading: false,
            status: null,
          ),
        ),
      );

      final appState = store.onChange.firstWhere((state) => state.onboardingIdentityVerificationState.status != null);
      final identityVerificationLoadingState =
          store.onChange.firstWhere((state) => state.onboardingIdentityVerificationState.isLoading);
      final documentsFetchedState = store.onChange.firstWhere((state) =>
          state.documentsState is DocumentsFetchedState &&
          (state.documentsState as DocumentsFetchedState).documents.isNotEmpty);

      // when
      store.dispatch(GetSignupIdentificationInfoCommandAction());

      // then
      final identityVerificationState = (await appState).onboardingIdentityVerificationState;
      final loadingState = (await identityVerificationLoadingState).onboardingIdentityVerificationState;
      final documentsState = (await documentsFetchedState).documentsState as DocumentsFetchedState;

      expect(loadingState.isLoading, true);
      expect(identityVerificationState.isLoading, false);
      expect(identityVerificationState.status, OnboardingIdentificationStatus.authorizationRequired);
      expect(documentsState.documents.isNotEmpty, true);
    });

    test("When fetching the bank identification has failed, the state errorType should change", () async {
      // given
      final store = createTestStore(
        onboardingIdentityVerificationService: FakeFailingOnbordingIdentityVerificationService(),
        initialState: createAppState(
          authState: authInitializedState,
          documentsState: DocumentsFetchedState(documents: const []),
          onboardingIdentityVerificationState: const OnboardingIdentityVerificationState(
            urlForIntegration: "https://example.com",
            isLoading: false,
            status: null,
          ),
        ),
      );
      final appState =
          store.onChange.firstWhere((state) => state.onboardingIdentityVerificationState.errorType != null);

      // when
      store.dispatch(GetSignupIdentificationInfoCommandAction());

      // then
      final identityVerificationState = (await appState).onboardingIdentityVerificationState;

      expect(identityVerificationState.isLoading, false);
      expect(identityVerificationState.errorType, OnboardingIdentityVerificationErrorType.unknown);
    });
  });
}
