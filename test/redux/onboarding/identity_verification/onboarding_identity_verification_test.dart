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

  group("Bank identification authorization", () {
    test("When authorizing the bank identification, the state isLoading should be true and status should exist",
        () async {
      // given
      final store = createTestStore(
        onboardingIdentityVerificationService: FakeOnbordingIdentityVerificationService(),
        initialState: createAppState(
          authState: authInitializedState,
          onboardingIdentityVerificationState: const OnboardingIdentityVerificationState(
            urlForIntegration: "https://example.com",
            isLoading: false,
            status: OnboardingIdentificationStatus.authorizationRequired,
          ),
        ),
      );

      final appState =
          store.onChange.firstWhere((state) => state.onboardingIdentityVerificationState.isLoading == true);

      // when
      store.dispatch(AuthorizeIdentificationSigningCommandAction());

      // then
      final identityVerificationState = (await appState).onboardingIdentityVerificationState;

      expect(identityVerificationState.isLoading, true);
      expect(identityVerificationState.status, OnboardingIdentificationStatus.authorizationRequired);
    });

    test(
        "When authorizing the bank identification is successful, the state isAuthorized should change and identificationStatus should not change",
        () async {
      // given
      final store = createTestStore(
        onboardingIdentityVerificationService: FakeOnbordingIdentityVerificationService(),
        initialState: createAppState(
          authState: authInitializedState,
          onboardingIdentityVerificationState: const OnboardingIdentityVerificationState(
            urlForIntegration: "https://example.com",
            isLoading: false,
            status: OnboardingIdentificationStatus.authorizationRequired,
          ),
        ),
      );

      final appState =
          store.onChange.firstWhere((state) => state.onboardingIdentityVerificationState.isAuthorized == true);
      final identityVerificationLoadingState =
          store.onChange.firstWhere((state) => state.onboardingIdentityVerificationState.isLoading);

      // when
      store.dispatch(AuthorizeIdentificationSigningCommandAction());

      // then
      final identityVerificationState = (await appState).onboardingIdentityVerificationState;
      final loadingState = (await identityVerificationLoadingState).onboardingIdentityVerificationState;

      expect(loadingState.isLoading, true);
      expect(identityVerificationState.isLoading, false);
      expect(identityVerificationState.isAuthorized, true);
      expect(identityVerificationState.status, OnboardingIdentificationStatus.authorizationRequired);
    });

    test("When authorizing the bank identification has failed, the state errorType should change", () async {
      // given
      final store = createTestStore(
        onboardingIdentityVerificationService: FakeFailingOnbordingIdentityVerificationService(),
        initialState: createAppState(
          authState: authInitializedState,
          onboardingIdentityVerificationState: const OnboardingIdentityVerificationState(
            urlForIntegration: "https://example.com",
            isLoading: false,
            status: OnboardingIdentificationStatus.authorizationRequired,
          ),
        ),
      );
      final appState =
          store.onChange.firstWhere((state) => state.onboardingIdentityVerificationState.errorType != null);

      // when
      store.dispatch(AuthorizeIdentificationSigningCommandAction());

      // then
      final identityVerificationState = (await appState).onboardingIdentityVerificationState;

      expect(identityVerificationState.isLoading, false);
      expect(identityVerificationState.errorType, OnboardingIdentityVerificationErrorType.unknown);
    });
  });

  group('sign with tan', () {
    test('when tan was sent it should display loading state', () async {
      //given
      final store = createTestStore(
        onboardingIdentityVerificationService: FakeOnbordingIdentityVerificationService(),
        initialState: createAppState(
          authState: authInitializedState,
          onboardingIdentityVerificationState: const OnboardingIdentityVerificationState(
            isLoading: false,
            isTanConfirmed: true,
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
      expect(signWithTanState.isTanConfirmed, null);
    });

    test('when tan successful sent it should update with success', () async {
      //given
      final store = createTestStore(
        onboardingIdentityVerificationService: FakeOnbordingIdentityVerificationService(),
        initialState: createAppState(
          authState: authInitializedState,
          onboardingIdentityVerificationState: const OnboardingIdentityVerificationState(
            isLoading: false,
            isTanConfirmed: null,
          ),
        ),
      );

      final appState = store.onChange.firstWhere((state) =>
          state.onboardingIdentityVerificationState.isTanConfirmed == true &&
          state.onboardingIdentityVerificationState.isLoading == false);
      //when
      store.dispatch(SignWithTanCommandAction(tan: '212212'));
      //then
      final signWithTanState = (await appState).onboardingIdentityVerificationState;

      expect(signWithTanState.isLoading, false);
      expect(signWithTanState.errorType, null);
      expect(signWithTanState.isTanConfirmed, true);
    });

    test('when tan unsuccessful sent it should update with error', () async {
      //given
      final store = createTestStore(
        onboardingIdentityVerificationService: FakeFailingOnbordingIdentityVerificationService(),
        initialState: createAppState(
          authState: authInitializedState,
          onboardingIdentityVerificationState: const OnboardingIdentityVerificationState(
            isLoading: false,
            errorType: null,
            isTanConfirmed: null,
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
      expect(signWithTanState.isTanConfirmed, null);
    });
  });

  group('fetching credit limit', () {
    const mockCreditLimit = 1000;

    test('when credit limit was ordered it should display loading state', () async {
      //given
      final store = createTestStore(
        onboardingIdentityVerificationService: FakeOnbordingIdentityVerificationService(),
        initialState: createAppState(
          authState: authInitializedState,
          onboardingIdentityVerificationState: const OnboardingIdentityVerificationState(
            isLoading: false,
            creditLimit: null,
          ),
        ),
      );

      final appState =
          store.onChange.firstWhere((state) => state.onboardingIdentityVerificationState.isLoading == true);
      //when
      store.dispatch(GetCreditLimitCommandAction());
      //then
      final creditLimitState = (await appState).onboardingIdentityVerificationState;

      expect(creditLimitState.isLoading, true);
      expect(creditLimitState.creditLimit, null);
    });

    test('when credit limit is successful fetched it should be displayed', () async {
      //given
      final store = createTestStore(
        onboardingIdentityVerificationService: FakeOnbordingIdentityVerificationService(),
        initialState: createAppState(
          authState: authInitializedState,
          onboardingIdentityVerificationState: const OnboardingIdentityVerificationState(
            isLoading: false,
            creditLimit: null,
          ),
        ),
      );

      final appState = store.onChange.firstWhere((state) =>
          state.onboardingIdentityVerificationState.creditLimit != null &&
          state.onboardingIdentityVerificationState.isLoading == false);
      //when
      store.dispatch(GetCreditLimitCommandAction());
      //then
      final creditLimitState = (await appState).onboardingIdentityVerificationState;

      expect(creditLimitState.isLoading, false);
      expect(creditLimitState.creditLimit, mockCreditLimit ~/ 100);
    });

    test("when fetch credit limit has failed it should update with error", () async {
      //given
      final store = createTestStore(
        onboardingIdentityVerificationService: FakeFailingOnbordingIdentityVerificationService(),
        initialState: createAppState(
          authState: authInitializedState,
          onboardingIdentityVerificationState: const OnboardingIdentityVerificationState(
            isLoading: false,
            creditLimit: null,
          ),
        ),
      );

      final appState =
          store.onChange.firstWhere((state) => state.onboardingIdentityVerificationState.errorType != null);
      //when
      store.dispatch(GetCreditLimitCommandAction());
      //then
      final creditLimitState = (await appState).onboardingIdentityVerificationState;

      expect(creditLimitState.isLoading, false);
      expect(creditLimitState.errorType, OnboardingIdentityVerificationErrorType.fetchCreditLimitFailed);
      expect(creditLimitState.creditLimit, null);
    });
  });

  group("finalize identification", () {
    const mockCreditLimit = 1000;
    test('when requesting the finalizing step, it should display the credit limit and loading state', () async {
      //given
      final store = createTestStore(
        onboardingIdentityVerificationService: FakeOnbordingIdentityVerificationService(),
        initialState: createAppState(
          authState: authInitializedState,
          onboardingIdentityVerificationState: const OnboardingIdentityVerificationState(
            isLoading: false,
            creditLimit: mockCreditLimit,
          ),
        ),
      );

      final appState = store.onChange.firstWhere((state) =>
          state.onboardingIdentityVerificationState.isLoading == true &&
          state.onboardingIdentityVerificationState.creditLimit == mockCreditLimit);

      //when
      store.dispatch(FinalizeIdentificationCommandAction());
      //then
      final creditLimitState = (await appState).onboardingIdentityVerificationState;

      expect(creditLimitState.isLoading, true);
      expect(creditLimitState.creditLimit, mockCreditLimit);
    });

    test(
        "when finalize is successful, the isIdentificationSuccessful should be true and creditLimit should not be null",
        () async {
      // given
      final store = createTestStore(
        onboardingIdentityVerificationService: FakeOnbordingIdentityVerificationService(),
        initialState: createAppState(
          authState: authInitializedState,
          onboardingIdentityVerificationState: const OnboardingIdentityVerificationState(
            isLoading: false,
            creditLimit: mockCreditLimit,
            isIdentificationSuccessful: null,
          ),
        ),
      );

      final appState = store.onChange.firstWhere((state) =>
          state.onboardingIdentityVerificationState.isLoading == false &&
          state.onboardingIdentityVerificationState.isIdentificationSuccessful == true);

      // when
      store.dispatch(FinalizeIdentificationCommandAction());

      // then
      final creditLimitState = (await appState).onboardingIdentityVerificationState;

      expect(creditLimitState.isLoading, false);
      expect(creditLimitState.isIdentificationSuccessful, true);
      expect(creditLimitState.creditLimit, mockCreditLimit);
    });

    test(
        "when finalize has failed, the errorType and creditLimit should not be null and isIdentificationSuccessful should be false",
        () async {
      // given
      final store = createTestStore(
        onboardingIdentityVerificationService: FakeFailingOnbordingIdentityVerificationService(),
        initialState: createAppState(
          authState: authInitializedState,
          onboardingIdentityVerificationState: const OnboardingIdentityVerificationState(
            isLoading: false,
            creditLimit: mockCreditLimit,
            isIdentificationSuccessful: null,
          ),
        ),
      );

      final appState = store.onChange.firstWhere((state) =>
          state.onboardingIdentityVerificationState.isLoading == false &&
          state.onboardingIdentityVerificationState.errorType != null &&
          state.onboardingIdentityVerificationState.creditLimit != null &&
          state.onboardingIdentityVerificationState.isIdentificationSuccessful == false);

      // when
      store.dispatch(FinalizeIdentificationCommandAction());

      // then
      final creditLimitState = (await appState).onboardingIdentityVerificationState;

      expect(creditLimitState.isLoading, false);
      expect(creditLimitState.errorType, OnboardingIdentityVerificationErrorType.finalizeIdentificationFailed);
      expect(creditLimitState.creditLimit, mockCreditLimit);
      expect(creditLimitState.isIdentificationSuccessful, false);
    });
  });
}
