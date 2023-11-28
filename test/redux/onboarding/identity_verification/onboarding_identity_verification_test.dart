import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:solarisdemo/infrastructure/onboarding/identity_verification/onboarding_identity_verification_service.dart';
import 'package:solarisdemo/models/auth/auth_type.dart';
import 'package:solarisdemo/models/documents/document.dart';
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
    final _onboardingIdentityVerificationService = MockOnbordingIdentityVerificationService();

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

    test("When the bank identification status is pending, the request should retry", () async {
      // given
      int retryAttempt = 0;

      when(_onboardingIdentityVerificationService.getSignupIdentificationInfo(user: authInitializedState.cognitoUser))
          .thenAnswer(
        (_) async {
          if (retryAttempt == 0) {
            retryAttempt++;
            return const IdentityVerificationServiceErrorResponse(
              errorType: OnboardingIdentityVerificationErrorType.pendingIdentification,
            );
          }

          retryAttempt++;
          return const GetSignupIdentificationInfoSuccessResponse(
            identificationStatus: OnboardingIdentificationStatus.authorizationRequired,
            documents: [
              Document(
                id: "id",
                documentType: DocumentType.creditCardContract,
                fileType: "fileType",
                fileSize: 1024,
              ),
            ],
          );
        },
      );

      final store = createTestStore(
        onboardingIdentityVerificationService: _onboardingIdentityVerificationService,
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

      verify(_onboardingIdentityVerificationService.getSignupIdentificationInfo(user: authInitializedState.cognitoUser))
          .called(2);
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
}
